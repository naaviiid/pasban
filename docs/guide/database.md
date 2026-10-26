# MySQL و MariaDB

پاسبان به‌صورت پیش‌فرض از SQLite استفاده می‌کند که برای اکثر سرورها کافی است. برای تعداد کاربر خیلی زیاد یا دسترسی هم‌زمان سنگین، MySQL یا MariaDB پیشنهاد می‌شود.

::: danger قبل از شروع
این راهنما برای **نصب جدید** است. انتقال داده از SQLite به MySQL خودکار انجام نمی‌شود. قبل از هر تغییری [پشتیبان بگیرید](./backup).
:::

## MariaDB با Docker

فایل `/opt/pasban/docker-compose.yml` را ویرایش کنید و سرویس دیتابیس را اضافه کنید:

```yaml
services:
  pasban:
    build: /opt/pasban/src
    image: pasban:latest
    restart: always
    env_file: .env
    network_mode: host
    volumes:
      - /var/lib/pasban:/var/lib/pasban
    depends_on:
      - mariadb

  mariadb:
    image: mariadb:11
    restart: always
    env_file: .env
    network_mode: host
    command:
      - --bind-address=127.0.0.1
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
    volumes:
      - /var/lib/pasban/mysql:/var/lib/mysql
```

در `.env`:

```ini
MYSQL_ROOT_PASSWORD = "a-strong-password"
MYSQL_DATABASE = "pasban"

SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root:a-strong-password@127.0.0.1:3306/pasban"
```

اجرا:

```bash
pasban down
pasban up
pasban logs
```

جدول‌ها هنگام شروع پاسبان خودکار ساخته می‌شوند. سپس ادمین بسازید:

```bash
pasban cli admin create --sudo
```

برای MySQL به‌جای `mariadb:11` از `mysql:8` استفاده کنید.

## دیتابیس خارجی

اگر سرور دیتابیس جداگانه دارید، فقط آدرس را تغییر دهید:

```ini
SQLALCHEMY_DATABASE_URL = "mysql+pymysql://pasban:PASSWORD@db.example.com:3306/pasban"
```
