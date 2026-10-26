import { defineConfig } from "vitepress";

// Repository coordinates (set by the publish step)
const GITHUB_USER = "naaviiid";
const REPO = `https://github.com/${GITHUB_USER}/pasban`;

const faSidebar = [
  {
    text: "شروع",
    items: [
      { text: "معرفی", link: "/guide/introduction" },
      { text: "نصب", link: "/guide/installation" },
      { text: "اسکریپت مدیریت", link: "/guide/management-script" },
      { text: "آپدیت، حذف و رفع مشکل", link: "/guide/maintenance" },
    ],
  },
  {
    text: "پیکربندی",
    items: [
      { text: "متغیرهای محیطی (.env)", link: "/guide/configuration" },
      { text: "کانفیگ Xray و اینباندها", link: "/guide/xray-config" },
      { text: "تنظیمات هاست", link: "/guide/hosts" },
      { text: "سابسکریپشن", link: "/guide/subscription" },
      { text: "نودها (چند سرور)", link: "/guide/nodes" },
    ],
  },
  {
    text: "ابزارها",
    items: [
      { text: "ربات تلگرام", link: "/guide/telegram-bot" },
      { text: "CLI", link: "/guide/cli" },
      { text: "API", link: "/guide/api" },
      { text: "Webhook", link: "/guide/webhook" },
    ],
  },
  {
    text: "آموزش‌ها",
    items: [
      { text: "گواهی SSL و دامنه", link: "/guide/ssl" },
      { text: "MySQL و MariaDB", link: "/guide/database" },
      { text: "پشتیبان‌گیری", link: "/guide/backup" },
      { text: "تغییر نسخه Xray", link: "/guide/xray-version" },
    ],
  },
];

export default defineConfig({
  base: "/pasban/",
  title: "Pasban",
  cleanUrls: true,
  lastUpdated: true,
  head: [
    ["link", { rel: "icon", href: "/pasban/logo.png" }],
    ["link", { rel: "preconnect", href: "https://fonts.googleapis.com" }],
    ["link", { rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "" }],
    ["link", { rel: "stylesheet", href: "https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;600;800&display=swap" }],
  ],
  locales: {
    root: {
      label: "فارسی",
      lang: "fa-IR",
      dir: "rtl",
      description: "پاسبان: پنل مدیریت کاربران پروکسی بر پایه Xray",
      themeConfig: {
        nav: [
          { text: "راهنما", link: "/guide/introduction" },
          { text: "نصب", link: "/guide/installation" },
        ],
        sidebar: { "/guide/": faSidebar },
        outline: { label: "در این صفحه", level: [2, 3] },
        docFooter: { prev: "صفحه قبل", next: "صفحه بعد" },
        lastUpdated: { text: "آخرین به‌روزرسانی" },
        editLink: { pattern: `${REPO}/edit/master/docs/:path`, text: "ویرایش این صفحه در گیت‌هاب" },
        returnToTopLabel: "بازگشت به بالا",
        sidebarMenuLabel: "منو",
        darkModeSwitchLabel: "حالت تاریک",
        langMenuLabel: "زبان",
      },
    },
    en: {
      label: "English",
      lang: "en-US",
      dir: "ltr",
      link: "/en/",
      description: "Pasban: proxy user management panel powered by Xray",
      themeConfig: {
        nav: [{ text: "Guide", link: "/en/guide/installation" }],
        sidebar: {
          "/en/": [
            {
              text: "Guide",
              items: [
                { text: "Introduction", link: "/en/" },
                { text: "Installation", link: "/en/guide/installation" },
              ],
            },
          ],
        },
        editLink: { pattern: `${REPO}/edit/master/docs/:path`, text: "Edit this page on GitHub" },
      },
    },
  },
  themeConfig: {
    logo: "/logo.png",
    socialLinks: [{ icon: "github", link: REPO }],
    search: { provider: "local" },
    footer: {
      message: "منتشر شده تحت مجوز AGPL-3.0 · فورک شده از Marzban",
    },
  },
});
