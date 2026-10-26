#!/usr/bin/env bash
# Pasban management script (install / update / start / stop / logs / cli ...)
#
# Quick install:
#   sudo bash -c "$(curl -sL https://github.com/naaviiid/pasban/raw/master/scripts/pasban.sh)" @ install
#
# By default the image is built from source on the server. To use a prebuilt image instead:
#   PASBAN_IMAGE=ghcr.io/naaviiid/pasban:latest pasban install
set -e

APP_NAME="pasban"
REPO_URL="${PASBAN_REPO:-https://github.com/naaviiid/pasban.git}"
REPO_BRANCH="${PASBAN_BRANCH:-master}"
SCRIPT_URL="${PASBAN_SCRIPT_URL:-https://github.com/naaviiid/pasban/raw/master/scripts/pasban.sh}"
IMAGE="${PASBAN_IMAGE:-}"

APP_DIR="/opt/$APP_NAME"
SRC_DIR="$APP_DIR/src"
DATA_DIR="/var/lib/$APP_NAME"
COMPOSE_FILE="$APP_DIR/docker-compose.yml"
ENV_FILE="$APP_DIR/.env"
BIN_PATH="/usr/local/bin/$APP_NAME"

red()    { echo -e "\033[1;31m$*\033[0m"; }
green()  { echo -e "\033[1;32m$*\033[0m"; }
yellow() { echo -e "\033[1;33m$*\033[0m"; }
die()    { red "$*"; exit 1; }

check_root() { [ "$(id -u)" = "0" ] || die "This command must be run as root."; }

is_installed() { [ -f "$COMPOSE_FILE" ]; }
need_installed() { is_installed || die "$APP_NAME is not installed. Run: $APP_NAME install"; }

compose() {
    if docker compose version >/dev/null 2>&1; then
        docker compose -f "$COMPOSE_FILE" -p "$APP_NAME" "$@"
    elif command -v docker-compose >/dev/null 2>&1; then
        docker-compose -f "$COMPOSE_FILE" -p "$APP_NAME" "$@"
    else
        die "docker compose not found."
    fi
}

install_package() {
    if command -v apt-get >/dev/null 2>&1; then
        apt-get update -qq && apt-get install -y -qq "$@"
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y -q "$@"
    elif command -v yum >/dev/null 2>&1; then
        yum install -y -q "$@"
    elif command -v pacman >/dev/null 2>&1; then
        pacman -Sy --noconfirm --quiet "$@"
    else
        die "Unsupported package manager. Install manually: $*"
    fi
}

ensure_deps() {
    for pkg in curl git; do
        command -v "$pkg" >/dev/null 2>&1 || install_package "$pkg"
    done
    if ! command -v docker >/dev/null 2>&1; then
        yellow "Installing Docker..."
        curl -fsSL https://get.docker.com | sh
    fi
    systemctl enable --now docker >/dev/null 2>&1 || true
}

install_script() {
    if [ -f "$SRC_DIR/scripts/pasban.sh" ]; then
        install -m 755 "$SRC_DIR/scripts/pasban.sh" "$BIN_PATH"
    else
        curl -fsSL "$SCRIPT_URL" -o "$BIN_PATH" && chmod 755 "$BIN_PATH"
    fi
    green "Management script installed: $BIN_PATH"
}

fetch_source() {
    if [ -d "$SRC_DIR/.git" ]; then
        git -C "$SRC_DIR" fetch --depth 1 origin "$REPO_BRANCH"
        git -C "$SRC_DIR" reset --hard "origin/$REPO_BRANCH"
    else
        rm -rf "$SRC_DIR"
        git clone --depth 1 -b "$REPO_BRANCH" "$REPO_URL" "$SRC_DIR"
    fi
}

write_compose() {
    if [ -n "$IMAGE" ]; then
        local image_block="    image: $IMAGE"
    else
        local image_block="    build: $SRC_DIR
    image: $APP_NAME:latest"
    fi
    cat > "$COMPOSE_FILE" <<EOF
services:
  $APP_NAME:
$image_block
    restart: always
    env_file: .env
    network_mode: host
    volumes:
      - $DATA_DIR:$DATA_DIR
EOF
}

