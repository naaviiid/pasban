# Webhook

پاسبان می‌تواند رویدادهای کاربران را به یک یا چند آدرس HTTP بفرستد. برای اتصال به ربات فروش، سیستم حسابداری و ... مناسب است.

## تنظیم

```ini
WEBHOOK_ADDRESS = "https://bot.example.com/pasban-hook,https://backup.example.com/hook"
WEBHOOK_SECRET = "something-very-very-secret"
```

- رویدادها هر `JOB_SEND_NOTIFICATIONS_INTERVAL` ثانیه (پیش‌فرض ۳۰) به‌صورت **دسته‌ای** با `POST` ارسال می‌شوند.
- `WEBHOOK_SECRET` در هدر `x-webhook-secret` ارسال می‌شود. در سرور خود آن را بررسی کنید.
- اگر هیچ آدرسی پاسخ موفق (`2xx`) ندهد، ارسال تا `NUMBER_OF_RECURRENT_NOTIFICATIONS` بار با فاصله‌ی `RECURRENT_NOTIFICATIONS_TIMEOUT` ثانیه تکرار می‌شود.

## انواع رویداد

| `action` | زمان |
| --- | --- |
| `user_created` | ساخت کاربر |
| `user_updated` | ویرایش کاربر |
| `user_deleted` | حذف کاربر |
| `user_limited` | تمام شدن حجم |
| `user_expired` | تمام شدن زمان |
| `user_enabled` | فعال شدن کاربر |
| `user_disabled` | غیرفعال شدن کاربر |
| `data_usage_reset` | ریست مصرف |
| `data_reset_by_next` | فعال شدن پلن بعدی |
| `subscription_revoked` | تغییر لینک سابسکریپشن |
| `reached_usage_percent` | رسیدن به درصد مصرف (`NOTIFY_REACHED_USAGE_PERCENT`) |
| `reached_days_left` | رسیدن به روزهای باقی‌مانده (`NOTIFY_DAYS_LEFT`) |

## ساختار داده

بدنه‌ی درخواست یک **آرایه** از رویدادهاست:

```json
[
  {
    "username": "alice",
    "action": "user_created",
    "enqueued_at": 1761480000.0,
    "send_at": 1761480000.0,
    "tries": 0,
    "by": { "username": "admin", "is_sudo": true },
    "user": {
      "username": "alice",
      "status": "active",
      "used_traffic": 0,
      "data_limit": 53687091200,
      "expire": 1764072000,
      "subscription_url": "https://sub.example.com/sub/..."
    }
  }
]
```

بسته به نوع رویداد، فیلدهای `by` (ادمین انجام‌دهنده)، `user`، `used_percent` یا `days_left` وجود دارند.

## نمونه‌ی گیرنده (Python)

```python
from fastapi import FastAPI, Header, HTTPException, Request

app = FastAPI()
SECRET = "something-very-very-secret"

@app.post("/pasban-hook")
async def hook(request: Request, x_webhook_secret: str = Header(None)):
    if x_webhook_secret != SECRET:
        raise HTTPException(status_code=403)
    for event in await request.json():
        print(event["action"], event["username"])
    return {"ok": True}
```
