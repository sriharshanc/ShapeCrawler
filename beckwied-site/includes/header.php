<?php
/**
 * Shared page header. Expects $pageTitle and optional $pageDescription
 * to be set by the including page before this file is required.
 */
$pageTitle = $pageTitle ?? SITE_NAME;
$pageDescription = $pageDescription ?? SITE_TAGLINE;
$currentPage = basename($_SERVER['SCRIPT_NAME']);
?><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><?= h($pageTitle) ?> · <?= h(SITE_NAME) ?></title>
<meta name="description" content="<?= h($pageDescription) ?>">
<link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>
<header class="site-header">
  <div class="wrap">
    <a class="brand" href="/index.php"><?= h(SITE_NAME) ?></a>
    <nav class="site-nav">
      <a href="/index.php#features" class="<?= $currentPage === 'index.php' ? 'active' : '' ?>">Features</a>
      <a href="/index.php#contact">Contact</a>
      <a href="/privacy-policy.php" class="<?= $currentPage === 'privacy-policy.php' ? 'active' : '' ?>">Privacy Policy</a>
      <a href="/terms-of-use.php" class="<?= $currentPage === 'terms-of-use.php' ? 'active' : '' ?>">Terms of Use</a>
    </nav>
  </div>
</header>
<main>
