<?php
/**
 * Small helper functions shared across pages.
 */

require_once __DIR__ . '/db.php';

/**
 * Escape a string for safe HTML output.
 */
function h(?string $value): string
{
    return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8');
}

/**
 * Record one view of $page for today and return the all-time total for
 * that page. Uses a single MySQL table (page, view_date, views) so a
 * repeated load on the same day increments one counter instead of
 * inserting a new row per visit.
 *
 * Never lets a DB hiccup break the page: on any failure it just returns 0.
 */
function record_pageview(string $page): int
{
    $pdo = get_db();
    if (!$pdo) {
        return 0;
    }

    try {
        $stmt = $pdo->prepare(
            'INSERT INTO pageviews (page, view_date, views)
             VALUES (:page, CURDATE(), 1)
             ON DUPLICATE KEY UPDATE views = views + 1'
        );
        $stmt->execute(['page' => $page]);

        $total = $pdo->prepare('SELECT COALESCE(SUM(views), 0) AS total FROM pageviews WHERE page = :page');
        $total->execute(['page' => $page]);
        return (int) $total->fetch()['total'];
    } catch (PDOException $e) {
        error_log('[beckwied] pageview tracking failed: ' . $e->getMessage());
        return 0;
    }
}

/**
 * Get (and lazily create) the CSRF token stored in the session.
 */
function csrf_token(): string
{
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_start();
    }
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function csrf_check(?string $submittedToken): bool
{
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_start();
    }
    return !empty($submittedToken)
        && !empty($_SESSION['csrf_token'])
        && hash_equals($_SESSION['csrf_token'], $submittedToken);
}
