# Notice

Pasban is a modified version of **Marzban**
(https://github.com/Gozargah/Marzban), Copyright (C) 2023 Gozargah organization,
licensed under the GNU Affero General Public License v3.0 (see `LICENSE`).

## Changes from upstream (2026-10-26)

- Renamed the project, CLI (`pasban-cli`), service, data paths (`/var/lib/pasban`),
  environment variables (`PASBAN_ADMIN_PASSWORD`) and dashboard branding to "Pasban"
- New logo and favicons
- Removed the donation menu and GitHub star button from the dashboard header
- Xray is installed by a bundled script (`scripts/install_xray.sh`) from the official XTLS releases
- New management/installer script (`scripts/pasban.sh`); `docker-compose.yml` builds from source
- CI publishes images to the GitHub Container Registry of the repository owner
- Bug fixes for Xray 25.8+ REALITY keys and setuptools 81+ (see CHANGELOG.md)

The node TLS server name (`Gozargah` in `app/xray/node.py` and `app/utils/crypto.py`)
is intentionally unchanged so Pasban stays compatible with Marzban-node.

## AGPL-3.0 obligations

If you modify Pasban and let users interact with it over a network (for example, by hosting the
panel for other people), you must offer them the complete corresponding source code of your
version under the same license. Keep this notice and the `LICENSE` file in your distribution.
