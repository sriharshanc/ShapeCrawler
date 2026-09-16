<?php
/**
 * Renders the contact form, including any flash message left by
 * contact.php after a submission attempt. Included from index.php.
 */
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

$flash = $_SESSION['contact_flash'] ?? null;
unset($_SESSION['contact_flash']);

$token = csrf_token();
?>

<?php if ($flash): ?>
  <div class="alert alert-<?= h($flash['type']) ?>">
    <?= h($flash['message']) ?>
    <?php if (!empty($flash['errors'])): ?>
      <ul>
        <?php foreach ($flash['errors'] as $err): ?>
          <li><?= h($err) ?></li>
        <?php endforeach; ?>
      </ul>
    <?php endif; ?>
  </div>
<?php endif; ?>

<?php if (!$flash || $flash['type'] !== 'success'): ?>
<form class="contact-form" action="/contact.php" method="post" novalidate>
  <input type="hidden" name="csrf_token" value="<?= h($token) ?>">

  <!-- Honeypot: left empty by real visitors, often filled in by bots -->
  <div class="hp-field" aria-hidden="true">
    <label for="website">Leave this field empty</label>
    <input type="text" id="website" name="website" tabindex="-1" autocomplete="off">
  </div>

  <div class="form-row">
    <label for="name">Name</label>
    <input type="text" id="name" name="name" required maxlength="150"
           value="<?= h($flash['old']['name'] ?? '') ?>">
  </div>

  <div class="form-row">
    <label for="email">Email</label>
    <input type="email" id="email" name="email" required maxlength="190"
           value="<?= h($flash['old']['email'] ?? '') ?>">
  </div>

  <div class="form-row">
    <label for="message">Message</label>
    <textarea id="message" name="message" required maxlength="4000"><?= h($flash['old']['message'] ?? '') ?></textarea>
  </div>

  <button type="submit" class="submit-btn">Send message</button>
</form>
<?php endif; ?>
