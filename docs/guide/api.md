# API

هر کاری که در داشبورد انجام می‌شود، با REST API هم قابل انجام است. آدرس پایه: `https://YOUR_DOMAIN:8000/api`

## مستندات تعاملی

در `.env` متغیر `DOCS=True` را فعال کنید و ری‌استارت کنید. سپس:

- Swagger: `https://YOUR_DOMAIN:8000/docs`
- ReDoc: `https://YOUR_DOMAIN:8000/redoc`

::: warning
روی سرورهای عمومی، بعد از استفاده `DOCS` را دوباره غیرفعال کنید.
:::

## احراز هویت

اول توکن بگیرید:

```bash
curl -X POST https://YOUR_DOMAIN:8000/api/admin/token \
  -d "username=admin&password=YOUR_PASSWORD"
```

پاسخ:

```json
{ "access_token": "eyJhbGciOi...", "token_type": "bearer" }
```

سپس توکن را در هدر همه‌ی درخواست‌ها بفرستید:

```bash
curl https://YOUR_DOMAIN:8000/api/users \
  -H "Authorization: Bearer eyJhbGciOi..."
```

## مثال: ساخت کاربر

```bash
curl -X POST https://YOUR_DOMAIN:8000/api/user \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "alice",
    "proxies": { "vless": {}, "vmess": {} },
    "inbounds": {},
    "data_limit": 53687091200,
    "expire": 1767225600,
    "data_limit_reset_strategy": "no_reset",
    "note": "30 days / 50 GB"
  }'
```

| فیلد | توضیح |
| --- | --- |
| `username` | ۳ تا ۳۲ کاراکتر: حروف انگلیسی، عدد، `-`، `_`، `@` و `.` |
| `proxies` | پروتکل‌های فعال. `{}` یعنی تنظیمات پیش‌فرض (UUID/رمز خودکار) |
| `inbounds` | اینباندهای هر پروتکل. `{}` یعنی همه‌ی اینباندها |
| `data_limit` | حجم به **بایت**. `0` یعنی نامحدود |
| `expire` | زمان انقضا به‌صورت Unix timestamp. `0` یعنی نامحدود |
| `data_limit_reset_strategy` | `no_reset`، `day`، `week`، `month`، `year` |
| `status` | `active` یا `on_hold` |
| `on_hold_expire_duration` | در حالت on_hold: مدت اعتبار (ثانیه) از اولین اتصال |

## مسیرهای اصلی

### ادمین

| متد | مسیر | کار |
| --- | --- | --- |
| `POST` | `/api/admin/token` | دریافت توکن |
| `GET` | `/api/admin` | اطلاعات ادمین فعلی |
| `GET` | `/api/admins` | لیست ادمین‌ها |
| `POST` | `/api/admin` | ساخت ادمین |
| `PUT` | `/api/admin/{username}` | ویرایش ادمین |
| `DELETE` | `/api/admin/{username}` | حذف ادمین |
| `POST` | `/api/admin/{username}/users/disable` | غیرفعال کردن همه‌ی کاربران ادمین |
| `POST` | `/api/admin/{username}/users/activate` | فعال کردن همه‌ی کاربران ادمین |

### کاربر

| متد | مسیر | کار |
| --- | --- | --- |
| `POST` | `/api/user` | ساخت کاربر |
| `GET` | `/api/user/{username}` | اطلاعات کاربر |
| `PUT` | `/api/user/{username}` | ویرایش کاربر |
| `DELETE` | `/api/user/{username}` | حذف کاربر |
| `POST` | `/api/user/{username}/reset` | ریست مصرف |
| `POST` | `/api/user/{username}/revoke_sub` | تغییر لینک سابسکریپشن |
| `POST` | `/api/user/{username}/active-next` | فعال کردن پلن بعدی |
| `GET` | `/api/user/{username}/usage` | مصرف کاربر به تفکیک نود |
| `PUT` | `/api/user/{username}/set-owner` | تغییر مالک |
| `GET` | `/api/users` | لیست کاربران (با `offset`، `limit`، `search`، `status`) |
| `POST` | `/api/users/reset` | ریست مصرف همه |
| `GET` | `/api/users/usage` | مصرف کل کاربران |
| `GET` | `/api/users/expired` | لیست کاربران منقضی |
| `DELETE` | `/api/users/expired` | حذف کاربران منقضی |

### قالب کاربر

| متد | مسیر | کار |
| --- | --- | --- |
| `GET` | `/api/user_template` | لیست قالب‌ها |
| `POST` | `/api/user_template` | ساخت قالب |
| `GET` / `PUT` / `DELETE` | `/api/user_template/{id}` | مشاهده / ویرایش / حذف |

### سیستم، هسته و نود

| متد | مسیر | کار |
| --- | --- | --- |
| `GET` | `/api/system` | آمار سیستم |
| `GET` | `/api/inbounds` | لیست اینباندها |
| `GET` / `PUT` | `/api/hosts` | مشاهده / ویرایش هاست‌ها |
| `GET` | `/api/core` | وضعیت هسته |
| `POST` | `/api/core/restart` | ری‌استارت هسته |
| `GET` / `PUT` | `/api/core/config` | مشاهده / ویرایش کانفیگ Xray |
| `GET` | `/api/node/settings` | گواهی نود |
| `GET` | `/api/nodes` | لیست نودها |
| `POST` | `/api/node` | افزودن نود |
| `GET` / `PUT` / `DELETE` | `/api/node/{id}` | مشاهده / ویرایش / حذف نود |
| `POST` | `/api/node/{id}/reconnect` | اتصال دوباره |
| `GET` | `/api/nodes/usage` | مصرف نودها |

لیست کامل و دقیق پارامترها را در `/docs` ببینید.
