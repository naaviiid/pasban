# پشتیبان‌گیری

همه‌ی داده‌های مهم پاسبان در دو مسیر هستند:

| مسیر | محتوا |
| --- | --- |
| `/var/lib/pasban` | دیتابیس، کانفیگ Xray، گواهی‌ها، تمپلیت‌ها |
| `/opt/pasban/.env` | تنظیمات |

## پشتیبان دستی

```bash
pasban down
tar -czf /root/pasban-backup-$(date +%F).tar.gz /var/lib/pasban /opt/pasban/.env /opt/pasban/docker-compose.yml
pasban up
```

::: tip
برای SQLite بهتر است سرویس هنگام پشتیبان‌گیری خاموش باشد تا فایل دیتابیس ناقص کپی نشود.
:::

برای MySQL/MariaDB بدون خاموش کردن سرویس:

```bash
docker exec pasban-mariadb-1 mariadb-dump -uroot -p"a-strong-password" pasban > /root/pasban-db-$(date +%F).sql
```

## پشتیبان خودکار روزانه

یک cron بسازید که هر شب ساعت ۳ پشتیبان بگیرد و فایل‌های قدیمی‌تر از ۷ روز را پاک کند:

```bash
crontab -e
```

```bash
0 3 * * * tar -czf /root/backups/pasban-$(date +\%F).tar.gz /var/lib/pasban /opt/pasban/.env && find /root/backups -name 'pasban-*.tar.gz' -mtime +7 -delete
```

(قبل از آن `mkdir -p /root/backups` را اجرا کنید.)

### ارسال به تلگرام

با یک ربات تلگرام می‌توانید فایل را برای خودتان بفرستید:

```bash
curl -F chat_id=YOUR_ID -F document=@/root/backups/pasban-$(date +%F).tar.gz \
  "https://api.telegram.org/botYOUR_BOT_TOKEN/sendDocument"
```

::: warning
فایل پشتیبان شامل رمزها و اطلاعات کاربران است. آن را فقط برای خودتان بفرستید.
:::

## بازگردانی

روی سرور جدید، اول پاسبان را [نصب کنید](./installation)، سپس:

```bash
pasban down
tar -xzf pasban-backup-2026-10-26.tar.gz -C /
pasban up
```
