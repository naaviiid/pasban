<p align="center">
  <img width="140" src="app/dashboard/public/statics/favicon/android-chrome-512x512.png">
</p>

<h1 align="center">Pasban</h1>

<p align="center">
  Proxy user management panel powered by <a href="https://github.com/XTLS/Xray-core">Xray-core</a>
</p>

<p align="center">
  <a href="./README.md">English</a> / <a href="./README-fa.md">فارسی</a>
</p>

> Pasban is a fork of the open-source [Marzban](https://github.com/Gozargah/Marzban) project and is released under the same **AGPL-3.0** license.

## Features

- Built-in web UI and REST API
- **Vmess**, **VLESS**, **Trojan** and **Shadowsocks**
- Multiple protocols per user, multiple users per inbound
- Multi-server (node) support
- Traffic and expiry limits, periodic traffic limits
- Subscription links for V2ray, Clash and ClashMeta; auto-generated share links and QR codes
- Server resource and traffic monitoring
- TLS and REALITY
- Telegram bot and built-in CLI
- Multiple admins (sudo and non-sudo)

## Quick install (Docker)

```bash
sudo bash -c "$(curl -sL https://github.com/naaviiid/pasban/raw/master/scripts/pasban.sh)" @ install
```

- Dashboard: `https://YOUR_DOMAIN:8000/dashboard/` once SSL is configured (until then it listens on `127.0.0.1` only; use `ssh -L 8000:localhost:8000 root@SERVER_IP`)
- Config: `/opt/pasban/.env`
- Data (database, Xray config): `/var/lib/pasban`

Create a sudo admin:

```bash
pasban cli admin create --sudo
```

Run `pasban help` for all management commands (`restart`, `logs`, `edit`, `update`, `uninstall`, ...).

## Manual install

```bash
sudo bash scripts/install_xray.sh
python3 -m pip install -r requirements.txt
alembic upgrade head
cp .env.example .env
sudo ln -s $(pwd)/pasban-cli.py /usr/bin/pasban-cli
sudo chmod +x /usr/bin/pasban-cli
pasban-cli completion install
pasban-cli admin create --sudo
python3 main.py
```

As a systemd service:

```bash
sudo chmod +x install_service.sh
sudo ./install_service.sh
sudo systemctl enable --now pasban.service
```

## Nodes

Pasban stays compatible with [Marzban-node](https://github.com/Gozargah/Marzban-node), so you can use it to add extra servers.

## Configuration

All environment variables are listed in [`.env.example`](.env.example). The [Marzban configuration docs](https://gozargah.github.io/marzban/en/docs/configuration) apply as-is; just read `pasban` wherever they say `marzban`.

## Documentation

Full guide: https://naaviiid.github.io/pasban/

## License

[AGPL-3.0](LICENSE). See [NOTICE](NOTICE.md) for attribution and your obligations when running a modified version as a service.
