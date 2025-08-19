<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;

class DashboardServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        $this->mergeConfigFrom(
            __DIR__.'/../../config/dashboard.php', 'dashboard'
        );
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        $this->publishes([
            __DIR__.'/../../config/dashboard.php' => config_path('dashboard.php'),
        ], 'dashboard-config');

        $this->registerDashboardCommands();
        $this->registerDashboardMacros();
        $this->setupDashboardCache();
        $this->setupDashboardLogging();
    }

    /**
     * Register dashboard commands.
     */
    protected function registerDashboardCommands(): void
    {
        if ($this->app->runningInConsole()) {
            $this->commands([
                // Commands can be added here
            ]);
        }
    }

    /**
     * Register dashboard macros.
     */
    protected function registerDashboardMacros(): void
    {
        // Macro pour formater les pourcentages
        \Illuminate\Support\Str::macro('percentage', function ($value, $decimals = 2) {
            return round($value, $decimals) . '%';
        });

        // Macro pour formater les montants
        \Illuminate\Support\Str::macro('currency', function ($value, $currency = '€') {
            return number_format($value, 2, ',', ' ') . ' ' . $currency;
        });

        // Macro pour formater les durées
        \Illuminate\Support\Str::macro('duration', function ($minutes) {
            if ($minutes < 60) {
                return $minutes . ' min';
            }
            
            $hours = floor($minutes / 60);
            $remainingMinutes = $minutes % 60;
            
            if ($remainingMinutes === 0) {
                return $hours . 'h';
            }
            
            return $hours . 'h ' . $remainingMinutes . 'min';
        });
    }

    /**
     * Setup dashboard cache configuration.
     */
    protected function setupDashboardCache(): void
    {
        if (Config::get('dashboard.cache.enabled')) {
            // Configuration du cache pour le dashboard
            Cache::extend('dashboard', function ($app) {
                return Cache::repository(
                    $app['cache.store']->tags(['dashboard'])
                );
            });
        }
    }

    /**
     * Setup dashboard logging configuration.
     */
    protected function setupDashboardLogging(): void
    {
        if (Config::get('dashboard.performance.enable_query_logging')) {
            DB::listen(function ($query) {
                if (str_contains($query->sql, 'dashboard') || 
                    str_contains($query->sql, 'projects') ||
                    str_contains($query->sql, 'tasks') ||
                    str_contains($query->sql, 'budgets') ||
                    str_contains($query->sql, 'personnel')) {
                    
                    Log::channel('dashboard')->info('Dashboard Query', [
                        'sql' => $query->sql,
                        'bindings' => $query->bindings,
                        'time' => $query->time,
                    ]);
                }
            });
        }
    }

    /**
     * Get the services provided by the provider.
     */
    public function provides(): array
    {
        return [
            'dashboard',
        ];
    }
}
