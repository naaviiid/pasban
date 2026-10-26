# نودها (چند سرور)

با نودها می‌توانید Xray را روی چند سرور اجرا کنید و همه را از یک پنل مدیریت کنید. هر کاربر به‌صورت خودکار روی همه‌ی نودها فعال می‌شود و مصرفش از همه‌ی نودها جمع زده می‌شود.

پاسبان با **[Marzban-node](https://github.com/Gozargah/Marzban-node)** سازگار است.

## نحوه‌ی کار

- پنل اصلی کانفیگ Xray و لیست کاربران را برای نود می‌فرستد.
- نود Xray را با همان اینباندها اجرا می‌کند.
- ارتباط پنل و نود با یک گواهی امن (mTLS) رمزنگاری می‌شود.
- پورت‌های پیش‌فرض: **62050** (سرویس) و **62051** (API هسته‌ی Xray).

## ۱. دریافت گواهی از پنل

در داشبورد، منوی بالا ← **Node Settings** ← **Add New Pasban Node**. گواهی نمایش داده شده را کپی کنید (یا دانلود کنید).

## ۲. نصب نود روی سرور جدید

روی سرور نود (با Docker):

```bash
curl -fsSL https://get.docker.com | sh
git clone https://github.com/Gozargah/Marzban-node /opt/pasban-node
cd /opt/pasban-node
mkdir -p /var/lib/marzban-node
```

گواهی کپی‌شده را در این فایل ذخیره کنید:

```bash
nano /var/lib/marzban-node/ssl_client_cert.pem
```

فایل `docker-compose.yml` را این‌طور تنظیم کنید:

```yaml
services:
  marzban-node:
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host
    environment:
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"
      SERVICE_PROTOCOL: "rest"
    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
```

اجرا:

```bash
docker compose up -d
```

::: warning فایروال
پورت‌های 62050 و 62051 نود را فقط برای IP سرور پنل باز کنید:

```bash
ufw allow from PANEL_IP to any port 62050,62051 proto tcp
```

پورت‌های اینباندها (مثلاً 443) را هم برای همه باز کنید.
:::

## ۳. اضافه کردن نود در پنل

در همان پنجره‌ی **Add New Pasban Node**:

| فیلد | مقدار |
| --- | --- |
| Name | یک نام دلخواه، مثلاً `Pasban-S2` |
| Address | IP یا دامنه‌ی سرور نود |
| Port | `62050` |
| API Port | `62051` |
| Usage coefficient | ضریب مصرف (مثلاً `1.5` یعنی هر ۱ گیگ مصرف، ۱.۵ گیگ حساب شود) |
| Add this node as a new host for every inbound | برای هر اینباند یک هاست با آدرس نود ساخته شود |

بعد از ذخیره، وضعیت نود باید **connected** شود.

## مشکلات رایج

- **وضعیت error یا connecting می‌ماند:** فایروال، صحت گواهی و یکسان بودن نسخه‌ی Xray را بررسی کنید. لاگ نود: `docker compose logs -f`
- **کاربر روی نود وصل نمی‌شود:** پورت اینباند روی سرور نود باز باشد و هاست با آدرس نود ساخته شده باشد.
- **قطع و وصل نود:** در لیست نودها دکمه‌ی **Reconnect** را بزنید.
