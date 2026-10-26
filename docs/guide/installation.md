# نصب

## پیش‌نیازها

- یک سرور لینوکس (Ubuntu 22.04 یا جدیدتر، Debian 11 یا جدیدتر، یا توزیع‌های مشابه)
- دسترسی root
- حداقل ۱ گیگابایت رم (برای ساخت ایمیج Docker، ۲ گیگابایت بهتر است)
- اختیاری ولی توصیه‌شده: یک دامنه که به IP سرور اشاره کند

## نصب سریع (پیشنهادی)

این دستور Docker را نصب می‌کند، سورس را دریافت می‌کند، ایمیج را می‌سازد و پاسبان را اجرا می‌کند:

```bash
sudo bash -c "$(curl -sL https://github.com/naaviiid/pasban/raw/master/scripts/pasban.sh)" @ install
```

بعد از پایان نصب:

| مورد | مقدار |
| --- | --- |
| آدرس داشبورد | `https://YOUR_DOMAIN:8000/dashboard/` (بعد از تنظیم SSL) |
| فایل تنظیمات | `/opt/pasban/.env` |
| کانفیگ Xray | `/var/lib/pasban/xray_config.json` |
| دیتابیس | `/var/lib/pasban/db.sqlite3` |
| سورس | `/opt/pasban/src` |

::: warning دسترسی به داشبورد
تا وقتی گواهی SSL تنظیم نشده، پاسبان برای امنیت **فقط روی `127.0.0.1`** گوش می‌دهد و از بیرون سرور در دسترس نیست. لینک‌های سابسکریپشن هم کار نمی‌کنند. دو راه دارید:

- **راه اصلی:** [گواهی SSL را تنظیم کنید](./ssl)، یا پاسبان را [پشت Nginx](#پشت-nginx) قرار دهید.
- **موقت:** با SSH tunnel از کامپیوتر خودتان وصل شوید:

  ```bash
  ssh -L 8000:localhost:8000 root@SERVER_IP
  ```

  سپس `http://localhost:8000/dashboard/` را در مرورگر خودتان باز کنید.
:::

### ساخت ادمین

```bash
pasban cli admin create --sudo
```

نام کاربری و رمز را وارد کنید و با همین اطلاعات وارد داشبورد شوید.

### استفاده از ایمیج آماده

اگر ایمیج Docker را با GitHub Actions ساخته‌اید (با ساختن یک تگ مثل `v1.0.0`)، می‌توانید به‌جای ساخت روی سرور از آن استفاده کنید:

```bash
sudo PASBAN_IMAGE=ghcr.io/naaviiid/pasban:latest bash -c "$(curl -sL https://github.com/naaviiid/pasban/raw/master/scripts/pasban.sh)" @ install
```

## نصب دستی (بدون Docker)

مناسب توسعه‌دهندگان یا سرورهایی که نمی‌خواهید روی آن‌ها Docker نصب شود. به Python 3.10 یا جدیدتر نیاز دارید.

```bash
# 1. دریافت سورس
git clone https://github.com/naaviiid/pasban.git
cd pasban

# 2. نصب Xray
sudo bash scripts/install_xray.sh

# 3. نصب پکیج‌های پایتون (پیشنهاد: داخل virtualenv)
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# 4. ساخت دیتابیس و فایل تنظیمات
alembic upgrade head
cp .env.example .env

# 5. نصب CLI
sudo ln -s $(pwd)/pasban-cli.py /usr/bin/pasban-cli
sudo chmod +x /usr/bin/pasban-cli
pasban-cli completion install
pasban-cli admin create --sudo

# 6. اجرا
python3 main.py
```

### اجرا به‌صورت سرویس systemd

```bash
sudo chmod +x install_service.sh
sudo ./install_service.sh
sudo systemctl enable --now pasban.service
```

دیدن لاگ‌ها:

```bash
journalctl -u pasban -f
```

## پشت Nginx

اگر می‌خواهید پاسبان پشت Nginx (روی پورت 443) باشد:

```nginx
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name panel.example.com;

    ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    location ~* /(dashboard|statics|sub|api|docs|redoc|openapi.json) {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

در این حالت در `.env` گواهی SSL را برای پاسبان تنظیم نکنید. پاسبان روی `127.0.0.1:8000` گوش می‌دهد و Nginx کار SSL را انجام می‌دهد. در `.env` آدرس سابسکریپشن را هم تنظیم کنید:

```ini
XRAY_SUBSCRIPTION_URL_PREFIX = "https://panel.example.com"
```
