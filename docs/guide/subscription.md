# سابسکریپشن

هر کاربر یک لینک سابسکریپشن دارد. کاربر آن را یک بار در نرم‌افزارش وارد می‌کند و با هر تغییر (هاست جدید، تمدید، ...) کانفیگ‌ها خودکار به‌روز می‌شوند.

## آدرس لینک

```
{XRAY_SUBSCRIPTION_URL_PREFIX}/{XRAY_SUBSCRIPTION_PATH}/{token}
```

مثال: `https://sub.example.com:8000/sub/eyJhbGciOi...`

اگر `XRAY_SUBSCRIPTION_URL_PREFIX` خالی باشد، لینک بدون دامنه (`/sub/...`) ساخته می‌شود. پس حتماً آن را در [تنظیمات](./configuration#xray) تعیین کنید. علامت `*` در این آدرس با یک رشته‌ی تصادفی جایگزین می‌شود (مثلاً `https://*.sub.example.com`).

## تشخیص خودکار نرم‌افزار

پاسبان از روی User-Agent نرم‌افزار، خروجی مناسب را می‌سازد:

| نرم‌افزار | خروجی |
| --- | --- |
| Clash Verge، Clash Meta، FlClash، Mihomo | Clash Meta (YAML) |
| Clash، Stash | Clash (YAML) |
| sing-box (SFA/SFI/SFM/SFT)، Karing، Hiddify Next | sing-box (JSON) |
| Outline و کلاینت‌های Shadowsocks | Outline (JSON) |
| v2rayN، v2rayNG، Streisand، Happ | لینک‌های v2ray یا کانفیگ JSON (بسته به `USE_CUSTOM_JSON_*`) |
| بقیه | لینک‌های v2ray (base64) |
| مرورگر | صفحه‌ی اطلاعات کاربر (HTML) |

## آدرس‌های اضافه

| آدرس | خروجی |
| --- | --- |
| `/sub/{token}/info` | اطلاعات کاربر (JSON) |
| `/sub/{token}/usage` | مصرف کاربر (JSON) |
| `/sub/{token}/v2ray` | لینک‌های v2ray |
| `/sub/{token}/v2ray-json` | کانفیگ JSON |
| `/sub/{token}/clash` | Clash |
| `/sub/{token}/clash-meta` | Clash Meta |
| `/sub/{token}/sing-box` | sing-box |
| `/sub/{token}/outline` | Outline |

## هدرهای سابسکریپشن

این مقادیر در هدرهای پاسخ قرار می‌گیرند و نرم‌افزارهایی مثل v2rayN، Hiddify و Streisand آن‌ها را نمایش می‌دهند:

```ini
SUB_PROFILE_TITLE = "Pasban VPN"
SUB_SUPPORT_URL = "https://t.me/your_support"
SUB_UPDATE_INTERVAL = "12"
```

حجم مصرف شده، حجم کل و تاریخ انقضا هم خودکار در هدر `subscription-userinfo` ارسال می‌شوند.

## لغو لینک

اگر لینک کاربر لو رفته، در داشبورد کاربر را باز کنید و **Revoke subscription** را بزنید. لینک قبلی باطل می‌شود و لینک جدید ساخته می‌شود.

## تمپلیت سفارشی

می‌توانید صفحه‌ی سابسکریپشن، صفحه‌ی اصلی و کانفیگ‌های Clash، sing-box و v2ray را شخصی‌سازی کنید.

1. پوشه‌ی تمپلیت بسازید:
   ```bash
   mkdir -p /var/lib/pasban/templates/subscription
   ```
2. فایل خود را در آن قرار دهید، مثلاً `/var/lib/pasban/templates/subscription/index.html`
3. در `.env`:
   ```ini
   CUSTOM_TEMPLATES_DIRECTORY = "/var/lib/pasban/templates/"
   SUBSCRIPTION_PAGE_TEMPLATE = "subscription/index.html"
   ```
4. `pasban restart`

تمپلیت‌های پیش‌فرض در پوشه‌ی `app/templates` سورس قرار دارند و نقطه‌ی شروع خوبی هستند. تمپلیت‌ها با Jinja2 نوشته می‌شوند و به متغیر `user` دسترسی دارند.
