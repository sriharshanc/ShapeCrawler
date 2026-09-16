<?php
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/functions.php';

$pageTitle = 'Clinic & Patient Management';
$pageDescription = 'Beckwied by Digihlth: a clinic and patient management platform for appointments, records, and communication.';
$showCookieBanner = true;

$hasAppStore = !empty(APP_STORE_URL);
$hasPlayStore = !empty(PLAY_STORE_URL);

require __DIR__ . '/includes/header.php';
?>

<section class="hero">
  <div class="wrap">
    <div class="hero-copy">
      <h1>Clinic and patient management, without the paperwork.</h1>
      <p>
        Beckwied helps clinics and their patients stay connected — appointments,
        records, and communication in one secure place. Built by Digihlth.
      </p>
      <div class="hero-actions">
        <a href="<?= $hasAppStore ? h(APP_STORE_URL) : '#' ?>"
           class="btn btn-primary <?= $hasAppStore ? '' : 'disabled' ?>"
           <?= $hasAppStore ? '' : 'aria-disabled="true" title="Coming soon"' ?>>
          Download on the App Store
        </a>
        <a href="<?= $hasPlayStore ? h(PLAY_STORE_URL) : '#' ?>"
           class="btn btn-outline <?= $hasPlayStore ? '' : 'disabled' ?>"
           <?= $hasPlayStore ? '' : 'aria-disabled="true" title="Coming soon"' ?>>
          Get it on Google Play
        </a>
      </div>
      <?php if (!$hasAppStore && !$hasPlayStore): ?>
        <p style="margin-top:14px;font-size:0.85rem;color:#eafaf8;">
          App store listings coming soon — check back shortly.
        </p>
      <?php endif; ?>
    </div>
  </div>
</section>

<section id="features">
  <div class="wrap">
    <h2>What Beckwied does</h2>
    <p class="section-intro">
      A focused set of tools for clinics and the patients they care for —
      nothing more, nothing less.
    </p>
    <div class="features-grid">
      <div class="feature-card">
        <div class="icon">📅</div>
        <h3>Appointment scheduling</h3>
        <p>Patients book, reschedule, and get reminders. Clinics see a clear daily schedule.</p>
      </div>
      <div class="feature-card">
        <div class="icon">🗂️</div>
        <h3>Patient records</h3>
        <p>Secure, structured records that keep clinic staff and patients on the same page.</p>
      </div>
      <div class="feature-card">
        <div class="icon">💬</div>
        <h3>Direct communication</h3>
        <p>Message your clinic directly for questions, follow-ups, and updates.</p>
      </div>
      <div class="feature-card">
        <div class="icon">🔔</div>
        <h3>Reminders & notifications</h3>
        <p>Never miss an appointment or a follow-up step in your care plan.</p>
      </div>
    </div>
  </div>
</section>

<section id="about">
  <div class="wrap">
    <div class="about-box">
      <h2>About Digihlth</h2>
      <p>
        Digihlth builds Beckwied, a clinic and patient management platform.
        Our goal is simple: make it easier for clinics to run smoothly and
        for patients to stay informed about their own care.
      </p>
    </div>
  </div>
</section>

<section id="contact" class="contact-section">
  <div class="wrap">
    <h2>Get in touch</h2>
    <p class="section-intro">
      Questions about Beckwied, your clinic, or a partnership? Send us a message.
    </p>
    <div class="contact-grid">
      <div class="contact-info">
        <p><strong>Email</strong><br>
          <a href="mailto:<?= h(CONTACT_EMAIL) ?>"><?= h(CONTACT_EMAIL) ?></a></p>
        <p><strong>Address</strong><br>
          <?= h(OPERATOR_NAME) ?><br>
          <?= h(OPERATOR_ADDRESS_LINE1) ?><br>
          <?= h(OPERATOR_ADDRESS_LINE2) ?></p>
      </div>
      <div class="contact-form-wrap">
        <div id="contact-form-target"></div>
        <?php
        // The form itself lives in contact.php so it can be included both
        // here (fresh form) and reused after a submission attempt.
        require __DIR__ . '/includes/contact_form.php';
        ?>
      </div>
    </div>
  </div>
</section>

<?php require __DIR__ . '/includes/footer.php'; ?>
