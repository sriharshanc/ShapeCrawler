# Beckwied website (PHP + MySQL, Strato-ready)

Marketing site for the Beckwied clinic/patient-management app, operated by
Digihlth. Plain PHP + PDO, no Composer, no build step — built to be
uploaded straight to Strato shared hosting.

## What's included

| Path | Purpose |
|---|---|
| `index.php` | Homepage: hero, features, about, contact form |
| `contact.php` | Handles the contact form POST, stores it in MySQL, emails a notification |
| `privacy-policy.php` | Privacy Policy — will be reachable at `/privacy-policy.php` |
| `terms-of-use.php` | Terms of Use — will be reachable at `/terms-of-use.php` |
| `includes/config.php` | Site + database configuration (edit before going live) |
| `includes/db.php` | Shared PDO connection helper |
| `includes/functions.php` | Escaping, CSRF, and page-view counter helpers |
| `includes/header.php`, `includes/footer.php`, `includes/contact_form.php` | Shared layout partials |
| `assets/css/style.css` | All styling (teal/blue healthcare palette) |
| `db/schema.sql` | MySQL schema — run once before first use |

`includes/` and `db/` each carry a `.htaccess` denying direct web access,
since those files are only ever loaded via PHP `require`, never requested
by a browser.

## Deploying to Strato

1. **Create the subdomain.** In your Strato customer panel, point
   `beckwied.digihlth.com` at the folder you'll upload this site to
   (e.g. its own subdomain document root).

2. **Create a MySQL database.** Strato panel → *Databases* → *MySQL
   database* → create one if you don't already have one. Note the host
   (usually `rdbms.strato.de`), database name, username, and password.

3. **Import the schema.** Open phpMyAdmin from the Strato panel for that
   database and run `db/schema.sql` (Import tab, or paste into the SQL
   tab). This creates the `contact_messages` and `pageviews` tables.

4. **Edit `includes/config.php`.** Replace the `DB_*` placeholders with
   the real values from step 2. Double-check `SITE_URL`,
   `APP_STORE_URL`, and `PLAY_STORE_URL` (the last two are currently
   empty — the homepage shows the download buttons as disabled until
   you fill them in).

5. **Upload via FTP/SFTP.** Upload the entire contents of this folder
   (keeping the folder structure) to the subdomain's document root.

6. **Test mail delivery.** `contact.php` uses PHP's built-in `mail()` to
   notify `CONTACT_EMAIL` of new submissions. Strato's shared hosting
   generally supports `mail()` out of the box, but if notifications don't
   arrive, check Strato's mail/SPF settings for the domain — submissions
   are still safely stored in the `contact_messages` table either way, so
   nothing is lost even if the notification email doesn't go through.

7. **Verify the legal pages.** Once live, the Privacy Policy and Terms of
   Use are at:
   - `https://beckwied.digihlth.com/privacy-policy.php`
   - `https://beckwied.digihlth.com/terms-of-use.php`

   Both pages currently carry the address, name, and contact email you
   provided (Digihlth, Mainparkstr 5, 63814 Mainaschaff, Germany,
   contact-us@beckwied.digihlth.com). **They are a solid starting
   template, not legal advice** — have a lawyer review them before
   launch, and add a separate "Impressum" page, which German law
   generally requires in addition to a privacy policy for a commercial
   website.

## Local testing

With PHP's built-in server (PHP 7.4+ with `pdo_mysql` enabled):

```bash
cd beckwied-site
php -S localhost:8000
```

Point `includes/config.php` at a local MySQL instance and import
`db/schema.sql` there first.

## Notes on what's deliberately NOT included

- No user accounts/login — the earlier scoping call was "marketing
  homepage only," so there's nothing here beyond the contact form and
  visit counter that actually needs MySQL.
- No third-party analytics (Google Analytics, Matomo, etc.) — page views
  are counted server-side in MySQL with no cookies, which is also why the
  cookie banner on the site only needs to mention the visit counter, not
  a full cookie-consent flow.
