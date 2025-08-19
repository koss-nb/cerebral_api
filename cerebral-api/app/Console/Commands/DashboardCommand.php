<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Models\Project;
use App\Models\Task;
use App\Models\Personnel;
use App\Models\Budget;
use App\Models\Workflow;
use App\Models\Notification;
use Carbon\Carbon;

class DashboardCommand extends Command
{
    /**
     * The name and signature of the console command.
     */
    protected $signature = 'dashboard:manage 
                            {action : Action à effectuer (stats, cache, alerts, health, report)}
                            {--format=json : Format de sortie (json, table, csv)}
                            {--days=30 : Nombre de jours pour les rapports}
                            {--clear : Vider le cache du dashboard}';

    /**
     * The console command description.
     */
    protected $description = 'Gérer le dashboard et ses métriques';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $action = $this->argument('action');
        $format = $this->option('format');
        $days = (int) $this->option('days');
        $clear = $this->option('clear');

        if ($clear) {
            $this->clearDashboardCache();
        }

        switch ($action) {
            case 'stats':
                $this->showDashboardStats($format);
                break;
            case 'cache':
                $this->manageDashboardCache();
                break;
            case 'alerts':
                $this->checkDashboardAlerts($format);
                break;
            case 'health':
                $this->checkDashboardHealth($format);
                break;
            case 'report':
                $this->generateDashboardReport($format, $days);
                break;
            default:
                $this->error("Action inconnue: {$action}");
                $this->showHelp();
                return 1;
        }

