<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Configuration de Production
    |--------------------------------------------------------------------------
    |
    | Configuration optimisée pour l'environnement de production
    |
    */

    'app' => [
        'debug' => false,
        'env' => 'production',
        'url' => env('APP_URL', 'https://api.cerebral.com'),
    ],

    'database' => [
        'default' => 'mysql',
        'connections' => [
            'mysql' => [
                'driver' => 'mysql',
                'host' => env('DB_HOST', '127.0.0.1'),
                'port' => env('DB_PORT', '3306'),
                'database' => env('DB_DATABASE', 'cerebral_prod'),
                'username' => env('DB_USERNAME', 'cerebral_user'),
                'password' => env('DB_PASSWORD', ''),
                'charset' => 'utf8mb4',
                'collation' => 'utf8mb4_unicode_ci',
                'prefix' => '',
                'strict' => true,
                'engine' => 'InnoDB',
                'options' => extension_loaded('pdo_mysql') ? array_filter([
                    PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
                ]) : [],
            ],
        ],
    ],

    'cache' => [
        'default' => 'redis',
        'stores' => [
            'redis' => [
                'driver' => 'redis',
                'connection' => 'cache',
                'lock_connection' => 'default',
            ],
        ],
    ],

    'queue' => [
        'default' => 'redis',
        'connections' => [
            'redis' => [
                'driver' => 'redis',
                'connection' => 'default',
                'queue' => env('REDIS_QUEUE', 'default'),
                'retry_after' => 90,
                'block_for' => null,
            ],
        ],
    ],

    'session' => [
        'driver' => 'redis',
        'lifetime' => 120,
        'expire_on_close' => false,
        'encrypt' => true,
        'secure' => true,
        'http_only' => true,
        'same_site' => 'lax',
    ],

    'sanctum' => [
        'stateful' => explode(',', env('SANCTUM_STATEFUL_DOMAINS', '')),
        'expiration' => env('SANCTUM_TOKEN_EXPIRATION', 60 * 24 * 7), // 7 jours
        'middleware' => [
            'verify_csrf_token' => App\Http\Middleware\VerifyCsrfToken::class,
            'encrypt_cookies' => App\Http\Middleware\EncryptCookies::class,
        ],
    ],

    'logging' => [
        'default' => 'stack',
        'channels' => [
            'stack' => [
                'driver' => 'stack',
                'channels' => ['daily', 'slack'],
                'ignore_exceptions' => false,
            ],
            'daily' => [
                'driver' => 'daily',
                'path' => storage_path('logs/laravel.log'),
                'level' => env('LOG_LEVEL', 'warning'),
                'days' => 14,
            ],
            'slack' => [
                'driver' => 'slack',
                'url' => env('LOG_SLACK_WEBHOOK_URL'),
                'username' => 'Cerebral API Logger',
                'emoji' => ':boom:',
                'level' => env('LOG_LEVEL', 'critical'),
            ],
        ],
    ],

    'optimization' => [
        'route_cache' => true,
        'config_cache' => true,
        'view_cache' => true,
        'composer_optimize' => true,
    ],

    'security' => [
        'rate_limiting' => [
            'enabled' => true,
            'max_attempts' => 60,
            'decay_minutes' => 1,
        ],
        'cors' => [
            'allowed_origins' => explode(',', env('CORS_ALLOWED_ORIGINS', '')),
            'allowed_methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
            'allowed_headers' => ['*'],
            'exposed_headers' => [],
            'max_age' => 0,
            'supports_credentials' => false,
        ],
    ],
];
