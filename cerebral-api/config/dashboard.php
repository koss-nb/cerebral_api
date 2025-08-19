<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Dashboard Configuration
    |--------------------------------------------------------------------------
    |
    | Configuration pour le dashboard et ses métriques
    |
    */

    'cache' => [
        'enabled' => env('DASHBOARD_CACHE_ENABLED', true),
        'ttl' => env('DASHBOARD_CACHE_TTL', 300), // 5 minutes
        'prefix' => 'dashboard_',
    ],

    'metrics' => [
        'refresh_interval' => env('DASHBOARD_REFRESH_INTERVAL', 30), // secondes
        'max_data_points' => env('DASHBOARD_MAX_DATA_POINTS', 100),
        'time_range' => env('DASHBOARD_TIME_RANGE', 12), // mois
    ],

    'alerts' => [
        'enabled' => env('DASHBOARD_ALERTS_ENABLED', true),
        'check_interval' => env('DASHBOARD_ALERTS_CHECK_INTERVAL', 60), // secondes
        'max_alerts' => env('DASHBOARD_MAX_ALERTS', 50),
        
        'thresholds' => [
            'overdue_tasks_warning' => env('DASHBOARD_OVERDUE_TASKS_WARNING', 5),
            'overdue_projects_warning' => env('DASHBOARD_OVERDUE_PROJECTS_WARNING', 2),
            'high_workload_threshold' => env('DASHBOARD_HIGH_WORKLOAD_THRESHOLD', 8),
            'budget_variance_warning' => env('DASHBOARD_BUDGET_VARIANCE_WARNING', 20), // %
        ],
    ],

    'performance' => [
        'query_timeout' => env('DASHBOARD_QUERY_TIMEOUT', 10), // secondes
        'max_concurrent_queries' => env('DASHBOARD_MAX_CONCURRENT_QUERIES', 5),
        'enable_query_logging' => env('DASHBOARD_ENABLE_QUERY_LOGGING', false),
    ],

    'charts' => [
        'default_colors' => [
            '#3B82F6', // blue
            '#10B981', // green
            '#F59E0B', // yellow
            '#EF4444', // red
            '#8B5CF6', // purple
            '#06B6D4', // cyan
            '#F97316', // orange
            '#84CC16', // lime
        ],
        
        'chart_types' => [
            'project_timeline' => 'line',
            'task_status_distribution' => 'doughnut',
            'budget_trends' => 'bar',
            'personnel_performance' => 'radar',
            'monthly_activity' => 'area',
        ],
    ],

    'export' => [
        'enabled' => env('DASHBOARD_EXPORT_ENABLED', true),
        'formats' => ['json', 'csv', 'pdf'],
        'max_export_size' => env('DASHBOARD_MAX_EXPORT_SIZE', 10000), // enregistrements
    ],

    'notifications' => [
        'real_time_enabled' => env('DASHBOARD_REALTIME_NOTIFICATIONS', false),
        'webhook_url' => env('DASHBOARD_WEBHOOK_URL'),
        'slack_webhook' => env('DASHBOARD_SLACK_WEBHOOK'),
        'email_notifications' => env('DASHBOARD_EMAIL_NOTIFICATIONS', false),
    ],

    'security' => [
        'rate_limit' => env('DASHBOARD_RATE_LIMIT', 100), // requêtes par minute
        'max_request_size' => env('DASHBOARD_MAX_REQUEST_SIZE', 1024), // KB
        'enable_audit_log' => env('DASHBOARD_ENABLE_AUDIT_LOG', true),
    ],

    'customization' => [
        'enable_custom_metrics' => env('DASHBOARD_ENABLE_CUSTOM_METRICS', false),
        'enable_user_preferences' => env('DASHBOARD_ENABLE_USER_PREFERENCES', true),
        'default_language' => env('DASHBOARD_DEFAULT_LANGUAGE', 'fr'),
        'timezone' => env('DASHBOARD_TIMEZONE', 'Europe/Paris'),
    ],
];