        return 0;
    }

    /**
     * Afficher les statistiques du dashboard.
     */
    protected function showDashboardStats(string $format): void
    {
        $this->info('📊 Récupération des statistiques du dashboard...');

        $stats = [
            'overview' => [
                'total_projects' => Project::count(),
                'total_tasks' => Task::count(),
                'total_personnel' => Personnel::count(),
                'total_budgets' => Budget::count(),
                'total_workflows' => Workflow::count(),
            ],
            'performance' => [
                'task_completion_rate' => $this->calculateTaskCompletionRate(),
                'project_success_rate' => $this->calculateProjectSuccessRate(),
                'budget_efficiency' => $this->calculateBudgetEfficiency(),
                'personnel_utilization' => $this->calculatePersonnelUtilization(),
            ],
            'recent_activity' => [
                'projects_created_today' => Project::whereDate('created_at', today())->count(),
                'tasks_completed_today' => Task::whereDate('updated_at', today())->where('status', 'completed')->count(),
                'new_notifications' => Notification::whereDate('created_at', today())->count(),
            ],
        ];

        $this->outputStats($stats, $format);
    }

    /**
     * Gérer le cache du dashboard.
     */
    protected function manageDashboardCache(): void
    {
        $this->info('🗄️ Gestion du cache du dashboard...');

        $cacheKeys = [
            'dashboard_stats',
            'dashboard_chart_data',
            'dashboard_alerts',
            'dashboard_workload',
            'dashboard_analytics',
        ];

        $cacheInfo = [];
        foreach ($cacheKeys as $key) {
            $value = Cache::get($key);
            $cacheInfo[$key] = [
                'exists' => $value !== null,
                'size' => $value ? strlen(serialize($value)) : 0,
                'ttl' => Cache::getTimeToLive($key),
            ];
        }

        $this->table(
            ['Clé', 'Existe', 'Taille (bytes)', 'TTL'],
            collect($cacheInfo)->map(function ($info, $key) {
                return [
                    $key,
                    $info['exists'] ? '✅' : '❌',
                    $info['size'],
                    $info['ttl'] ? $info['ttl'] . 's' : 'N/A',
                ];
            })->toArray()
        );

        if ($this->confirm('Voulez-vous vider le cache du dashboard ?')) {
            $this->clearDashboardCache();
        }
    }

    /**
     * Vérifier les alertes du dashboard.
     */
    protected function checkDashboardAlerts(string $format): void
    {
        $this->info('🚨 Vérification des alertes du dashboard...');

        $alerts = [];

        // Vérifier les projets en retard
        $overdueProjects = Project::where('end_date', '<', now())
            ->where('status', '!=', 'completed')
            ->count();

        if ($overdueProjects > 0) {
            $alerts[] = [
                'type' => 'warning',
                'title' => 'Projets en retard',
                'message' => "{$overdueProjects} projet(s) sont en retard",
                'count' => $overdueProjects,
                'priority' => 'medium',
            ];
        }

        // Vérifier les tâches en retard
        $overdueTasks = Task::where('due_date', '<', now())
            ->where('status', '!=', 'completed')
            ->count();

        if ($overdueTasks > 0) {
            $alerts[] = [
                'type' => 'danger',
                'title' => 'Tâches en retard',
                'message' => "{$overdueTasks} tâche(s) sont en retard",
                'count' => $overdueTasks,
                'priority' => 'high',
            ];
        }

        // Vérifier les budgets en attente
        $pendingBudgets = Budget::where('status', 'pending')->count();

        if ($pendingBudgets > 0) {
            $alerts[] = [
                'type' => 'info',
                'title' => 'Budgets en attente',
                'message' => "{$pendingBudgets} budget(s) en attente d'approbation",
                'count' => $pendingBudgets,
                'priority' => 'medium',
            ];
        }

        if (empty($alerts)) {
            $this->info('✅ Aucune alerte détectée. Le système fonctionne normalement.');
            return;
        }

        $this->outputAlerts($alerts, $format);
    }

    /**
     * Vérifier la santé du dashboard.
     */
    protected function checkDashboardHealth(string $format): void
    {
        $this->info('🏥 Vérification de la santé du dashboard...');

        $health = [
            'database' => [
                'status' => $this->checkDatabaseConnection(),
                'response_time' => $this->measureDatabaseResponseTime(),
            ],
            'cache' => [
                'status' => $this->checkCacheConnection(),
                'response_time' => $this->measureCacheResponseTime(),
            ],
            'models' => [
                'projects' => Project::count(),
                'tasks' => Task::count(),
                'personnel' => Personnel::count(),
                'budgets' => Budget::count(),
            ],
            'performance' => [
                'memory_usage' => memory_get_usage(true),
                'peak_memory' => memory_get_peak_usage(true),
                'execution_time' => microtime(true) - LARAVEL_START,
            ],
        ];

        $this->outputHealth($health, $format);
    }

    /**
     * Générer un rapport du dashboard.
     */
    protected function generateDashboardReport(string $format, int $days): void
    {
        $this->info("📋 Génération du rapport du dashboard pour les {$days} derniers jours...");

        $startDate = now()->subDays($days);

        $report = [
            'period' => [
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => now()->format('Y-m-d'),
                'days' => $days,
            ],
            'projects' => [
                'created' => Project::where('created_at', '>=', $startDate)->count(),
                'completed' => Project::where('updated_at', '>=', $startDate)->where('status', 'completed')->count(),
                'overdue' => Project::where('end_date', '<', now())->where('status', '!=', 'completed')->count(),
                'by_status' => Project::select('status', DB::raw('count(*) as count'))
                    ->where('created_at', '>=', $startDate)
                    ->groupBy('status')
                    ->get(),
            ],
            'tasks' => [
                'created' => Task::where('created_at', '>=', $startDate)->count(),
                'completed' => Task::where('updated_at', '>=', $startDate)->where('status', 'completed')->count(),
                'overdue' => Task::where('due_date', '<', now())->where('status', '!=', 'completed')->count(),
                'by_priority' => Task::select('priority', DB::raw('count(*) as count'))
                    ->where('created_at', '>=', $startDate)
                    ->groupBy('priority')
                    ->get(),
            ],
            'budgets' => [
                'total_amount' => Budget::where('created_at', '>=', $startDate)->sum('amount'),
                'approved_amount' => Budget::where('created_at', '>=', $startDate)->where('is_approved', true)->sum('amount'),
                'pending_amount' => Budget::where('created_at', '>=', $startDate)->where('status', 'pending')->sum('amount'),
            ],
            'performance_metrics' => [
                'task_completion_rate' => $this->calculateTaskCompletionRate(),
                'project_success_rate' => $this->calculateProjectSuccessRate(),
                'budget_efficiency' => $this->calculateBudgetEfficiency(),
                'average_project_duration' => $this->calculateAverageProjectDuration($startDate),
            ],
        ];

        $this->outputReport($report, $format);
    }

    /**
     * Vider le cache du dashboard.
     */
    protected function clearDashboardCache(): void
    {
        $this->info('🧹 Vidage du cache du dashboard...');

        $cacheKeys = [
            'dashboard_stats',
            'dashboard_chart_data',
            'dashboard_alerts',
            'dashboard_workload',
            'dashboard_analytics',
        ];

        foreach ($cacheKeys as $key) {
            Cache::forget($key);
        }

        $this->info('✅ Cache du dashboard vidé avec succès.');
    }

    /**
     * Afficher les statistiques dans le format demandé.
     */
    protected function outputStats(array $stats, string $format): void
    {
        switch ($format) {
            case 'json':
                $this->line(json_encode($stats, JSON_PRETTY_PRINT));
                break;
            case 'table':
                $this->displayStatsTable($stats);
                break;
            case 'csv':
                $this->outputCsv($stats);
                break;
            default:
                $this->line(json_encode($stats, JSON_PRETTY_PRINT));
        }
    }

    /**
     * Afficher les alertes dans le format demandé.
     */
    protected function outputAlerts(array $alerts, string $format): void
    {
        switch ($format) {
            case 'json':
                $this->line(json_encode($alerts, JSON_PRETTY_PRINT));
                break;
            case 'table':
                $this->table(
                    ['Type', 'Titre', 'Message', 'Compteur', 'Priorité'],
                    collect($alerts)->map(function ($alert) {
                        return [
                            $this->getAlertIcon($alert['type']),
                            $alert['title'],
                            $alert['message'],
                            $alert['count'],
                            $alert['priority'],
                        ];
                    })->toArray()
                );
                break;
            case 'csv':
                $this->outputCsv($alerts);
                break;
            default:
                $this->line(json_encode($alerts, JSON_PRETTY_PRINT));
        }
    }

    /**
     * Afficher la santé du système dans le format demandé.
     */
    protected function outputHealth(array $health, string $format): void
    {
        switch ($format) {
            case 'json':
                $this->line(json_encode($health, JSON_PRETTY_PRINT));
                break;
            case 'table':
                $this->displayHealthTable($health);
                break;
            case 'csv':
                $this->outputCsv($health);
                break;
            default:
                $this->line(json_encode($health, JSON_PRETTY_PRINT));
        }
    }

    /**
     * Afficher le rapport dans le format demandé.
     */
    protected function outputReport(array $report, string $format): void
    {
        switch ($format) {
            case 'json':
                $this->line(json_encode($report, JSON_PRETTY_PRINT));
                break;
            case 'table':
                $this->displayReportTable($report);
                break;
            case 'csv':
                $this->outputCsv($report);
                break;
            default:
                $this->line(json_encode($report, JSON_PRETTY_PRINT));
        }
    }

    /**
     * Afficher les statistiques sous forme de tableau.
     */
    protected function displayStatsTable(array $stats): void
    {
        $this->info('📊 Vue d\'ensemble:');
        $this->table(
            ['Métrique', 'Valeur'],
            collect($stats['overview'])->map(function ($value, $key) {
                return [ucfirst(str_replace('_', ' ', $key)), $value];
            })->toArray()
        );

        $this->info('📈 Performance:');
        $this->table(
            ['Métrique', 'Valeur'],
            collect($stats['performance'])->map(function ($value, $key) {
                return [ucfirst(str_replace('_', ' ', $key)), $value . '%'];
            })->toArray()
        );

        $this->info('🔄 Activité récente:');
        $this->table(
            ['Métrique', 'Valeur'],
            collect($stats['recent_activity'])->map(function ($value, $key) {
                return [ucfirst(str_replace('_', ' ', $key)), $value];
            })->toArray()
        );
    }

    /**
     * Afficher la santé du système sous forme de tableau.
     */
    protected function displayHealthTable(array $health): void
    {
        $this->info('🔌 Connexions:');
        $this->table(
            ['Service', 'Statut', 'Temps de réponse'],
            [
                ['Base de données', $health['database']['status'] ? '✅' : '❌', $health['database']['response_time'] . 'ms'],
                ['Cache', $health['cache']['status'] ? '✅' : '❌', $health['cache']['response_time'] . 'ms'],
            ]
        );

        $this->info('📊 Modèles:');
        $this->table(
            ['Modèle', 'Compteur'],
            collect($health['models'])->map(function ($value, $key) {
                return [ucfirst($key), $value];
            })->toArray()
        );

        $this->info('⚡ Performance:');
        $this->table(
            ['Métrique', 'Valeur'],
            [
                ['Mémoire utilisée', $this->formatBytes($health['performance']['memory_usage'])],
                ['Pic de mémoire', $this->formatBytes($health['performance']['peak_memory'])],
                ['Temps d\'exécution', round($health['performance']['execution_time'] * 1000, 2) . 'ms'],
            ]
        );
    }

    /**
     * Afficher le rapport sous forme de tableau.
     */
    protected function displayReportTable(array $report): void
    {
        $this->info('📅 Période:');
        $this->table(
            ['Métrique', 'Valeur'],
            [
                ['Date de début', $report['period']['start_date']],
                ['Date de fin', $report['period']['end_date']],
                ['Nombre de jours', $report['period']['days']],
            ]
        );

        $this->info('📋 Projets:');
        $this->table(
            ['Métrique', 'Valeur'],
            [
                ['Créés', $report['projects']['created']],
                ['Complétés', $report['projects']['completed']],
                ['En retard', $report['projects']['overdue']],
            ]
        );

        $this->info('✅ Tâches:');
        $this->table(
            ['Métrique', 'Valeur'],
            [
                ['Créées', $report['tasks']['created']],
                ['Complétées', $report['tasks']['completed']],
                ['En retard', $report['tasks']['overdue']],
            ]
        );

        $this->info('💰 Budgets:');
        $this->table(
            ['Métrique', 'Valeur'],
            [
                ['Montant total', $this->formatCurrency($report['budgets']['total_amount'])],
                ['Montant approuvé', $this->formatCurrency($report['budgets']['approved_amount'])],
                ['Montant en attente', $this->formatCurrency($report['budgets']['pending_amount'])],
            ]
        );
    }

    /**
     * Générer une sortie CSV.
     */
    protected function outputCsv(array $data): void
    {
        $csv = $this->arrayToCsv($data);
        $this->line($csv);
    }

    /**
     * Convertir un tableau en CSV.
     */
    protected function arrayToCsv(array $data): string
    {
        $output = fopen('php://temp', 'r+');

        if (empty($data)) {
            return '';
        }

        // En-têtes
        $headers = array_keys(reset($data));
        fputcsv($output, $headers);

        // Données
        foreach ($data as $row) {
            fputcsv($output, $row);
        }

        rewind($output);
        $csv = stream_get_contents($output);
        fclose($output);

        return $csv;
    }

    /**
     * Obtenir l'icône pour le type d'alerte.
     */
    protected function getAlertIcon(string $type): string
    {
        return match ($type) {
            'danger' => '🚨',
            'warning' => '⚠️',
            'info' => 'ℹ️',
            'success' => '✅',
            default => '❓',
        };
    }

    /**
     * Vérifier la connexion à la base de données.
     */
    protected function checkDatabaseConnection(): bool
    {
        try {
            DB::connection()->getPdo();
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * Vérifier la connexion au cache.
     */
    protected function checkCacheConnection(): bool
    {
        try {
            Cache::store()->get('test');
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * Mesurer le temps de réponse de la base de données.
     */
    protected function measureDatabaseResponseTime(): float
    {
        $start = microtime(true);
        DB::select('SELECT 1');
        return round((microtime(true) - $start) * 1000, 2);
    }

    /**
     * Mesurer le temps de réponse du cache.
     */
    protected function measureCacheResponseTime(): float
    {
        $start = microtime(true);
        Cache::get('test');
        return round((microtime(true) - $start) * 1000, 2);
    }

    /**
     * Calculer le taux de completion des tâches.
     */
    protected function calculateTaskCompletionRate(): float
    {
        $totalTasks = Task::count();
        if ($totalTasks === 0) {
            return 0;
        }

        $completedTasks = Task::where('status', 'completed')->count();
        return round(($completedTasks / $totalTasks) * 100, 2);
    }

    /**
     * Calculer le taux de succès des projets.
     */
    protected function calculateProjectSuccessRate(): float
    {
        $totalProjects = Project::count();
        if ($totalProjects === 0) {
            return 0;
        }

        $completedProjects = Project::where('status', 'completed')->count();
        return round(($completedProjects / $totalProjects) * 100, 2);
    }

    /**
     * Calculer l'efficacité budgétaire.
     */
    protected function calculateBudgetEfficiency(): float
    {
        $totalBudgets = Budget::count();
        if ($totalBudgets === 0) {
            return 0;
        }

        $executedBudgets = Budget::where('is_executed', true)->count();
        return round(($executedBudgets / $totalBudgets) * 100, 2);
    }

    /**
     * Calculer l'utilisation du personnel.
     */
    protected function calculatePersonnelUtilization(): float
    {
        $totalPersonnel = Personnel::where('status', 'active')->count();
        if ($totalPersonnel === 0) {
            return 0;
        }

        $personnelWithTasks = Personnel::where('status', 'active')
            ->whereHas('tasks', function ($query) {
                $query->where('status', '!=', 'completed');
            })
            ->count();

        return round(($personnelWithTasks / $totalPersonnel) * 100, 2);
    }

    /**
     * Calculer la durée moyenne des projets.
     */
    protected function calculateAverageProjectDuration(Carbon $startDate): float
    {
        $projects = Project::where('status', 'completed')
            ->where('created_at', '>=', $startDate)
            ->whereNotNull('start_date')
            ->whereNotNull('end_date')
            ->get();

        if ($projects->isEmpty()) {
            return 0;
        }

        $totalDuration = $projects->sum(function ($project) {
            return $project->start_date->diffInDays($project->end_date);
        });

        return round($totalDuration / $projects->count(), 1);
    }

    /**
     * Formater les bytes en format lisible.
     */
    protected function formatBytes(int $bytes): string
    {
        $units = ['B', 'KB', 'MB', 'GB'];
        $bytes = max($bytes, 0);
        $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
        $pow = min($pow, count($units) - 1);

        $bytes /= pow(1024, $pow);

        return round($bytes, 2) . ' ' . $units[$pow];
    }

    /**
     * Formater la monnaie.
     */
    protected function formatCurrency(float $amount): string
    {
        return number_format($amount, 2, ',', ' ') . ' €';
    }

    /**
     * Afficher l'aide de la commande.
     */
    protected function showHelp(): void
    {
        $this->info('📊 Commandes disponibles:');
        $this->line('');
        $this->line('  stats     - Afficher les statistiques du dashboard');
        $this->line('  cache     - Gérer le cache du dashboard');
        $this->line('  alerts    - Vérifier les alertes du dashboard');
        $this->line('  health    - Vérifier la santé du système');
        $this->line('  report    - Générer un rapport du dashboard');
        $this->line('');
        $this->line('📝 Options disponibles:');
        $this->line('  --format=json|table|csv  - Format de sortie');
        $this->line('  --days=30               - Nombre de jours pour les rapports');
        $this->line('  --clear                 - Vider le cache du dashboard');
        $this->line('');
        $this->line('💡 Exemples:');
        $this->line('  php artisan dashboard:manage stats --format=table');
        $this->line('  php artisan dashboard:manage report --days=7 --format=csv');
        $this->line('  php artisan dashboard:manage cache --clear');
    }
}
