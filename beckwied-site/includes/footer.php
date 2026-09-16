<?php
$footerViews = record_pageview($currentPage ?? 'unknown');
?>
</main>
<footer class="site-footer">
  <div class="wrap">
    <div class="footer-grid">
      <div>
        <div class="brand"><?= h(SITE_NAME) ?></div>
        <p><?= h(SITE_TAGLINE) ?></p>
      </div>
      <div>
        <strong>Contact</strong>
        <p><a href="mailto:<?= h(CONTACT_EMAIL) ?>"><?= h(CONTACT_EMAIL) ?></a></p>
        <p><?= h(OPERATOR_NAME) ?><br>
           <?= h(OPERATOR_ADDRESS_LINE1) ?><br>
           <?= h(OPERATOR_ADDRESS_LINE2) ?></p>
      </div>
      <div>
        <strong>Legal</strong>
        <p><a href="/privacy-policy.php">Privacy Policy</a></p>
        <p><a href="/terms-of-use.php">Terms of Use</a></p>
      </div>
    </div>
    <div class="footer-bottom">
      <span>&copy; <?= date('Y') ?> <?= h(OPERATOR_NAME) ?>. All rights reserved.</span>
      <?php if ($footerViews > 0): ?>
        <span class="pageviews"><?= number_format($footerViews) ?> views on this page</span>
      <?php endif; ?>
    </div>
  </div>
</footer>

<?php if (!empty($showCookieBanner)): ?>
<div id="cookie-banner" class="cookie-banner" hidden>
  <p>We use a strictly-necessary, cookie-free visit counter to understand site traffic. No personal profiling, no third-party trackers. See our <a href="/privacy-policy.php">Privacy Policy</a> for details.</p>
  <button id="cookie-ack" type="button">Got it</button>
</div>
<script>
(function () {
  try {
    var KEY = 'beckwied_cookie_ack';
    var banner = document.getElementById('cookie-banner');
    var btn = document.getElementById('cookie-ack');
    if (!banner || !btn) { return; }
    if (!localStorage.getItem(KEY)) {
      banner.hidden = false;
    }
    btn.addEventListener('click', function () {
      try { localStorage.setItem(KEY, '1'); } catch (e) {}
      banner.hidden = true;
    });
  } catch (e) {
    // localStorage unavailable (private mode, etc.) - fail silently, no banner.
  }
})();
</script>
<?php endif; ?>
</body>
</html>
