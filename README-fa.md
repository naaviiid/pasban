<p align="center">
  <img width="140" src="app/dashboard/public/statics/favicon/android-chrome-512x512.png">
</p>

<h1 align="center">پاسبان (Pasban)</h1>

<p align="center">
  پنل مدیریت کاربران پروکسی، بر پایه‌ی <a href="https://github.com/XTLS/Xray-core">Xray-core</a>
</p>

<p align="center">
  <a href="./README.md">English</a> / <a href="./README-fa.md">فارسی</a>
</p>

> پاسبان یک فورک از پروژه‌ی متن‌باز [Marzban](https://github.com/Gozargah/Marzban) است و تحت همان مجوز **AGPL-3.0** منتشر می‌شود.

## امکانات

- رابط کاربری وب و REST API داخلی
- پشتیبانی از پروتکل‌های **Vmess**، **VLESS**، **Trojan** و **Shadowsocks**
- چند پروتکل برای هر کاربر و چند کاربر روی هر inbound
- پشتیبانی از چند سرور (نود)
- محدودیت حجم و زمان، و محدودیت دوره‌ای حجم (روزانه، هفتگی و ...)
- لینک سابسکریپشن سازگار با V2ray، Clash و ClashMeta، و ساخت خودکار لینک اشتراک‌گذاری و QR code
- مانیتورینگ منابع سرور و مصرف ترافیک
- پشتیبانی از TLS و REALITY
- ربات تلگرام و CLI داخلی
- چند ادمین (sudo و غیر sudo)

## نصب سریع (Docker)

```bash
sudo bash -c "$(curl -sL https://github.com/naaviiid/pasban/raw/master/scripts/pasban.sh)" @ install
```

بعد از نصب:

- بعد از تنظیم SSL، پنل روی `https://YOUR_DOMAIN:8000/dashboard/` در دسترس است. تا قبل از آن فقط روی `127.0.0.1` گوش می‌دهد و باید با `ssh -L 8000:localhost:8000 root@SERVER_IP` وصل شوید.
- فایل تنظیمات: `/opt/pasban/.env`
- دیتابیس و کانفیگ Xray: `/var/lib/pasban`

ساخت ادمین sudo:

```bash
pasban cli admin create --sudo
```

دستورهای اسکریپت مدیریت:

```bash
pasban help        # راهنما
pasban restart     # ری‌استارت
pasban logs        # مشاهده لاگ‌ها
pasban edit        # ویرایش .env
pasban update      # آپدیت از روی مخزن
pasban uninstall   # حذف
```

## نصب دستی (بدون Docker)

```bash
# نصب Xray
sudo bash scripts/install_xray.sh

# نصب پیش‌نیازها
python3 -m pip install -r requirements.txt

# ساخت دیتابیس و فایل تنظیمات
alembic upgrade head
cp .env.example .env

# نصب CLI
sudo ln -s $(pwd)/pasban-cli.py /usr/bin/pasban-cli
sudo chmod +x /usr/bin/pasban-cli
pasban-cli completion install
pasban-cli admin create --sudo

# اجرا
python3 main.py
```

اجرا به‌صورت سرویس systemd:

```bash
sudo chmod +x install_service.sh
sudo ./install_service.sh
sudo systemctl enable --now pasban.service
```

## نود (چند سرور)

پاسبان با [Marzban-node](https://github.com/Gozargah/Marzban-node) سازگار است و می‌توانید از همان برای اضافه کردن سرورهای جدید استفاده کنید.

## تنظیمات

همه‌ی متغیرهای محیطی در فایل [`.env.example`](.env.example) آمده‌اند (پورت، مسیر داشبورد، ربات تلگرام، webhook، تمپلیت‌ها و ...).
مستندات کامل این تنظیمات در [مستندات مرزبان](https://gozargah.github.io/marzban/fa/docs/configuration) موجود است و برای پاسبان هم صدق می‌کند؛ فقط به‌جای `marzban` از `pasban` استفاده کنید.

## مستندات

راهنمای کامل: https://naaviiid.github.io/pasban/

## مجوز

این پروژه تحت مجوز [AGPL-3.0](LICENSE) منتشر شده است. اگر پاسبان را به‌صورت سرویس در اختیار دیگران قرار می‌دهید، باید سورس (همراه با تغییرات‌تان) را هم در دسترس آن‌ها بگذارید. جزئیات در [NOTICE](NOTICE.md).
