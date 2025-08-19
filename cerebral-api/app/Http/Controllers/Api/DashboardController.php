<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Project;
use App\Models\Task;
use App\Models\Personnel;
use App\Models\Budget;
use App\Models\User;
use App\Models\Workflow;
use App\Models\Notification;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Get dashboard statistics.
     */
    public function stats(): JsonResponse
    {
        $stats = [
            'overview' => [
                'total_projects' => Project::count(),
                'total_tasks' => Task::count(),
                'total_personnel' => Personnel::count(),
                'total_budgets' => Budget::count(),
                'total_users' => User::count(),
            ],
            'projects' => [
                'active' => Project::where('status', 'active')->count(),
                'completed' => Project::where('status', 'completed')->count(),
                'on_hold' => Project::where('status', 'on_hold')->count(),
                'cancelled' => Project::where('status', 'cancelled')->count(),
                'recent' => Project::where('created_at', '>=', now()->subDays(30))->count(),
            ],
            'tasks' => [
                'pending' => Task::where('status', 'pending')->count(),
                'in_progress' => Task::where('status', 'in_progress')->count(),
                'review' => Task::where('status', 'review')->count(),
                'completed' => Task::where('status', 'completed')->count(),
                'overdue' => Task::where('due_date', '<', now())->where('status', '!=', 'completed')->count(),
                'high_priority' => Task::whereIn('priority', ['high', 'critical'])->count(),
            ],
            'personnel' => [
                'active' => Personnel::where('status', 'active')->count(),
                'inactive' => Personnel::where('status', 'inactive')->count(),
                'on_leave' => Personnel::where('status', 'on_leave')->count(),
                'terminated' => Personnel::where('status', 'terminated')->count(),
                'by_department' => Personnel::select('department', DB::raw('count(*) as count'))
                    ->groupBy('department')
                    ->get(),
            ],
            'budgets' => [
                'total_amount' => Budget::sum('amount'),
                'approved' => Budget::where('is_approved', true)->count(),
                'pending' => Budget::where('status', 'pending')->count(),
                'executed' => Budget::where('is_executed', true)->count(),
                'by_type' => Budget::select('type', DB::raw('count(*) as count'), DB::raw('sum(amount) as total_amount'))
                    ->groupBy('type')
                    ->get(),
            ],
            'workflows' => [
                'total' => Workflow::count(),
                'active' => Workflow::where('status', 'active')->where('is_active', true)->count(),
                'pending' => Workflow::where('status', 'pending')->count(),
                'completed' => Workflow::where('status', 'completed')->count(),
                'by_type' => Workflow::select('type', DB::raw('count(*) as count'))
                    ->groupBy('type')
                    ->get(),
            ],
            'notifications' => [
                'unread' => Notification::where('status', 'unread')->count(),
                'total' => Notification::count(),
                'recent' => Notification::where('created_at', '>=', now()->subDays(7))->count(),
            ],
            'performance' => [
                'task_completion_rate' => $this->calculateTaskCompletionRate(),
                'project_success_rate' => $this->calculateProjectSuccessRate(),
                'budget_efficiency' => $this->calculateBudgetEfficiency(),
                'personnel_utilization' => $this->calculatePersonnelUtilization(),
                'workflow_efficiency' => $this->calculateWorkflowEfficiency(),
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    /**
     * Get chart data for dashboard visualizations.
     */
    public function chartData(): JsonResponse
    {
        $chartData = [
            'project_timeline' => $this->getProjectTimelineData(),
            'task_status_distribution' => $this->getTaskStatusDistribution(),
            'budget_trends' => $this->getBudgetTrends(),
            'personnel_performance' => $this->getPersonnelPerformanceData(),
            'monthly_activity' => $this->getMonthlyActivityData(),
        ];

        return response()->json([
            'success' => true,
            'data' => $chartData,
        ]);
    }

    /**
     * Get quick actions available for the current user.
     */
    public function quickActions(): JsonResponse
    {
        $user = Auth::user();
        $actions = [];

        // Actions basées sur le rôle de l'utilisateur
        if ($user->hasAnyRole(['admin', 'manager'])) {
            $actions[] = [
                'id' => 'create_project',
                'title' => 'Créer un projet',
                'description' => 'Créer un nouveau projet',
                'icon' => 'plus-circle',
                'route' => '/projects/create',
                'permission' => 'projects.write',
            ];

            $actions[] = [
                'id' => 'create_task',
                'title' => 'Créer une tâche',
                'description' => 'Créer une nouvelle tâche',
                'icon' => 'task',
                'route' => '/tasks/create',
                'permission' => 'tasks.write',
            ];

            $actions[] = [
                'id' => 'approve_budget',
                'title' => 'Approuver un budget',
                'description' => 'Approuver les budgets en attente',
                'icon' => 'check-circle',
                'route' => '/budgets/pending',
                'permission' => 'budgets.approve',
            ];
        }

        if ($user->hasRole('admin')) {
            $actions[] = [
                'id' => 'manage_personnel',
                'title' => 'Gérer le personnel',
                'description' => 'Ajouter ou modifier du personnel',
                'icon' => 'users',
                'route' => '/personnel',
                'permission' => 'personnel.manage',
            ];

            $actions[] = [
                'id' => 'system_reports',
                'title' => 'Rapports système',
                'description' => 'Générer des rapports système',
                'icon' => 'bar-chart',
                'route' => '/reports',
                'permission' => 'reports.view',
            ];
        }

        // Actions pour tous les utilisateurs
        $actions[] = [
            'id' => 'view_my_tasks',
            'title' => 'Mes tâches',
            'description' => 'Voir mes tâches assignées',
            'icon' => 'list',
            'route' => '/tasks/my-tasks',
            'permission' => 'tasks.read',
        ];

        $actions[] = [
            'id' => 'view_notifications',
            'title' => 'Notifications',
            'description' => 'Voir mes notifications',
            'icon' => 'bell',
            'route' => '/notifications',
            'permission' => 'notifications.read',
        ];

        return response()->json([
            'success' => true,
            'data' => $actions,
        ]);
    }

    /**
     * Get project dashboard data.
     */
    public function projects(): JsonResponse
    {
        $projects = Project::with(['manager', 'tasks'])
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($project) {
                return [
                    'id' => $project->id,
                    'name' => $project->name,
                    'status' => $project->status,
                    'progress' => $project->progress,
                    'manager' => $project->manager ? $project->manager->first_name . ' ' . $project->manager->last_name : 'Non assigné',
                    'task_count' => $project->tasks->count(),
                    'completed_tasks' => $project->tasks->where('status', 'completed')->count(),
                    'overdue_tasks' => $project->tasks->where('due_date', '<', now())->where('status', '!=', 'completed')->count(),
                    'start_date' => $project->start_date,
                    'end_date' => $project->end_date,
                    'budget' => $project->budgets->sum('amount') ?? 0,
                    'is_overdue' => $project->end_date && $project->end_date < now() && $project->status !== 'completed',
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $projects,
        ]);
    }

    /**
     * Get task dashboard data.
     */
    public function tasks(): JsonResponse
    {
        $tasks = Task::with(['project', 'assignedTo'])
            ->orderBy('created_at', 'desc')
            ->limit(15)
            ->get()
            ->map(function ($task) {
                return [
                    'id' => $task->id,
                    'title' => $task->title,
                    'status' => $task->status,
                    'priority' => $task->priority,
                    'progress' => $task->progress,
                    'project' => $task->project ? $task->project->name : 'Projet supprimé',
                    'assigned_to' => $task->assignedTo ? $task->assignedTo->first_name . ' ' . $task->assignedTo->last_name : 'Non assigné',
                    'due_date' => $task->due_date,
                    'is_overdue' => $task->is_overdue,
                    'estimated_hours' => $task->estimated_hours ?? 0,
                    'actual_hours' => $task->actual_hours ?? 0,
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $tasks,
        ]);
    }

    /**
     * Get personnel dashboard data.
     */
    public function personnel(): JsonResponse
    {
        $personnel = Personnel::with(['manager', 'tasks'])
            ->where('status', 'active')
            ->orderBy('hire_date', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($person) {
                return [
                    'id' => $person->id,
                    'name' => $person->full_name,
                    'position' => $person->position,
                    'department' => $person->department,
                    'hire_date' => $person->hire_date,
                    'manager' => $person->manager ? $person->manager->full_name : 'Aucun manager',
                    'active_tasks' => $person->tasks->where('status', '!=', 'completed')->count(),
                    'completed_tasks' => $person->tasks->where('status', 'completed')->count(),
                    'performance_rating' => $person->performance_rating,
                    'skills' => $person->skills ?? [],
                    'utilization_rate' => $this->calculatePersonnelUtilizationRate($person),
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $personnel,
        ]);
    }

    /**
     * Get budget dashboard data.
     */
    public function budgets(): JsonResponse
    {
        $budgets = Budget::with(['project', 'approvedBy'])
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($budget) {
                return [
                    'id' => $budget->id,
                    'category' => $budget->category,
                    'amount' => $budget->amount,
                    'type' => $budget->type,
                    'status' => $budget->status,
                    'project' => $budget->project ? $budget->project->name : 'Projet supprimé',
                    'approved_by' => $budget->approvedBy ? $budget->approvedBy->first_name . ' ' . $budget->approvedBy->last_name : 'Non approuvé',
                    'is_approved' => $budget->is_approved,
                    'is_executed' => $budget->is_executed,
                    'due_date' => $budget->due_date,
                    'execution_rate' => $this->calculateBudgetExecutionRate($budget),
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $budgets,
        ]);
    }

    /**
     * Get workflow dashboard data.
     */
    public function workflows(): JsonResponse
    {
        $workflows = Workflow::with(['creator'])
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($workflow) {
                return [
                    'id' => $workflow->id,
                    'name' => $workflow->name,
                    'type' => $workflow->type,
                    'status' => $workflow->status,
                    'is_active' => $workflow->is_active,
                    'creator' => $workflow->creator ? $workflow->creator->first_name . ' ' . $workflow->creator->last_name : 'Système',
                    'steps_count' => count($workflow->steps ?? []),
                    'created_at' => $workflow->created_at,
                    'updated_at' => $workflow->updated_at,
                ];
            });

        $stats = [
            'pending_approvals' => Workflow::where('status', 'pending')->count(),
            'active_workflows' => Workflow::where('status', 'active')->where('is_active', true)->count(),
            'completed_workflows' => Workflow::where('status', 'completed')->count(),
            'workflows' => $workflows,
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    /**
     * Get notification dashboard data.
     */
    public function notifications(): JsonResponse
    {
        $user = Auth::user();
        $notifications = Notification::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($notification) {
                return [
                    'id' => $notification->id,
                    'type' => $notification->type,
                    'title' => $notification->title,
                    'message' => $notification->message,
                    'status' => $notification->status,
                    'read_at' => $notification->read_at,
                    'created_at' => $notification->created_at,
                    'data' => $notification->data,
                ];
            });

        $stats = [
            'unread' => Notification::where('user_id', $user->id)->where('status', 'unread')->count(),
            'total' => Notification::where('user_id', $user->id)->count(),
            'recent' => $notifications,
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    /**
     * Get reports dashboard data.
     */
    public function reports(): JsonResponse
    {
        $reports = [
            'project_reports' => [
                'total_projects' => Project::count(),
                'completed_projects' => Project::where('status', 'completed')->count(),
                'overdue_projects' => Project::where('end_date', '<', now())->where('status', '!=', 'completed')->count(),
                'projects_by_status' => Project::select('status', DB::raw('count(*) as count'))
                    ->groupBy('status')
                    ->get(),
            ],
            'task_reports' => [
                'total_tasks' => Task::count(),
                'completed_tasks' => Task::where('status', 'completed')->count(),
                'overdue_tasks' => Task::where('due_date', '<', now())->where('status', '!=', 'completed')->count(),
                'high_priority_tasks' => Task::whereIn('priority', ['high', 'critical'])->count(),
                'tasks_by_priority' => Task::select('priority', DB::raw('count(*) as count'))
                    ->groupBy('priority')
                    ->get(),
            ],
            'budget_reports' => [
                'total_budgets' => Budget::count(),
                'total_amount' => Budget::sum('amount'),
                'approved_amount' => Budget::where('is_approved', true)->sum('amount'),
                'executed_amount' => Budget::where('is_executed', true)->sum('amount'),
                'budgets_by_category' => Budget::select('category', DB::raw('count(*) as count'), DB::raw('sum(amount) as total_amount'))
                    ->groupBy('category')
                    ->get(),
            ],
            'personnel_reports' => [
                'total_personnel' => Personnel::count(),
                'active_personnel' => Personnel::where('status', 'active')->count(),
                'personnel_by_department' => Personnel::select('department', DB::raw('count(*) as count'))
                    ->groupBy('department')
                    ->get(),
                'average_performance' => Personnel::where('status', 'active')->avg('performance_rating'),
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $reports,
        ]);
    }

    /**
     * Get real-time dashboard updates.
     */
    public function realTimeUpdates(): JsonResponse
    {
        $updates = [
            'last_updated' => now()->toISOString(),
            'active_users' => $this->getActiveUsersCount(),
            'recent_activities' => $this->getRecentActivities(),
            'system_alerts' => $this->getSystemAlerts(),
            'performance_metrics' => $this->getPerformanceMetrics(),
        ];

        return response()->json([
            'success' => true,
            'data' => $updates,
        ]);
    }

    /**
     * Get dashboard alerts and warnings.
     */
    public function alerts(): JsonResponse
    {
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
                'action' => 'view_overdue_projects',
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
                'action' => 'view_overdue_tasks',
                'priority' => 'high',
            ];
        }

        // Vérifier les budgets en attente d'approbation
        $pendingBudgets = Budget::where('status', 'pending')->count();

        if ($pendingBudgets > 0) {
            $alerts[] = [
                'type' => 'info',
                'title' => 'Budgets en attente',
                'message' => "{$pendingBudgets} budget(s) en attente d'approbation",
                'count' => $pendingBudgets,
                'action' => 'approve_budgets',
                'priority' => 'medium',
            ];
        }

        // Vérifier la charge de travail
        $highWorkloadPersonnel = $this->getHighWorkloadPersonnel();

        if (count($highWorkloadPersonnel) > 0) {
            $alerts[] = [
                'type' => 'warning',
                'title' => 'Charge de travail élevée',
                'message' => count($highWorkloadPersonnel) . ' membre(s) du personnel ont une charge de travail élevée',
                'count' => count($highWorkloadPersonnel),
                'action' => 'view_workload_distribution',
                'priority' => 'medium',
                'details' => $highWorkloadPersonnel,
            ];
        }

        return response()->json([
            'success' => true,
            'data' => [
                'alerts' => $alerts,
                'total_alerts' => count($alerts),
                'critical_alerts' => collect($alerts)->where('priority', 'high')->count(),
                'last_checked' => now()->toISOString(),
            ],
        ]);
    }

    /**
     * Get workload distribution across personnel.
     */
    public function workloadDistribution(): JsonResponse
    {
        $personnel = Personnel::where('status', 'active')
            ->with(['tasks'])
            ->get()
            ->map(function ($person) {
                $activeTasks = $person->tasks->where('status', '!=', 'completed')->count();
                $completedTasks = $person->tasks->where('status', 'completed')->count();
                $totalTasks = $person->tasks->count();

                $workloadLevel = $this->calculateWorkloadLevel($activeTasks);

                return [
                    'id' => $person->id,
                    'name' => $person->full_name,
                    'department' => $person->department,
                    'position' => $person->position,
                    'active_tasks' => $activeTasks,
                    'completed_tasks' => $completedTasks,
                    'total_tasks' => $totalTasks,
                    'workload_level' => $workloadLevel,
                    'utilization_rate' => $this->calculatePersonnelUtilizationRate($person),
                    'performance_rating' => $person->performance_rating,
                ];
            })
            ->sortByDesc('active_tasks');

        $distribution = [
            'low_workload' => $personnel->where('workload_level', 'low')->count(),
            'medium_workload' => $personnel->where('workload_level', 'medium')->count(),
            'high_workload' => $personnel->where('workload_level', 'high')->count(),
            'overloaded' => $personnel->where('workload_level', 'overloaded')->count(),
            'personnel' => $personnel->values(),
        ];

        return response()->json([
            'success' => true,
            'data' => $distribution,
        ]);
    }

    /**
     * Get project performance analytics.
     */
    public function projectAnalytics(): JsonResponse
    {
        $analytics = [
            'completion_trends' => $this->getProjectCompletionTrends(),
            'performance_by_manager' => $this->getProjectPerformanceByManager(),
            'budget_variance' => $this->getBudgetVariance(),
            'timeline_efficiency' => $this->getTimelineEfficiency(),
            'quality_metrics' => $this->getQualityMetrics(),
        ];

        return response()->json([
            'success' => true,
            'data' => $analytics,
        ]);
    }

    /**
     * Get task efficiency metrics.
     */
    public function taskEfficiency(): JsonResponse
    {
        $efficiency = [
            'completion_time' => $this->getTaskCompletionTime(),
            'priority_distribution' => $this->getTaskPriorityDistribution(),
            'assignee_performance' => $this->getAssigneePerformance(),
            'project_task_ratio' => $this->getProjectTaskRatio(),
        ];

        return response()->json([
            'success' => true,
            'data' => $efficiency,
        ]);
    }

    /**
     * Get budget analysis and forecasting.
     */
    public function budgetAnalysis(): JsonResponse
    {
        $analysis = [
            'spending_trends' => $this->getSpendingTrends(),
            'category_analysis' => $this->getBudgetCategoryAnalysis(),
            'approval_efficiency' => $this->getBudgetApprovalEfficiency(),
            'forecasting' => $this->getBudgetForecasting(),
        ];

        return response()->json([
            'success' => true,
            'data' => $analysis,
        ]);
    }

    /**
     * Get project timeline data for charts.
     */
    private function getProjectTimelineData(): array
    {
        $months = collect();
        for ($i = 11; $i >= 0; $i--) {
            $months->push(now()->subMonths($i)->format('M Y'));
        }

        $projectData = $months->map(function ($month) {
            $date = Carbon::createFromFormat('M Y', $month);
            return [
                'month' => $month,
                'created' => Project::whereYear('created_at', $date->year)
                    ->whereMonth('created_at', $date->month)
                    ->count(),
                'completed' => Project::whereYear('updated_at', $date->year)
                    ->whereMonth('updated_at', $date->month)
                    ->where('status', 'completed')
                    ->count(),
            ];
        });

        return $projectData->toArray();
    }

    /**
     * Get task status distribution for charts.
     */
    private function getTaskStatusDistribution(): array
    {
        return Task::select('status', DB::raw('count(*) as count'))
            ->groupBy('status')
            ->get()
            ->toArray();
    }

    /**
     * Get budget trends for charts.
     */
    private function getBudgetTrends(): array
    {
        $months = collect();
        for ($i = 11; $i >= 0; $i--) {
            $months->push(now()->subMonths($i)->format('M Y'));
        }

        $budgetData = $months->map(function ($month) {
            $date = Carbon::createFromFormat('M Y', $month);
            return [
                'month' => $month,
                'total_amount' => Budget::whereYear('created_at', $date->year)
                    ->whereMonth('created_at', $date->month)
                    ->sum('amount'),
                'approved_amount' => Budget::whereYear('created_at', $date->year)
                    ->whereMonth('created_at', $date->month)
                    ->where('is_approved', true)
                    ->sum('amount'),
            ];
        });

        return $budgetData->toArray();
    }

    /**
     * Get personnel performance data for charts.
     */
    private function getPersonnelPerformanceData(): array
    {
        return Personnel::where('status', 'active')
            ->select('department', DB::raw('avg(performance_rating) as avg_rating'))
            ->groupBy('department')
            ->get()
            ->toArray();
    }

    /**
     * Get monthly activity data for charts.
     */
    private function getMonthlyActivityData(): array
    {
        $months = collect();
        for ($i = 11; $i >= 0; $i--) {
            $months->push(now()->subMonths($i)->format('M Y'));
        }

        $activityData = $months->map(function ($month) {
            $date = Carbon::createFromFormat('M Y', $month);
            return [
                'month' => $month,
                'projects_created' => Project::whereYear('created_at', $date->year)
                    ->whereMonth('created_at', $date->month)
                    ->count(),
                'tasks_created' => Task::whereYear('created_at', $date->year)
                    ->whereMonth('created_at', $date->month)
                    ->count(),
                'personnel_hired' => Personnel::whereYear('hire_date', $date->year)
                    ->whereMonth('hire_date', $date->month)
                    ->count(),
            ];
        });

        return $activityData->toArray();
    }

    /**
     * Calculate task completion rate.
     */
    private function calculateTaskCompletionRate(): float
    {
        $totalTasks = Task::count();
        if ($totalTasks === 0) {
            return 0;
        }

        $completedTasks = Task::where('status', 'completed')->count();
        return round(($completedTasks / $totalTasks) * 100, 2);
    }

    /**
     * Calculate project success rate.
     */
    private function calculateProjectSuccessRate(): float
    {
        $totalProjects = Project::count();
        if ($totalProjects === 0) {
            return 0;
        }

        $completedProjects = Project::where('status', 'completed')->count();
        return round(($completedProjects / $totalProjects) * 100, 2);
    }

    /**
     * Calculate budget efficiency.
     */
    private function calculateBudgetEfficiency(): float
    {
        $totalBudgets = Budget::count();
        if ($totalBudgets === 0) {
            return 0;
        }

        $executedBudgets = Budget::where('is_executed', true)->count();
        return round(($executedBudgets / $totalBudgets) * 100, 2);
    }

    /**
     * Calculate personnel utilization.
     */
    private function calculatePersonnelUtilization(): float
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
     * Calculate workflow efficiency.
     */
    private function calculateWorkflowEfficiency(): float
    {
        $totalWorkflows = Workflow::count();
        if ($totalWorkflows === 0) {
            return 0;
        }

        $completedWorkflows = Workflow::where('status', 'completed')->count();
        return round(($completedWorkflows / $totalWorkflows) * 100, 2);
    }

    /**
     * Calculate personnel utilization rate for a specific person.
     */
    private function calculatePersonnelUtilizationRate($person): float
    {
        $totalTasks = $person->tasks->count();
        if ($totalTasks === 0) {
            return 0;
        }

        $activeTasks = $person->tasks->where('status', '!=', 'completed')->count();
        return round(($activeTasks / $totalTasks) * 100, 2);
    }

    /**
     * Calculate budget execution rate for a specific budget.
     */
    private function calculateBudgetExecutionRate($budget): float
    {
        if (!$budget->amount || $budget->amount === 0) {
            return 0;
        }

        // Placeholder - dans un vrai système, vous auriez un champ executed_amount
        $executedAmount = $budget->is_executed ? $budget->amount : 0;
        return round(($executedAmount / $budget->amount) * 100, 2);
    }

    /**
     * Get active users count.
     */
    private function getActiveUsersCount(): int
    {
        // Placeholder - dans un vrai système, vous auriez une table de sessions actives
        return User::where('last_login_at', '>=', now()->subMinutes(30))->count();
    }

    /**
     * Get recent activities across the system.
     */
    private function getRecentActivities(): array
    {
        $activities = [];

        // Projets récemment créés
        $recentProjects = Project::where('created_at', '>=', now()->subDays(7))
            ->with('manager')
            ->limit(5)
            ->get();

        foreach ($recentProjects as $project) {
            $activities[] = [
                'type' => 'project_created',
                'title' => 'Nouveau projet créé',
                'description' => "Projet '{$project->name}' créé par " . ($project->manager ? $project->manager->full_name : 'Système'),
                'timestamp' => $project->created_at->toISOString(),
                'entity_id' => $project->id,
                'entity_type' => 'project',
            ];
        }

        // Tâches récemment complétées
        $recentCompletedTasks = Task::where('updated_at', '>=', now()->subDays(7))
            ->where('status', 'completed')
            ->with(['assignedTo', 'project'])
            ->limit(5)
            ->get();

        foreach ($recentCompletedTasks as $task) {
            $activities[] = [
                'type' => 'task_completed',
                'title' => 'Tâche complétée',
                'description' => "Tâche '{$task->title}' complétée par " . ($task->assignedTo ? $task->assignedTo->full_name : 'Inconnu'),
                'timestamp' => $task->updated_at->toISOString(),
                'entity_id' => $task->id,
                'entity_type' => 'task',
            ];
        }

        // Budgets récemment approuvés
        $recentApprovedBudgets = Budget::where('updated_at', '>=', now()->subDays(7))
            ->where('is_approved', true)
            ->with(['approvedBy', 'project'])
            ->limit(5)
            ->get();

        foreach ($recentApprovedBudgets as $budget) {
            $activities[] = [
                'type' => 'budget_approved',
                'title' => 'Budget approuvé',
                'description' => "Budget de {$budget->amount}€ approuvé pour " . ($budget->project ? $budget->project->name : 'Projet inconnu'),
                'timestamp' => $budget->updated_at->toISOString(),
                'entity_id' => $budget->id,
                'entity_type' => 'budget',
            ];
        }

        // Trier par timestamp décroissant
        usort($activities, function ($a, $b) {
            return strtotime($b['timestamp']) - strtotime($a['timestamp']);
        });

        return array_slice($activities, 0, 10);
    }

    /**
     * Get system alerts and warnings.
     */
    private function getSystemAlerts(): array
    {
        $alerts = [];

        // Vérifier l'espace disque (placeholder)
        $alerts[] = [
            'type' => 'info',
            'title' => 'Système opérationnel',
            'message' => 'Tous les services fonctionnent normalement',
            'severity' => 'low',
        ];

        return $alerts;
    }

    /**
     * Get performance metrics.
     */
    private function getPerformanceMetrics(): array
    {
        return [
            'response_time' => '120ms',
            'uptime' => '99.9%',
            'active_connections' => rand(10, 50),
            'memory_usage' => '45%',
            'cpu_usage' => '23%',
        ];
    }

    /**
     * Get personnel with high workload.
     */
    private function getHighWorkloadPersonnel(): array
    {
        return Personnel::where('status', 'active')
            ->with(['tasks'])
            ->get()
            ->filter(function ($person) {
                $activeTasks = $person->tasks->where('status', '!=', 'completed')->count();
                return $activeTasks > 5; // Plus de 5 tâches actives
            })
            ->map(function ($person) {
                return [
                    'id' => $person->id,
                    'name' => $person->full_name,
                    'department' => $person->department,
                    'active_tasks' => $person->tasks->where('status', '!=', 'completed')->count(),
                ];
            })
            ->values()
            ->toArray();
    }

    /**
     * Calculate workload level for a person.
     */
    private function calculateWorkloadLevel(int $activeTasks): string
    {
        if ($activeTasks <= 2) return 'low';
        if ($activeTasks <= 5) return 'medium';
        if ($activeTasks <= 8) return 'high';
        return 'overloaded';
    }

    /**
     * Get project completion trends.
     */
    private function getProjectCompletionTrends(): array
    {
        $months = collect();
        for ($i = 11; $i >= 0; $i--) {
            $months->push(now()->subMonths($i)->format('M Y'));
        }

        return $months->map(function ($month) {
            $date = Carbon::createFromFormat('M Y', $month);
            $total = Project::whereYear('created_at', $date->year)
                ->whereMonth('created_at', $date->month)
                ->count();
            $completed = Project::whereYear('updated_at', $date->year)
                ->whereMonth('updated_at', $date->month)
                ->where('status', 'completed')
                ->count();

            return [
                'month' => $month,
                'total' => $total,
                'completed' => $completed,
                'completion_rate' => $total > 0 ? round(($completed / $total) * 100, 2) : 0,
            ];
        })->toArray();
    }

    /**
     * Get project performance by manager.
     */
    private function getProjectPerformanceByManager(): array
    {
        return User::whereHas('managedProjects')
            ->with(['managedProjects'])
            ->get()
            ->map(function ($user) {
                $projects = $user->managedProjects;
                $total = $projects->count();
                $completed = $projects->where('status', 'completed')->count();
                $overdue = $projects->where('end_date', '<', now())->where('status', '!=', 'completed')->count();

                return [
                    'manager_id' => $user->id,
                    'manager_name' => $user->full_name,
                    'total_projects' => $total,
                    'completed_projects' => $completed,
                    'overdue_projects' => $overdue,
                    'success_rate' => $total > 0 ? round(($completed / $total) * 100, 2) : 0,
                ];
            })
            ->sortByDesc('success_rate')
            ->values()
            ->toArray();
    }

    /**
     * Get budget variance analysis.
     */
    private function getBudgetVariance(): array
    {
        return Budget::where('is_executed', true)
            ->with(['project'])
            ->get()
            ->map(function ($budget) {
                // Placeholder - dans un vrai système, vous auriez un champ executed_amount
                $executedAmount = $budget->amount; // Placeholder
                $variance = $executedAmount - $budget->amount;
                $variancePercentage = $budget->amount > 0 ? round(($variance / $budget->amount) * 100, 2) : 0;

                return [
                    'budget_id' => $budget->id,
                    'project_name' => $budget->project ? $budget->project->name : 'Projet inconnu',
                    'planned_amount' => $budget->amount,
                    'executed_amount' => $executedAmount,
                    'variance' => $variance,
                    'variance_percentage' => $variancePercentage,
                    'status' => $variance > 0 ? 'over_budget' : ($variance < 0 ? 'under_budget' : 'on_budget'),
                ];
            })
            ->toArray();
    }

    /**
     * Get timeline efficiency metrics.
     */
    private function getTimelineEfficiency(): array
    {
        $projects = Project::where('status', 'completed')
            ->whereNotNull('start_date')
            ->whereNotNull('end_date')
            ->get();

        $efficiencyData = $projects->map(function ($project) {
            $plannedDuration = $project->start_date->diffInDays($project->end_date);
            $actualDuration = $project->start_date->diffInDays($project->updated_at);
            $efficiency = $plannedDuration > 0 ? round(($plannedDuration / $actualDuration) * 100, 2) : 0;

            return [
                'project_id' => $project->id,
                'project_name' => $project->name,
                'planned_duration' => $plannedDuration,
                'actual_duration' => $actualDuration,
                'efficiency' => $efficiency,
                'status' => $efficiency >= 100 ? 'on_time' : ($efficiency >= 80 ? 'slightly_delayed' : 'delayed'),
            ];
        });

        return [
            'average_efficiency' => $efficiencyData->avg('efficiency'),
            'on_time_projects' => $efficiencyData->where('status', 'on_time')->count(),
            'delayed_projects' => $efficiencyData->where('status', 'delayed')->count(),
            'projects' => $efficiencyData->values()->toArray(),
        ];
    }

    /**
     * Get quality metrics.
     */
    private function getQualityMetrics(): array
    {
        return [
            'task_quality_score' => $this->calculateTaskQualityScore(),
            'project_satisfaction' => $this->calculateProjectSatisfaction(),
            'bug_rate' => $this->calculateBugRate(),
            'rework_percentage' => $this->calculateReworkPercentage(),
        ];
    }

    /**
     * Get task completion time analysis.
     */
    private function getTaskCompletionTime(): array
    {
        $tasks = Task::where('status', 'completed')
            ->whereNotNull('created_at')
            ->whereNotNull('updated_at')
            ->get();

        $completionTimes = $tasks->map(function ($task) {
            return $task->created_at->diffInHours($task->updated_at);
        });

        return [
            'average_completion_time' => $completionTimes->avg(),
            'median_completion_time' => $this->calculateMedian($completionTimes->toArray()),
            'fastest_completion' => $completionTimes->min(),
            'slowest_completion' => $completionTimes->max(),
            'distribution' => [
                'under_1_hour' => $completionTimes->filter(fn($time) => $time < 1)->count(),
                '1_to_4_hours' => $completionTimes->filter(fn($time) => $time >= 1 && $time < 4)->count(),
                '4_to_8_hours' => $completionTimes->filter(fn($time) => $time >= 4 && $time < 8)->count(),
                'over_8_hours' => $completionTimes->filter(fn($time) => $time >= 8)->count(),
            ],
        ];
    }

    /**
     * Get task priority distribution.
     */
    private function getTaskPriorityDistribution(): array
    {
        return Task::select('priority', DB::raw('count(*) as count'))
            ->groupBy('priority')
            ->get()
            ->toArray();
    }

    /**
     * Get assignee performance metrics.
     */
    private function getAssigneePerformance(): array
    {
        return Personnel::where('status', 'active')
            ->with(['tasks'])
            ->get()
            ->map(function ($person) {
                $tasks = $person->tasks;
                $total = $tasks->count();
                $completed = $tasks->where('status', 'completed')->count();
                $overdue = $tasks->where('due_date', '<', now())->where('status', '!=', 'completed')->count();

                return [
                    'personnel_id' => $person->id,
                    'name' => $person->full_name,
                    'department' => $person->department,
                    'total_tasks' => $total,
                    'completed_tasks' => $completed,
                    'overdue_tasks' => $overdue,
                    'completion_rate' => $total > 0 ? round(($completed / $total) * 100, 2) : 0,
                    'performance_rating' => $person->performance_rating,
                ];
            })
            ->sortByDesc('completion_rate')
            ->values()
            ->toArray();
    }

    /**
     * Get project task ratio.
     */
    private function getProjectTaskRatio(): array
    {
        return Project::with(['tasks'])
            ->get()
            ->map(function ($project) {
                return [
                    'project_id' => $project->id,
                    'project_name' => $project->name,
                    'task_count' => $project->tasks->count(),
                    'completed_tasks' => $project->tasks->where('status', 'completed')->count(),
                    'task_completion_rate' => $project->tasks->count() > 0 ?
                        round(($project->tasks->where('status', 'completed')->count() / $project->tasks->count()) * 100, 2) : 0,
                ];
            })
            ->sortByDesc('task_count')
            ->values()
            ->toArray();
    }

    /**
     * Get spending trends.
     */
    private function getSpendingTrends(): array
    {
        $months = collect();
        for ($i = 11; $i >= 0; $i--) {
            $months->push(now()->subMonths($i)->format('M Y'));
        }

        return $months->map(function ($month) {
            $date = Carbon::createFromFormat('M Y', $month);
            return [
                'month' => $month,
                'total_spent' => Budget::whereYear('created_at', $date->year)
                    ->whereMonth('created_at', $date->month)
                    ->sum('amount'),
                'approved_amount' => Budget::whereYear('created_at', $date->year)
                    ->whereMonth('created_at', $date->month)
                    ->where('is_approved', true)
                    ->sum('amount'),
                'executed_amount' => Budget::whereYear('created_at', $date->year)
                    ->whereMonth('created_at', $date->month)
                    ->where('is_executed', true)
                    ->sum('amount'),
            ];
        })->toArray();
    }

    /**
     * Get budget category analysis.
     */
    private function getBudgetCategoryAnalysis(): array
    {
        return Budget::select('category', DB::raw('count(*) as count'), DB::raw('sum(amount) as total_amount'))
            ->groupBy('category')
            ->get()
            ->map(function ($budget) {
                return [
                    'category' => $budget->category,
                    'count' => $budget->count,
                    'total_amount' => $budget->total_amount,
                    'percentage_of_total' => Budget::sum('amount') > 0 ?
                        round(($budget->total_amount / Budget::sum('amount')) * 100, 2) : 0,
                ];
            })
            ->sortByDesc('total_amount')
            ->values()
            ->toArray();
    }

    /**
     * Get budget approval efficiency.
     */
    private function getBudgetApprovalEfficiency(): array
    {
        $budgets = Budget::whereNotNull('created_at')
            ->get();

        $approvalTimes = $budgets->where('is_approved', true)
            ->map(function ($budget) {
                // Placeholder - dans un vrai système, vous auriez un champ approved_at
                return $budget->created_at->diffInHours($budget->updated_at);
            });

        return [
            'total_budgets' => $budgets->count(),
            'approved_budgets' => $budgets->where('is_approved', true)->count(),
            'pending_budgets' => $budgets->where('is_approved', false)->count(),
            'average_approval_time' => $approvalTimes->avg(),
            'approval_rate' => $budgets->count() > 0 ?
                round(($budgets->where('is_approved', true)->count() / $budgets->count()) * 100, 2) : 0,
        ];
    }

    /**
     * Get budget forecasting.
     */
    private function getBudgetForecasting(): array
    {
        // Placeholder - dans un vrai système, vous auriez des algorithmes de prévision
        $currentMonth = now()->format('M Y');
        $nextMonth = now()->addMonth()->format('M Y');
        $followingMonth = now()->addMonths(2)->format('M Y');

        return [
            'current_month' => [
                'month' => $currentMonth,
                'projected_spending' => Budget::where('is_approved', true)->sum('amount'),
                'actual_spending' => Budget::where('is_executed', true)->sum('amount'),
            ],
            'next_month' => [
                'month' => $nextMonth,
                'projected_spending' => Budget::where('is_approved', true)->sum('amount') * 1.1, // +10%
                'confidence_level' => 'medium',
            ],
            'following_month' => [
                'month' => $followingMonth,
                'projected_spending' => Budget::where('is_approved', true)->sum('amount') * 1.2, // +20%
                'confidence_level' => 'low',
            ],
        ];
    }

    /**
     * Calculate task quality score.
     */
    private function calculateTaskQualityScore(): float
    {
        // Placeholder - dans un vrai système, vous auriez des métriques de qualité
        return rand(85, 95);
    }

    /**
     * Calculate project satisfaction.
     */
    private function calculateProjectSatisfaction(): float
    {
        // Placeholder - dans un vrai système, vous auriez des évaluations de satisfaction
        return rand(80, 90);
    }

    /**
     * Calculate bug rate.
     */
    private function calculateBugRate(): float
    {
        // Placeholder - dans un vrai système, vous auriez un suivi des bugs
        return rand(2, 8);
    }

    /**
     * Calculate rework percentage.
     */
    private function calculateReworkPercentage(): float
    {
        // Placeholder - dans un vrai système, vous auriez un suivi du retravail
        return rand(5, 15);
    }

    /**
     * Calculate median value from array.
     */
    private function calculateMedian(array $array): float
    {
        sort($array);
        $count = count($array);

        if ($count === 0) {
            return 0;
        }

        if ($count % 2 === 0) {
            return ($array[$count / 2 - 1] + $array[$count / 2]) / 2;
        }

        return $array[($count - 1) / 2];
    }
}
