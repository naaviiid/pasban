# CLI

پاسبان یک ابزار خط فرمان برای مدیریت ادمین‌ها، کاربران و سابسکریپشن دارد.

| نوع نصب | نحوه‌ی اجرا |
| --- | --- |
| Docker (اسکریپت) | `pasban cli <command>` |
| دستی | `pasban-cli <command>` |

برای راهنمای هر دستور، `--help` را اضافه کنید:

```bash
pasban cli admin create --help
```

## ادمین‌ها

```bash
# ساخت ادمین sudo
pasban cli admin create --sudo

# ساخت ادمین معمولی با آیدی تلگرام
pasban cli admin create -u reseller1 -tg 123456789

# لیست ادمین‌ها
pasban cli admin list

# ویرایش (رمز، sudo، تلگرام، دیسکورد) — به‌صورت تعاملی
pasban cli admin update -u reseller1

# حذف
pasban cli admin delete -u reseller1 -y

# ساخت ادمین sudo از SUDO_USERNAME و SUDO_PASSWORD در .env
pasban cli admin import-from-env -y
```

| گزینه‌ی `admin create` | توضیح |
| --- | --- |
| `-u, --username` | نام کاربری (اجباری) |
| `--sudo / --no-sudo` | ادمین sudo باشد یا نه (پیش‌فرض: نه) |
| `-tg, --telegram-id` | آیدی تلگرام ادمین برای دریافت اعلان‌ها |
| `-dc, --discord-webhook` | webhook دیسکورد ادمین |

::: tip ساخت بدون سؤال
رمز را می‌توانید با متغیر `PASBAN_ADMIN_PASSWORD` بدهید (مثلاً در اسکریپت‌ها):

```bash
docker exec -e PASBAN_ADMIN_PASSWORD='S3cret!' pasban-pasban-1 pasban-cli admin create -u admin --sudo
```
:::

## کاربران

```bash
# لیست کاربران
pasban cli user list
pasban cli user list --status expired
pasban cli user list -s "note text" --owner reseller1 -l 50

# انتقال مالکیت کاربر به ادمین دیگر
pasban cli user set-owner -u alice --owner reseller1 -y
```

| گزینه‌ی `user list` | توضیح |
| --- | --- |
| `-o, --offset` / `-l, --limit` | صفحه‌بندی |
| `-u, --username` | جستجو با نام کاربری |
| `-s, --search` | جستجو در نام کاربری و یادداشت |
| `--status` | `active`، `disabled`، `limited`، `expired`، `on_hold` |
| `--admin, --owner` | کاربران یک ادمین |

## سابسکریپشن

```bash
# لینک سابسکریپشن کاربر (نیاز به XRAY_SUBSCRIPTION_URL_PREFIX)
pasban cli subscription get-link -u alice

# خروجی کانفیگ
pasban cli subscription get-config -u alice -f v2ray --base64
pasban cli subscription get-config -u alice -f clash -o /var/lib/pasban/alice.yml
```

## تکمیل خودکار

```bash
pasban-cli completion install --shell bash
```
