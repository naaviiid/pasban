# متغیرهای محیطی (.env)

تنظیمات پاسبان در فایل `.env` قرار دارد. در نصب Docker مسیر آن `/opt/pasban/.env` است. بعد از هر تغییر، سرویس را ری‌استارت کنید:

```bash
pasban restart
```

::: tip
برای فعال کردن هر متغیر، `#` اول خط را بردارید. مقادیر متنی را داخل `"..."` بنویسید.
:::

## سرور و داشبورد

| متغیر | پیش‌فرض | توضیح |
| --- | --- | --- |
| `UVICORN_HOST` | `0.0.0.0` | آدرسی که پنل روی آن گوش می‌دهد (فقط وقتی SSL تنظیم شده باشد) |
| `UVICORN_PORT` | `8000` | پورت پنل |
| `UVICORN_UDS` | — | به‌جای پورت، روی Unix socket گوش بده (برای reverse proxy) |
| `UVICORN_SSL_CERTFILE` | — | مسیر فایل گواهی (fullchain) |
| `UVICORN_SSL_KEYFILE` | — | مسیر کلید خصوصی گواهی |
| `UVICORN_SSL_CA_TYPE` | `public` | نوع گواهی: `public` برای گواهی معتبر، `private` برای گواهی self-signed |
| `DASHBOARD_PATH` | `/dashboard/` | مسیر داشبورد. برای امنیت بیشتر یک مسیر تصادفی بگذارید |
| `ALLOWED_ORIGINS` | `*` | دامنه‌های مجاز CORS، جدا شده با کاما |
| `JWT_ACCESS_TOKEN_EXPIRE_MINUTES` | `1440` | مدت اعتبار ورود ادمین (دقیقه). `0` یعنی بدون انقضا |
| `DOCS` | `False` | فعال کردن مستندات API در `/docs` و `/redoc` |
| `DEBUG` | `False` | حالت توسعه |

## ادمین

| متغیر | توضیح |
| --- | --- |
| `SUDO_USERNAME` / `SUDO_PASSWORD` | ادمین sudo ثابت. توصیه نمی‌شود؛ به‌جای آن از `pasban cli admin create --sudo` استفاده کنید |

## Xray

| متغیر | پیش‌فرض | توضیح |
| --- | --- | --- |
| `XRAY_JSON` | `./xray_config.json` | مسیر کانفیگ Xray (در Docker: `/var/lib/pasban/xray_config.json`) |
| `XRAY_EXECUTABLE_PATH` | `/usr/local/bin/xray` | مسیر فایل اجرایی Xray |
| `XRAY_ASSETS_PATH` | `/usr/local/share/xray` | مسیر فایل‌های `geoip.dat` و `geosite.dat` |
| `XRAY_EXCLUDE_INBOUND_TAGS` | — | تگ اینباندهایی که پاسبان مدیریت نکند، جدا شده با فاصله |
| `XRAY_FALLBACKS_INBOUND_TAG` | — | تگ اینباندی که Fallback روی آن تنظیم شده |
| `XRAY_SUBSCRIPTION_URL_PREFIX` | — | آدرس پایه‌ی لینک سابسکریپشن، مثلاً `https://sub.example.com` |
| `XRAY_SUBSCRIPTION_PATH` | `sub` | مسیر سابسکریپشن در آدرس |

## سابسکریپشن

| متغیر | پیش‌فرض | توضیح |
| --- | --- | --- |
| `SUB_PROFILE_TITLE` | `Subscription` | عنوان پروفایل در نرم‌افزار کاربر |
| `SUB_SUPPORT_URL` | `https://t.me/` | لینک پشتیبانی که در نرم‌افزار کاربر نمایش داده می‌شود |
| `SUB_UPDATE_INTERVAL` | `12` | فاصله‌ی آپدیت خودکار سابسکریپشن (ساعت) |
| `EXTERNAL_CONFIG` | — | یک لینک کانفیگ ثابت که به سابسکریپشن v2ray همه‌ی کاربران اضافه می‌شود |
| `USE_CUSTOM_JSON_DEFAULT` | `False` | ارسال کانفیگ JSON کامل (با mux و fragment) برای همه‌ی نرم‌افزارهای سازگار |
| `USE_CUSTOM_JSON_FOR_V2RAYN` | `False` | فقط برای v2rayN |
| `USE_CUSTOM_JSON_FOR_V2RAYNG` | `False` | فقط برای v2rayNG |
| `USE_CUSTOM_JSON_FOR_STREISAND` | `False` | فقط برای Streisand |
| `USE_CUSTOM_JSON_FOR_HAPP` | `False` | فقط برای Happ |

## تمپلیت‌ها

| متغیر | پیش‌فرض |
| --- | --- |
| `CUSTOM_TEMPLATES_DIRECTORY` | — (مثلاً `/var/lib/pasban/templates/`) |
| `SUBSCRIPTION_PAGE_TEMPLATE` | `subscription/index.html` |
| `HOME_PAGE_TEMPLATE` | `home/index.html` |
| `CLASH_SUBSCRIPTION_TEMPLATE` | `clash/default.yml` |
| `CLASH_SETTINGS_TEMPLATE` | `clash/settings.yml` |
| `SINGBOX_SUBSCRIPTION_TEMPLATE` | `singbox/default.json` |
| `SINGBOX_SETTINGS_TEMPLATE` | `singbox/settings.json` |
| `V2RAY_SUBSCRIPTION_TEMPLATE` | `v2ray/default.json` |
| `V2RAY_SETTINGS_TEMPLATE` | `v2ray/settings.json` |
| `MUX_TEMPLATE` | `mux/default.json` |
| `USER_AGENT_TEMPLATE` | `user_agent/default.json` |
| `GRPC_USER_AGENT_TEMPLATE` | `user_agent/grpc.json` |

