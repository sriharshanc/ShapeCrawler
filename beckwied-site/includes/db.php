<?php
/**
 * Shared PDO connection. Every page that needs the database includes this
 * file (after config.php). Connection errors are logged, never echoed with
 * details, so DB credentials never leak to visitors.
 */

require_once __DIR__ . '/config.php';

function get_db(): ?PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dsn = sprintf(
        'mysql:host=%s;dbname=%s;charset=%s',
        DB_HOST,
        DB_NAME,
        DB_CHARSET
    );

    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
    } catch (PDOException $e) {
        error_log('[beckwied] DB connection failed: ' . $e->getMessage());
        return null; // Caller must handle a null connection gracefully.
    }

    return $pdo;
}
