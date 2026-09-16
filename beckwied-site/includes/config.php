<?php
/**
 * Site configuration for the Beckwied marketing website.
 *
 * IMPORTANT: Before going live on Strato, replace the DB_* placeholders
 * below with the real credentials from your Strato customer login
 * (Kundenlogin -> Datenbanken -> MySQL-Datenbank). Strato provisions one
 * database per package; the host is almost always "rdbms.strato.de".
 *
 * Do NOT commit real production credentials to a public repository.
 * If this repo is ever made public, move these values into environment
 * variables or a config file that is excluded via .gitignore instead.
 */

// --- Database connection -----------------------------------------------
define('DB_HOST', 'localhost');           // Strato: usually "rdbms.strato.de"
define('DB_NAME', 'TODO_your_db_name');   // Strato: e.g. "DB12345678"
define('DB_USER', 'TODO_your_db_user');   // Strato: e.g. "U12345678"
define('DB_PASS', 'TODO_your_db_password');
define('DB_CHARSET', 'utf8mb4');

// --- Site identity -------------------------------------------------------
define('SITE_NAME', 'Beckwied');
define('SITE_TAGLINE', 'Clinic & patient management, made simple.');
define('SITE_URL', 'https://beckwied.digihlth.com');

define('OPERATOR_NAME', 'Digihlth');
define('OPERATOR_ADDRESS_LINE1', 'Mainparkstr 5');
define('OPERATOR_ADDRESS_LINE2', '63814 Mainaschaff, Germany');
define('CONTACT_EMAIL', 'contact-us@beckwied.digihlth.com');

// --- App store links -----------------------------------------------------
// TODO: replace with your real listing URLs once the app is published.
define('APP_STORE_URL', '');   // e.g. 'https://apps.apple.com/app/idXXXXXXXXX'
define('PLAY_STORE_URL', '');  // e.g. 'https://play.google.com/store/apps/details?id=com.digihlth.beckwied'

// --- Misc ------------------------------------------------------------------
define('SITE_TIMEZONE', 'Europe/Berlin');
date_default_timezone_set(SITE_TIMEZONE);
