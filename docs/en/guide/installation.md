# Installation

## Requirements

- A Linux server (Ubuntu 22.04+, Debian 11+ or similar) with root access
- 1 GB RAM minimum (2 GB recommended for building the Docker image)
- Optional but recommended: a domain pointing to the server

## Quick install (Docker)

```bash
sudo bash -c "$(curl -sL https://github.com/naaviiid/pasban/raw/master/scripts/pasban.sh)" @ install
```

| Item | Location |
| --- | --- |
| Config | `/opt/pasban/.env` |
| Xray config | `/var/lib/pasban/xray_config.json` |
| Database | `/var/lib/pasban/db.sqlite3` |

Create a sudo admin:

```bash
pasban cli admin create --sudo
```

::: warning Dashboard access
Until SSL is configured, Pasban only listens on `127.0.0.1:8000` and subscription links won't work externally. Either set `UVICORN_SSL_CERTFILE` / `UVICORN_SSL_KEYFILE` in `.env`, put it behind a reverse proxy, or connect temporarily through an SSH tunnel:

```bash
ssh -L 8000:localhost:8000 root@SERVER_IP
```

Then open `http://localhost:8000/dashboard/`.
:::

## Management commands

| Command | Action |
| --- | --- |
| `pasban up` / `down` / `restart` | Start / stop / restart |
| `pasban status` | Container status |
| `pasban logs` | Follow logs |
| `pasban edit` | Edit `.env` |
| `pasban cli ...` | Run the CLI inside the container |
| `pasban update` | Pull latest source and rebuild |
| `pasban uninstall` | Remove Pasban |

## Manual install

```bash
git clone https://github.com/naaviiid/pasban.git && cd pasban
sudo bash scripts/install_xray.sh
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
alembic upgrade head
cp .env.example .env
sudo ln -s $(pwd)/pasban-cli.py /usr/bin/pasban-cli && sudo chmod +x /usr/bin/pasban-cli
pasban-cli admin create --sudo
python3 main.py
```

Run as a systemd service:

```bash
sudo ./install_service.sh
sudo systemctl enable --now pasban.service
```
