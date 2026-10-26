import base64
import json
import os
from datetime import datetime
from urllib.parse import unquote

import jdatetime
import qrcode
import yaml
from markupsafe import Markup
from qrcode.image.svg import SvgPathImage

from app.utils.system import readable_size


def to_yaml(obj):
    if not obj:
        return ""

    return yaml.dump(obj, allow_unicode=True, indent=2)


def exclude_keys(obj, *target_keys):
    return {key: val for key, val in obj.items() if key not in target_keys}


def only_keys(obj, *target_keys):
    return {key: val for key, val in obj.items() if key in target_keys}


def datetimeformat(dt):
    if isinstance(dt, int):
        dt = datetime.fromtimestamp(dt)
    formatted_datetime = dt.strftime('%Y-%m-%d %H:%M:%S')
    return formatted_datetime


def env_override(value, key):
    return os.getenv(key, value)


def jalali(value):
    """Unix timestamp or datetime -> Jalali date string, e.g. 1405/08/04"""
    if not value:
        return ""
    if isinstance(value, (int, float)):
        value = datetime.fromtimestamp(value)
    return jdatetime.datetime.fromgregorian(datetime=value).strftime('%Y/%m/%d')


def link_name(link):
    """Human readable name of a share link (the #remark, or 'ps' for vmess)"""
    try:
        if link.startswith("vmess://"):
            raw = link[8:]
            data = json.loads(base64.b64decode(raw + "=" * (-len(raw) % 4)).decode())
            return data.get("ps") or "vmess"
        if "#" in link:
            return unquote(link.rsplit("#", 1)[1])
        return link.split("://", 1)[0]
    except Exception:
        return link.split("://", 1)[0]


def qr_svg(text):
    """Inline SVG QR code, rendered on the server (works without any CDN)"""
    img = qrcode.make(text, image_factory=SvgPathImage, box_size=10, border=2)
    svg = img.to_string(encoding="unicode")
    return Markup(svg[svg.find("<svg"):])


CUSTOM_FILTERS = {
    "yaml": to_yaml,
    "except": exclude_keys,
    "only": only_keys,
    "datetime": datetimeformat,
    "bytesformat": readable_size,
    "jalali": jalali,
    "link_name": link_name,
    "qr_svg": qr_svg,
}
