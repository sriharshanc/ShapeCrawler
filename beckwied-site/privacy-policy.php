<?php
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/functions.php';

$pageTitle = 'Privacy Policy';
$pageDescription = 'How Beckwied and Digihlth collect, use, and protect information on this website.';
$showCookieBanner = true;

require __DIR__ . '/includes/header.php';
?>

<section class="legal-page">
  <div class="wrap">
    <h1>Privacy Policy</h1>
    <p class="legal-meta">Last updated: <?= date('F j, Y') ?></p>

    <div class="legal-notice">
      <strong>Before you publish this:</strong> this policy is a solid starting
      template, not legal advice. Because Digihlth is based in Germany, this
      site is likely subject to the GDPR and German telemedia/data-protection
      law (which also requires a separate "Impressum"/legal-notice page in
      addition to this policy). Have a lawyer review and finalize this text
      — and add a proper Impressum page — before the site goes live.
    </div>

    <p>
      This Privacy Policy explains how <?= h(OPERATOR_NAME) ?> ("we", "us", "our"),
      the operator of the <?= h(SITE_NAME) ?> website at
      <a href="<?= h(SITE_URL) ?>"><?= h(SITE_URL) ?></a>, collects, uses, and
      protects information when you visit this website. It covers this
      marketing website only — the <?= h(SITE_NAME) ?> mobile/clinic
      application has its own in-app privacy notice covering patient and
      clinic data handled inside the app.
    </p>

    <h2>1. Who we are</h2>
    <p>
      <?= h(OPERATOR_NAME) ?><br>
      <?= h(OPERATOR_ADDRESS_LINE1) ?><br>
      <?= h(OPERATOR_ADDRESS_LINE2) ?><br>
      Email: <a href="mailto:<?= h(CONTACT_EMAIL) ?>"><?= h(CONTACT_EMAIL) ?></a>
    </p>

    <h2>2. What information we collect</h2>
    <p>We collect only what is needed to run this website:</p>
    <ul>
      <li>
        <strong>Aggregate page views.</strong> Each time a page on this site
        loads, we increment a simple counter (page name, date, and a visit
        count) stored in our MySQL database. We do not use cookies, browser
        fingerprinting, or any third-party analytics service for this — we
        do not know who viewed a page, only how many times it was viewed.
      </li>
      <li>
        <strong>Contact form submissions.</strong> If you use the contact
        form, we store the name, email address, message, submission time,
        and the IP address the message was sent from in our MySQL database.
        We use this only to respond to your message. Submitting the form
        also triggers an email notification sent from our own server to our
        support inbox — we do not use a third-party email marketing or
        analytics service to process this.
      </li>
      <li>
        <strong>Local "cookie notice acknowledged" flag.</strong> If you
        dismiss the small notice about our visit counter, your browser
        remembers that using its own local storage, so we don't show it to
        you again. This value stays in your browser only; we never receive
        or read it.
      </li>
    </ul>
    <p>We do not sell your data, and we do not share it with advertisers.</p>

    <h2>3. Why we process this information</h2>
    <ul>
      <li>To understand, in aggregate, how many people visit each page, so we can improve the site.</li>
      <li>To respond to questions or requests you send us through the contact form.</li>
      <li>To keep the website secure and prevent abuse (e.g. spam submissions).</li>
    </ul>

    <h2>4. How long we keep it</h2>
    <p>
      Aggregate page-view counters are kept indefinitely as they contain no
      personal information. Contact form submissions are kept only as long
      as needed to handle your inquiry and for a reasonable period
      afterward for our records, after which they are deleted. You can ask
      us to delete a message you sent at any time — see Section 6.
    </p>

    <h2>5. Where your information is stored</h2>
    <p>
      Website data is stored in a MySQL database on our hosting provider's
      infrastructure. We take reasonable technical measures (such as
      restricting database access and using prepared statements against
      injection attacks) to keep this information secure. No method of
      storage or transmission is 100% secure, so we cannot guarantee
      absolute security.
    </p>

    <h2>6. Your rights</h2>
    <p>
      Depending on where you live, you may have rights to access, correct,
      delete, or object to our processing of your personal information (for
      example, under the GDPR if you are in the EU/EEA). To exercise any of
      these rights, contact us at
      <a href="mailto:<?= h(CONTACT_EMAIL) ?>"><?= h(CONTACT_EMAIL) ?></a>.
      We will respond within a reasonable time.
    </p>

    <h2>7. Children's privacy</h2>
    <p>
      This website is not directed at children, and we do not knowingly
      collect personal information from children through this website's
      contact form.
    </p>

    <h2>8. Changes to this policy</h2>
    <p>
      We may update this Privacy Policy from time to time. The "Last
      updated" date at the top of this page reflects the most recent
      changes. Material changes will be reflected on this page.
    </p>

    <h2>9. Contact us</h2>
    <p>
      Questions about this policy or your information? Email us at
      <a href="mailto:<?= h(CONTACT_EMAIL) ?>"><?= h(CONTACT_EMAIL) ?></a> or
      write to us at the address in Section 1.
    </p>
  </div>
</section>

<?php require __DIR__ . '/includes/footer.php'; ?>
