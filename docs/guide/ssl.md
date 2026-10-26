# گواهی SSL و دامنه

برای اینکه داشبورد و لینک‌های سابسکریپشن از بیرون سرور در دسترس باشند، پاسبان به گواهی SSL نیاز دارد.

## ۱. تنظیم دامنه

در پنل DNS دامنه‌ی خود، یک رکورد `A` بسازید که به IP سرور اشاره کند. مثلاً `panel.example.com`.

::: warning Cloudflare
هنگام گرفتن گواهی، پروکسی Cloudflare (ابر نارنجی) را خاموش کنید.
:::

## ۲. گرفتن گواهی با acme.sh

پورت 80 سرور باید آزاد و باز باشد.

```bash
# پیش‌نیاز
apt install -y socat cron

# نصب acme.sh
curl https://get.acme.sh | sh -s email=you@example.com
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

# گرفتن گواهی
DOMAIN=panel.example.com
~/.acme.sh/acme.sh --issue --standalone -d "$DOMAIN"

# کپی گواهی به پوشه‌ی پاسبان (و تمدید خودکار)
mkdir -p /var/lib/pasban/certs/$DOMAIN
~/.acme.sh/acme.sh --install-cert -d "$DOMAIN" \
  --key-file       /var/lib/pasban/certs/$DOMAIN/key.pem \
  --fullchain-file /var/lib/pasban/certs/$DOMAIN/fullchain.pem \
  --reloadcmd      "pasban restart"
```

acme.sh گواهی را هر ۶۰ روز خودکار تمدید می‌کند و پاسبان را ری‌استارت می‌کند.

### گواهی Wildcard

برای `*.example.com` باید از روش DNS استفاده کنید. مثلاً با Cloudflare:

```bash
export CF_Token="YOUR_CLOUDFLARE_API_TOKEN"
~/.acme.sh/acme.sh --issue --dns dns_cf -d example.com -d "*.example.com"
```

سپس مثل بالا `--install-cert` را اجرا کنید.

## ۳. تنظیم پاسبان

```bash
pasban edit
```

```ini
UVICORN_SSL_CERTFILE = "/var/lib/pasban/certs/panel.example.com/fullchain.pem"
UVICORN_SSL_KEYFILE = "/var/lib/pasban/certs/panel.example.com/key.pem"
XRAY_SUBSCRIPTION_URL_PREFIX = "https://panel.example.com:8000"
```

```bash
pasban restart
```

حالا داشبورد روی `https://panel.example.com:8000/dashboard/` در دسترس است.

## گواهی self-signed

اگر گواهی معتبر ندارید و از گواهی خودامضا استفاده می‌کنید:

```ini
UVICORN_SSL_CA_TYPE = "private"
```

مرورگر هشدار امنیتی نشان می‌دهد و بعضی نرم‌افزارها لینک سابسکریپشن را قبول نمی‌کنند. فقط برای تست مناسب است.

## استفاده از گواهی در اینباندها

همین گواهی را می‌توانید در `tlsSettings` اینباندهای Xray استفاده کنید. نمونه در [کانفیگ Xray](./xray-config#vmess-websocket-tls).
