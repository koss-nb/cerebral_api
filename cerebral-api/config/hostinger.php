<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Configuration Hostinger
    |--------------------------------------------------------------------------
    |
    | Configuration spécifique pour le déploiement sur Hostinger
    | Gestion automatique des collations MySQL 5.7 vs MySQL 8.0
    |
    */

    'database' => [
        'default_collation' => env('HOSTINGER_MYSQL_VERSION') === '5.7'
            ? 'utf8mb4_unicode_ci'
            : 'utf8mb4_0900_ai_ci',

        'charset' => 'utf8mb4',

        'compatible_versions' => [
            '5.7' => 'utf8mb4_unicode_ci',
            '8.0' => 'utf8mb4_0900_ai_ci',
        ],
    ],

    'optimization' => [
        'enable_cache' => true,
        'enable_compression' => true,
        'max_execution_time' => 300,
        'memory_limit' => '512M',
    ],

    'security' => [
        'force_https' => true,
        'secure_headers' => true,
        'cors_allowed_origins' => [
            'https://votre-domaine.com',
            'https://www.votre-domaine.com',
        ],
    ],

    'monitoring' => [
        'enable_logging' => true,
        'log_level' => 'info',
        'performance_monitoring' => true,
    ],
];
