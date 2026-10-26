# کانفیگ Xray و اینباندها

پاسبان یک فایل کانفیگ استاندارد Xray (`xray_config.json`) را می‌خواند، کاربران را خودش به اینباندها اضافه می‌کند و Xray را اجرا می‌کند. یعنی شما فقط اینباندها را **بدون کاربر** تعریف می‌کنید.

برای ویرایش کانفیگ دو راه دارید:

- **از داشبورد:** دکمه‌ی چرخ‌دنده (Core Settings) در بالای صفحه. بعد از ذخیره، هسته خودکار ری‌استارت می‌شود.
- **از فایل:** `/var/lib/pasban/xray_config.json` را ویرایش کنید و `pasban restart` بزنید.

::: warning قوانین
- هر اینباند باید یک `tag` یکتا داشته باشد. پاسبان اینباندها را با تگ‌شان می‌شناسد.
- آرایه‌ی `clients` را خالی بگذارید. پاسبان آن را پر می‌کند.
- مسیر گواهی‌ها باید داخل `/var/lib/pasban` باشد (در نصب Docker).
- اینباندهایی که نمی‌خواهید پاسبان مدیریت کند را در `XRAY_EXCLUDE_INBOUND_TAGS` بنویسید.
:::

## کانفیگ پیش‌فرض

```json
{
  "log": { "loglevel": "warning" },
  "routing": {
    "rules": [
      { "ip": ["geoip:private"], "outboundTag": "BLOCK", "type": "field" }
    ]
  },
  "inbounds": [
    {
      "tag": "Shadowsocks TCP",
      "listen": "0.0.0.0",
      "port": 1080,
      "protocol": "shadowsocks",
      "settings": { "clients": [], "network": "tcp,udp" }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "DIRECT" },
    { "protocol": "blackhole", "tag": "BLOCK" }
  ]
}
```

## نمونه اینباندها

این نمونه‌ها را داخل آرایه‌ی `inbounds` قرار دهید.

### VLESS + TCP + REALITY

بدون نیاز به دامنه و گواهی. اول کلیدها را بسازید:

```bash
docker exec pasban-pasban-1 xray x25519
```

مقدار `PrivateKey` (در نسخه‌های قدیمی‌تر Xray: `Private key`) را در کانفیگ بگذارید. پاسبان کلید عمومی را خودش محاسبه می‌کند و در لینک کاربر قرار می‌دهد.

::: tip پورت 443 اشغال است؟
اگر وب‌سرور دیگری (Nginx، Caddy و ...) روی 443 دارید، REALITY را روی پورت دیگری مثل `8443` بگذارید و آن را در فایروال باز کنید:
```bash
ufw allow 8443/tcp
```
:::

```json
{
  "tag": "VLESS TCP REALITY",
  "listen": "0.0.0.0",
  "port": 443,
  "protocol": "vless",
  "settings": { "clients": [], "decryption": "none" },
  "streamSettings": {
    "network": "tcp",
    "security": "reality",
    "realitySettings": {
      "show": false,
      "dest": "www.google.com:443",
      "xver": 0,
      "serverNames": ["www.google.com"],
      "privateKey": "YOUR_PRIVATE_KEY",
      "shortIds": ["", "a1b2c3d4"]
    }
  },
  "sniffing": { "enabled": true, "destOverride": ["http", "tls", "quic"] }
}
```

::: tip
برای استفاده از flow `xtls-rprx-vision`، هنگام ساخت کاربر در داشبورد، flow را در تنظیمات VLESS انتخاب کنید.
:::

### VMess + WebSocket + TLS

به دامنه و گواهی نیاز دارد ([SSL](./ssl)):

```json
{
  "tag": "VMESS WS TLS",
  "listen": "0.0.0.0",
  "port": 2083,
  "protocol": "vmess",
  "settings": { "clients": [] },
  "streamSettings": {
    "network": "ws",
    "wsSettings": { "path": "/vmess" },
    "security": "tls",
    "tlsSettings": {
      "serverName": "sub.example.com",
      "certificates": [
        {
          "certificateFile": "/var/lib/pasban/certs/fullchain.pem",
          "keyFile": "/var/lib/pasban/certs/key.pem"
        }
      ]
    }
  }
}
```

### Trojan + gRPC + TLS

```json
{
  "tag": "TROJAN GRPC TLS",
  "listen": "0.0.0.0",
  "port": 2053,
  "protocol": "trojan",
  "settings": { "clients": [] },
  "streamSettings": {
    "network": "grpc",
    "grpcSettings": { "serviceName": "trojan-grpc" },
    "security": "tls",
    "tlsSettings": {
      "certificates": [
        {
          "certificateFile": "/var/lib/pasban/certs/fullchain.pem",
          "keyFile": "/var/lib/pasban/certs/key.pem"
        }
      ]
    }
  }
}
```

### VLESS + WebSocket بدون TLS (پشت CDN)

```json
{
  "tag": "VLESS WS",
  "listen": "0.0.0.0",
  "port": 8080,
  "protocol": "vless",
  "settings": { "clients": [], "decryption": "none" },
  "streamSettings": { "network": "ws", "wsSettings": { "path": "/vless" } }
}
```

برای استفاده پشت CDN، در [تنظیمات هاست](./hosts) آدرس دامنه‌ی CDN و پورت 443 و security را `tls` بگذارید.

## مسدود کردن سایت‌ها

با قوانین `routing` می‌توانید ترافیک خاصی را مسدود کنید. مثلاً مسدود کردن تورنت و سایت‌های داخلی:

```json
"routing": {
  "rules": [
    { "type": "field", "ip": ["geoip:private"], "outboundTag": "BLOCK" },
    { "type": "field", "protocol": ["bittorrent"], "outboundTag": "BLOCK" },
    { "type": "field", "domain": ["geosite:category-ir"], "outboundTag": "BLOCK" },
    { "type": "field", "ip": ["geoip:ir"], "outboundTag": "BLOCK" }
  ]
}
```

برای مسدود کردن تورنت، `sniffing` باید در اینباند فعال باشد.

::: info
`geosite:category-ir` در فایل `geosite.dat` رسمی Xray وجود دارد. اگر خطا گرفتید، فایل geosite مناسب را در `/var/lib/pasban/assets` قرار دهید و `XRAY_ASSETS_PATH` را به آن مسیر تغییر دهید.
:::

## Fallback

اگر چند سرویس را روی یک پورت با Fallback اجرا می‌کنید، تگ اینباند اصلی را در `.env` بنویسید:

```ini
XRAY_FALLBACKS_INBOUND_TAG = "VLESS TCP TLS"
```