write_env() {
    [ -f "$ENV_FILE" ] && { yellow "Keeping existing $ENV_FILE"; return; }
    cp "$SRC_DIR/.env.example" "$ENV_FILE"
    cat >> "$ENV_FILE" <<EOF

# ---- set by $APP_NAME installer ----
XRAY_JSON = "$DATA_DIR/xray_config.json"
SQLALCHEMY_DATABASE_URL = "sqlite:///$DATA_DIR/db.sqlite3"
EOF
}

cmd_install() {
    check_root
    is_installed && die "$APP_NAME is already installed in $APP_DIR. Use '$APP_NAME update'."
    ensure_deps
    mkdir -p "$APP_DIR" "$DATA_DIR"
    # Source is needed for the build, and always for .env.example / xray_config.json
    fetch_source
    [ -f "$DATA_DIR/xray_config.json" ] || cp "$SRC_DIR/xray_config.json" "$DATA_DIR/xray_config.json"
    write_env
    write_compose
    install_script
    yellow "Starting $APP_NAME (first build can take a few minutes)..."
    if [ -n "$IMAGE" ]; then compose pull; else compose build; fi
    compose up -d
    green "$APP_NAME installed."
    echo
    echo "  Config    : $ENV_FILE"
    echo "  Data      : $DATA_DIR"
    echo
    yellow "Create a sudo admin with:  $APP_NAME cli admin create --sudo"
    echo
    echo "Without SSL the panel only listens on 127.0.0.1:8000. Until SSL is set up, open it via an SSH tunnel:"
    echo "  ssh -L 8000:localhost:8000 root@YOUR_SERVER_IP   ->  http://localhost:8000/dashboard/"
    echo "To expose it, set UVICORN_SSL_CERTFILE / UVICORN_SSL_KEYFILE in $ENV_FILE (or use a reverse proxy)."
}

cmd_update() {
    check_root; need_installed
    fetch_source
    install_script
    if [ -n "$IMAGE" ] || ! grep -q "build:" "$COMPOSE_FILE"; then compose pull; else compose build; fi
    compose up -d --remove-orphans
    green "$APP_NAME updated."
}

cmd_uninstall() {
    check_root; need_installed
    read -rp "Remove $APP_NAME? Data in $DATA_DIR is kept unless you confirm separately. [y/N] " a
    [[ "$a" =~ ^[Yy]$ ]] || exit 0
    compose down --rmi local || true
    rm -rf "$APP_DIR"
    read -rp "Also delete data directory $DATA_DIR (database, configs)? [y/N] " b
    [[ "$b" =~ ^[Yy]$ ]] && rm -rf "$DATA_DIR"
    rm -f "$BIN_PATH"
    green "$APP_NAME uninstalled."
}

cmd_edit() {
    need_installed
    "${EDITOR:-nano}" "$ENV_FILE"
    yellow "Run '$APP_NAME restart' to apply changes."
}

usage() {
    cat <<EOF
Usage: $APP_NAME <command>

Commands:
  install      Install $APP_NAME (Docker)
  update       Pull latest source/image and restart
  uninstall    Remove $APP_NAME
  up           Start services
  down         Stop services
  restart      Restart services
  status       Show service status
  logs [-n]    Follow logs (-n: don't follow)
  cli ...      Run pasban-cli inside the container (e.g. cli admin create --sudo)
  edit         Edit $ENV_FILE
  help         Show this help
EOF
}

case "${1:-help}" in
    install)   shift; cmd_install "$@" ;;
    update)    cmd_update ;;
    uninstall) cmd_uninstall ;;
    up)        need_installed; compose up -d ;;
    down)      need_installed; compose down ;;
    restart)   need_installed; compose down; compose up -d ;;
    status)    need_installed; compose ps ;;
    logs)      need_installed; if [ "$2" = "-n" ]; then compose logs --tail 200; else compose logs -f --tail 100; fi ;;
    cli)       need_installed; shift; compose exec "$APP_NAME" pasban-cli "$@" ;;
    edit)      cmd_edit ;;
    help|-h|--help) usage ;;
    *) usage; exit 1 ;;
esac
