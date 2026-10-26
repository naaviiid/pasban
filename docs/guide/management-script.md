# اسکریپت مدیریت

با نصب سریع، دستور `pasban` روی سرور نصب می‌شود (`/usr/local/bin/pasban`).

| دستور | کار |
| --- | --- |
| `pasban install` | نصب پاسبان با Docker |
| `pasban up` | روشن کردن سرویس |
| `pasban down` | خاموش کردن سرویس |
| `pasban restart` | ری‌استارت (بعد از تغییر `.env` لازم است) |
| `pasban status` | وضعیت کانتینر |
| `pasban logs` | لاگ زنده (با `Ctrl+C` خارج شوید) |
| `pasban logs -n` | ۲۰۰ خط آخر لاگ، بدون دنبال کردن |
| `pasban edit` | باز کردن `/opt/pasban/.env` با `nano` |
| `pasban cli ...` | اجرای CLI داخل کانتینر |
| `pasban update` | دریافت آخرین نسخه و اجرای دوباره |
| `pasban uninstall` | حذف پاسبان |
| `pasban help` | راهنما |

## متغیرهای اسکریپت

این متغیرها را می‌توانید قبل از اجرای `install` یا `update` تعیین کنید:

| متغیر | پیش‌فرض | توضیح |
| --- | --- | --- |
| `PASBAN_REPO` | `https://github.com/naaviiid/pasban.git` | آدرس مخزن سورس |
| `PASBAN_BRANCH` | `master` | شاخه‌ی سورس |
| `PASBAN_IMAGE` | (خالی) | اگر تعیین شود، به‌جای ساخت، این ایمیج دانلود می‌شود |

مثال نصب از شاخه‌ی `dev`:

```bash
sudo PASBAN_BRANCH=dev pasban update
```

## ویرایش تنظیمات

```bash
pasban edit
# ذخیره: Ctrl+S   خروج: Ctrl+X
pasban restart
```
