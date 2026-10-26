# Changelog

## v1.0.0 (2026-10-26)

First release of Pasban, a rebranded fork of [Marzban](https://github.com/Gozargah/Marzban) v0.8.4.

### Changes from Marzban
- New name and branding: `pasban` CLI, service, data paths (`/var/lib/pasban`), `PASBAN_ADMIN_PASSWORD`, logo and favicons
- New management/installer script (`scripts/pasban.sh`); builds from source or uses a prebuilt image via `PASBAN_IMAGE`
- Xray installed from official XTLS releases by a bundled script (`scripts/install_xray.sh`)
- Docker images published to `ghcr.io/naaviiid/pasban`
- Persian and English documentation site: https://naaviiid.github.io/pasban/
- Removed the donation menu and GitHub star button from the dashboard

### Fixes
- REALITY inbounds failed with Xray 25.8+ because the new `xray x25519` output (`PrivateKey` / `Password`) was not recognised
- The app failed to start with setuptools 81+ (`pkg_resources` removed); APScheduler upgraded to 3.10.4
- Docker build no longer fails when detecting the latest Xray version (broken pipe in `curl | grep`)
- A failed install can now be re-run with the same install command
- CI updated to current GitHub Actions versions and Node.js 20

### Tested
Fresh install on Ubuntu (x86_64) with the one-line installer; admin creation; VLESS + REALITY inbound;
user creation; v2ray / Clash Meta / sing-box subscriptions; a real client connection through REALITY;
traffic accounting; `status`, `restart`, `update`.

Not yet tested: SSL setup, nodes, Telegram bot, `uninstall`, arm64.
