<?php
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/functions.php';

$pageTitle = 'Terms of Use';
$pageDescription = 'Terms governing your use of the Beckwied website.';
$showCookieBanner = true;

require __DIR__ . '/includes/header.php';
?>

<section class="legal-page">
  <div class="wrap">
    <h1>Terms of Use</h1>
    <p class="legal-meta">Last updated: <?= date('F j, Y') ?></p>

    <div class="legal-notice">
      <strong>Before you publish this:</strong> this is a solid starting
      template, not legal advice — especially given the healthcare context.
      Have a lawyer review and finalize this text, and add a proper
      Impressum/legal-notice page as required for German-based websites,
      before the site goes live.
    </div>

    <p>
      These Terms of Use ("Terms") govern your access to and use of the
      website at <a href="<?= h(SITE_URL) ?>"><?= h(SITE_URL) ?></a> (the
      "Site"), operated by <?= h(OPERATOR_NAME) ?> ("we", "us", "our"). By
      using the Site, you agree to these Terms. If you do not agree, please
      do not use the Site.
    </p>
    <p>
      These Terms cover the <?= h(SITE_NAME) ?> marketing website only. Use
      of the <?= h(SITE_NAME) ?> mobile/clinic application, and any care
      provided by a clinic using it, is governed by separate terms
      presented within the app and by your agreement with your clinic.
    </p>

    <h2>1. Not medical advice, not an emergency service</h2>
    <p>
      This Site and the <?= h(SITE_NAME) ?> application are tools to help
      clinics and patients communicate and manage appointments and records.
      They are not a substitute for professional medical judgment, diagnosis,
      or treatment. Always seek the advice of your physician or other
      qualified health provider with questions about a medical condition.
      <strong>If you are experiencing a medical emergency, call your local
      emergency number immediately — do not rely on this Site or the app.</strong>
    </p>

    <h2>2. Eligibility</h2>
    <p>
      You must be able to form a legally binding agreement to use this
      Site. If you are using the Site on behalf of a minor or a patient
      under your care, you confirm you are authorized to do so.
    </p>

    <h2>3. Acceptable use</h2>
    <p>When using the Site, you agree not to:</p>
    <ul>
      <li>submit false, misleading, or fraudulent information through the contact form;</li>
      <li>attempt to gain unauthorized access to the Site, our servers, or our database;</li>
      <li>use automated tools to scrape, spam, or overload the Site;</li>
      <li>use the Site for any unlawful purpose or in violation of these Terms.</li>
    </ul>

    <h2>4. Intellectual property</h2>
    <p>
      The Site, including its text, design, graphics, and the
      <?= h(SITE_NAME) ?> name and logo, is owned by <?= h(OPERATOR_NAME) ?>
      or its licensors and is protected by applicable intellectual property
      laws. You may not copy, reproduce, or create derivative works from the
      Site without our prior written permission, except as necessary to
      view the Site in a standard web browser.
    </p>

    <h2>5. Third-party links</h2>
    <p>
      The Site may link to third-party services, such as app store
      listings. We are not responsible for the content, policies, or
      practices of third-party sites or services.
    </p>

    <h2>6. Disclaimer of warranties</h2>
    <p>
      The Site is provided "as is" and "as available," without warranties
      of any kind, express or implied, including but not limited to
      warranties of merchantability, fitness for a particular purpose, or
      non-infringement. We do not warrant that the Site will be
      uninterrupted, error-free, or secure.
    </p>

    <h2>7. Limitation of liability</h2>
    <p>
      To the fullest extent permitted by applicable law,
      <?= h(OPERATOR_NAME) ?> shall not be liable for any indirect,
      incidental, special, consequential, or punitive damages arising out of
      or related to your use of the Site. Nothing in these Terms limits any
      liability that cannot be limited or excluded under applicable law
      (including liability for death, personal injury, gross negligence, or
      willful misconduct, where applicable).
    </p>

    <h2>8. Changes to the Site and these Terms</h2>
    <p>
      We may update the Site or these Terms at any time. The "Last updated"
      date above reflects the most recent changes. Continued use of the
      Site after changes take effect constitutes acceptance of the revised
      Terms.
    </p>

    <h2>9. Governing law</h2>
    <p>
      These Terms are governed by the laws applicable at
      <?= h(OPERATOR_NAME) ?>'s place of business in Germany, without
      prejudice to any mandatory consumer-protection or data-protection
      rights you may have under the law of your own country of residence.
    </p>

    <h2>10. Contact us</h2>
    <p>
      Questions about these Terms? Email us at
      <a href="mailto:<?= h(CONTACT_EMAIL) ?>"><?= h(CONTACT_EMAIL) ?></a> or
      write to:<br>
      <?= h(OPERATOR_NAME) ?><br>
      <?= h(OPERATOR_ADDRESS_LINE1) ?><br>
      <?= h(OPERATOR_ADDRESS_LINE2) ?>
    </p>
  </div>
</section>

<?php require __DIR__ . '/includes/footer.php'; ?>
