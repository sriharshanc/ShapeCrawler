<?php
/**
 * Handles the contact form POST from index.php: validates input, stores
 * the message in MySQL, best-effort emails a notification, then redirects
 * back to the homepage with a flash message. Never renders its own HTML.
 */
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/functions.php';

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

function redirect_with_flash(string $type, string $message, array $errors = [], array $old = []): void
{
    $_SESSION['contact_flash'] = [
        'type'    => $type,
        'message' => $message,
        'errors'  => $errors,
        'old'     => $old,
    ];
    header('Location: /index.php#contact');
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: /index.php#contact');
    exit;
}

// Honeypot: a real visitor never fills this hidden field in.
if (!empty($_POST['website'])) {
    // Silently pretend success so bots don't learn to skip the field.
    redirect_with_flash('success', 'Thanks — your message has been sent.');
}

if (!csrf_check($_POST['csrf_token'] ?? null)) {
    redirect_with_flash('error', 'Your session expired. Please try again.');
}

$name    = trim((string) ($_POST['name'] ?? ''));
$email   = trim((string) ($_POST['email'] ?? ''));
$message = trim((string) ($_POST['message'] ?? ''));

$errors = [];
if ($name === '' || mb_strlen($name) > 150) {
    $errors[] = 'Please enter your name (max 150 characters).';
}
if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email) > 190) {
    $errors[] = 'Please enter a valid email address.';
}
if ($message === '' || mb_strlen($message) > 4000) {
    $errors[] = 'Please enter a message (max 4000 characters).';
}

if ($errors) {
    redirect_with_flash(
        'error',
        'Please fix the following:',
        $errors,
        ['name' => $name, 'email' => $email, 'message' => $message]
    );
}

$pdo = get_db();
if (!$pdo) {
    redirect_with_flash(
        'error',
        'Sorry, something went wrong on our end. Please email us directly instead.',
        [],
        ['name' => $name, 'email' => $email, 'message' => $message]
    );
}

try {
    $stmt = $pdo->prepare(
        'INSERT INTO contact_messages (name, email, message, ip_address, created_at)
         VALUES (:name, :email, :message, :ip, NOW())'
    );
    $stmt->execute([
        'name'    => $name,
        'email'   => $email,
        'message' => $message,
        'ip'      => substr((string) ($_SERVER['REMOTE_ADDR'] ?? ''), 0, 45),
    ]);
} catch (PDOException $e) {
    error_log('[beckwied] contact insert failed: ' . $e->getMessage());
    redirect_with_flash(
        'error',
        'Sorry, something went wrong on our end. Please email us directly instead.',
        [],
        ['name' => $name, 'email' => $email, 'message' => $message]
    );
}

// Best-effort email notification. If mail() isn't configured on the
// hosting account, the message is still safely stored in MySQL.
$subject = 'New Beckwied contact form message from ' . $name;
$body = "Name: $name\nEmail: $email\n\nMessage:\n$message\n";
$headers = 'From: no-reply@' . parse_url(SITE_URL, PHP_URL_HOST) . "\r\n" .
           'Reply-To: ' . $email;
@mail(CONTACT_EMAIL, $subject, $body, $headers);

redirect_with_flash('success', 'Thanks — your message has been sent. We\'ll get back to you soon.');