جزئیات در [سابسکریپشن](./subscription#تمپلیت-سفارشی).

## متن وضعیت کاربر

| متغیر | پیش‌فرض |
| --- | --- |
| `ACTIVE_STATUS_TEXT` | `Active` |
| `EXPIRED_STATUS_TEXT` | `Expired` |
| `LIMITED_STATUS_TEXT` | `Limited` |
| `DISABLED_STATUS_TEXT` | `Disabled` |
| `ONHOLD_STATUS_TEXT` | `On-Hold` |

این متن‌ها در متغیر `{STATUS_TEXT}` [هاست‌ها](./hosts#متغیرها) استفاده می‌شوند.

## حذف خودکار کاربران

| متغیر | پیش‌فرض | توضیح |
| --- | --- | --- |
| `USERS_AUTODELETE_DAYS` | `-1` | کاربران منقضی بعد از این تعداد روز حذف می‌شوند. عدد منفی یعنی غیرفعال |
| `USER_AUTODELETE_INCLUDE_LIMITED_ACCOUNTS` | `False` | کاربران تمام‌حجم هم حذف شوند |

## تلگرام و دیسکورد

| متغیر | توضیح |
| --- | --- |
| `TELEGRAM_API_TOKEN` | توکن ربات از [@BotFather](https://t.me/BotFather) |
| `TELEGRAM_ADMIN_ID` | آیدی عددی ادمین‌ها، جدا شده با کاما |
| `TELEGRAM_LOGGER_CHANNEL_ID` | آیدی کانال برای ارسال گزارش‌ها |
| `TELEGRAM_DEFAULT_VLESS_FLOW` | flow پیش‌فرض VLESS در ساخت کاربر از ربات، مثلاً `xtls-rprx-vision` |
| `TELEGRAM_PROXY_URL` | پروکسی برای اتصال ربات به تلگرام |
| `DISCORD_WEBHOOK_URL` | آدرس webhook دیسکورد برای گزارش‌ها |

جزئیات در [ربات تلگرام](./telegram-bot).

## اعلان‌ها و Webhook

| متغیر | پیش‌فرض | توضیح |
| --- | --- | --- |
| `WEBHOOK_ADDRESS` | — | یک یا چند آدرس، جدا شده با کاما |
| `WEBHOOK_SECRET` | — | در هدر `x-webhook-secret` ارسال می‌شود |
| `NOTIFY_REACHED_USAGE_PERCENT` | `80` | درصدهای مصرف برای اعلان، مثلاً `80,90` |
| `NOTIFY_DAYS_LEFT` | `3` | روزهای باقی‌مانده برای اعلان، مثلاً `3,7` |
| `RECURRENT_NOTIFICATIONS_TIMEOUT` | `180` | فاصله‌ی تلاش دوباره (ثانیه) |
| `NUMBER_OF_RECURRENT_NOTIFICATIONS` | `3` | تعداد تلاش دوباره |
| `NOTIFY_STATUS_CHANGE` | `True` | اعلان تغییر وضعیت کاربر |
| `NOTIFY_USER_CREATED` | `True` | اعلان ساخت کاربر |
| `NOTIFY_USER_UPDATED` | `True` | اعلان ویرایش کاربر |
| `NOTIFY_USER_DELETED` | `True` | اعلان حذف کاربر |
| `NOTIFY_USER_DATA_USED_RESET` | `True` | اعلان ریست مصرف |
| `NOTIFY_USER_SUB_REVOKED` | `True` | اعلان تغییر لینک سابسکریپشن |
| `NOTIFY_IF_DATA_USAGE_PERCENT_REACHED` | `True` | اعلان رسیدن به درصد مصرف |
| `NOTIFY_IF_DAYS_LEFT_REACHED` | `True` | اعلان نزدیک شدن به انقضا |
| `NOTIFY_LOGIN` | `True` | اعلان ورود ادمین |
| `LOGIN_NOTIFY_WHITE_LIST` | — | IPهایی که ورودشان اعلان نشود، جدا شده با کاما |

جزئیات در [Webhook](./webhook).

## دیتابیس

| متغیر | پیش‌فرض | توضیح |
| --- | --- | --- |
| `SQLALCHEMY_DATABASE_URL` | `sqlite:///db.sqlite3` | آدرس دیتابیس (در Docker: `sqlite:////var/lib/pasban/db.sqlite3`) |
| `SQLALCHEMY_POOL_SIZE` | `10` | اندازه‌ی pool اتصال |
| `SQLIALCHEMY_MAX_OVERFLOW` | `30` | حداکثر اتصال اضافه |

جزئیات در [MySQL و MariaDB](./database).

## زمان‌بندی کارها (ثانیه)

| متغیر | پیش‌فرض | توضیح |
| --- | --- | --- |
| `JOB_CORE_HEALTH_CHECK_INTERVAL` | `10` | بررسی سلامت هسته |
| `JOB_RECORD_NODE_USAGES_INTERVAL` | `30` | ثبت مصرف نودها |
| `JOB_RECORD_USER_USAGES_INTERVAL` | `10` | ثبت مصرف کاربران |
| `JOB_REVIEW_USERS_INTERVAL` | `10` | بررسی انقضا و محدودیت کاربران |
| `JOB_SEND_NOTIFICATIONS_INTERVAL` | `30` | ارسال اعلان‌های صف |
| `DISABLE_RECORDING_NODE_USAGE` | `False` | ثبت مصرف نودها غیرفعال شود |
