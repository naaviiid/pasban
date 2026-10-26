# تغییر نسخه Xray

ایمیج پاسبان هنگام ساخت، آخرین نسخه‌ی Xray را از [انتشارهای رسمی XTLS](https://github.com/XTLS/Xray-core/releases) نصب می‌کند. برای استفاده از نسخه‌ی دیگر دو راه دارید.

## روش ۱: فایل Xray جداگانه (بدون ساخت دوباره)

```bash
# دانلود نسخه‌ی دلخواه
mkdir -p /var/lib/pasban/xray-core && cd /var/lib/pasban/xray-core
apt install -y unzip wget
wget https://github.com/XTLS/Xray-core/releases/download/v25.1.30/Xray-linux-64.zip
unzip -o Xray-linux-64.zip && rm Xray-linux-64.zip
```

برای سرورهای ARM، فایل `Xray-linux-arm64-v8a.zip` را دانلود کنید.

در `.env`:

```ini
XRAY_EXECUTABLE_PATH = "/var/lib/pasban/xray-core/xray"
```

```bash
pasban restart
```

نسخه‌ی فعلی در داشبورد (بخش Core Settings) و با `GET /api/core` نمایش داده می‌شود.

## روش ۲: ساخت ایمیج با نسخه‌ی مشخص

در `/opt/pasban/docker-compose.yml`:

```yaml
services:
  pasban:
    build:
      context: /opt/pasban/src
      args:
        XRAY_VERSION: v25.1.30
```

```bash
cd /opt/pasban && docker compose -p pasban build && pasban up
```

## نسخه‌ی Xray روی نودها

نودها Xray خودشان را دارند. نسخه‌ی Xray نود را هم هم‌سان با پنل نگه دارید تا کانفیگ‌ها روی هر دو کار کنند.
