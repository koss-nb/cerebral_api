<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Project;
use App\Models\Task;
use App\Models\Budget;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    /**
     * Get dashboard overview report.
     */
    public function dashboard(Request $request): JsonResponse
    {
        $user = $request->user();

        $stats = [
            'projects' => [
                'total' => Project::count(),
                'active' => Project::where('status', 'active')->count(),
                'completed' => Project::where('status', 'completed')->count(),
                'overdue' => Project::where('end_date', '<', now())
                    ->where('status', '!=', 'completed')
                    ->count(),
            ],
            'tasks' => [
                'total' => Task::count(),
                'pending' => Task::where('status', 'pending')->count(),
                'in_progress' => Task::where('status', 'in_progress')->count(),
                'completed' => Task::where('status', 'completed')->count(),
                'overdue' => Task::where('due_date', '<', now())
                    ->where('status', '!=', 'completed')
                    ->count(),
            ],
            'budget' => [
                'total_income' => Budget::where('type', 'income')->sum('amount'),
                'total_expenses' => Budget::where('type', 'expense')->sum('amount'),
                'net_budget' => Budget::where('type', 'income')->sum('amount') -
                    Budget::where('type', 'expense')->sum('amount'),
            ],
            'users' => [
                'total' => User::count(),
                'active' => User::where('is_active', true)->count(),
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    /**
     * Get project performance report.
     */
    public function projectPerformance(Request $request): JsonResponse
    {
        $query = Project::with(['manager', 'tasks']);

        if ($request->has('date_from')) {
            $query->where('start_date', '>=', $request->date_from);
        }

        if ($request->has('date_to')) {
            $query->where('end_date', '<=', $request->date_to);
        }

        $projects = $query->get()->map(function ($project) {
            $totalTasks = $project->tasks->count();
            $completedTasks = $project->tasks->where('status', 'completed')->count();

            return [
                'id' => $project->id,
                'name' => $project->name,
                'manager' => $project->manager->full_name,
                'start_date' => $project->start_date,
                'end_date' => $project->end_date,
                'progress' => $project->progress,
                'total_tasks' => $totalTasks,
                'completed_tasks' => $completedTasks,
                'completion_rate' => $totalTasks > 0 ? ($completedTasks / $totalTasks) * 100 : 0,
                'is_overdue' => $project->is_overdue,
                'budget_utilization' => $project->budget ?
                    ($project->budgets->sum('amount') / $project->budget) * 100 : 0,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $projects,
        ]);
    }

    /**
     * Get task efficiency report.
     */
    public function taskEfficiency(Request $request): JsonResponse
    {
        $query = Task::with(['project', 'assignedTo']);

        if ($request->has('project_id')) {
            $query->where('project_id', $request->project_id);
        }

        if ($request->has('date_from')) {
            $query->where('created_at', '>=', $request->date_from);
        }

        $tasks = $query->get()->map(function ($task) {
            $efficiency = 0;
            if ($task->estimated_hours && $task->actual_hours) {
                $efficiency = (($task->estimated_hours - $task->actual_hours) / $task->estimated_hours) * 100;
            }

            return [
                'id' => $task->id,
                'title' => $task->title,
                'project' => $task->project->name,
                'assigned_to' => $task->assignedTo?->full_name ?? 'Non assigné',
                'status' => $task->status,
                'priority' => $task->priority,
                'estimated_hours' => $task->estimated_hours,
                'actual_hours' => $task->actual_hours,
                'efficiency' => round($efficiency, 2),
                'due_date' => $task->due_date,
                'is_overdue' => $task->due_date && now()->isAfter($task->due_date) && $task->status !== 'completed',
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $tasks,
        ]);
    }

    /**
     * Get budget analysis report.
     */
    public function budgetAnalysis(Request $request): JsonResponse
    {
        $query = Budget::with(['project']);

        if ($request->has('project_id')) {
            $query->where('project_id', $request->project_id);
        }

        if ($request->has('date_from')) {
            $query->where('date', '>=', $request->date_from);
        }

        if ($request->has('date_to')) {
            $query->where('date', '<=', $request->date_to);
        }

        $budgets = $query->get();

        $analysis = [
            'summary' => [
                'total_income' => $budgets->where('type', 'income')->sum('amount'),
                'total_expenses' => $budgets->where('type', 'expense')->sum('amount'),
                'net_budget' => $budgets->where('type', 'income')->sum('amount') -
                    $budgets->where('type', 'expense')->sum('amount'),
                'total_transactions' => $budgets->count(),
            ],
            'by_category' => $budgets->groupBy('category')->map(function ($categoryBudgets) {
                return [
                    'income' => $categoryBudgets->where('type', 'income')->sum('amount'),
                    'expenses' => $categoryBudgets->where('type', 'expense')->sum('amount'),
                    'net' => $categoryBudgets->where('type', 'income')->sum('amount') -
                        $categoryBudgets->where('type', 'expense')->sum('amount'),
                ];
            }),
            'by_month' => $budgets->groupBy(function ($budget) {
                return $budget->date->format('Y-m');
            })->map(function ($monthBudgets) {
                return [
                    'income' => $monthBudgets->where('type', 'income')->sum('amount'),
                    'expenses' => $monthBudgets->where('type', 'expense')->sum('amount'),
                    'net' => $monthBudgets->where('type', 'income')->sum('amount') -
                        $monthBudgets->where('type', 'expense')->sum('amount'),
                ];
            }),
        ];

        return response()->json([
            'success' => true,
            'data' => $analysis,
        ]);
    }

    /**
     * Get user productivity report.
     */
    public function userProductivity(Request $request): JsonResponse
    {
        $users = User::with(['assignedTasks', 'createdTasks'])->get()->map(function ($user) {
            $assignedTasks = $user->assignedTasks;
            $totalTasks = $assignedTasks->count();
            $completedTasks = $assignedTasks->where('status', 'completed')->count();
            $overdueTasks = $assignedTasks->where('due_date', '<', now())
                ->where('status', '!=', 'completed')
                ->count();

            return [
                'id' => $user->id,
                'name' => $user->full_name,
                'role' => $user->role,
                'department' => $user->department,
                'total_tasks' => $totalTasks,
                'completed_tasks' => $completedTasks,
                'completion_rate' => $totalTasks > 0 ? ($completedTasks / $totalTasks) * 100 : 0,
                'overdue_tasks' => $overdueTasks,
                'productivity_score' => $totalTasks > 0 ?
                    (($completedTasks - $overdueTasks) / $totalTasks) * 100 : 0,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $users,
        ]);
    }

    /**
     * Export report data.
     */
    public function export(Request $request): JsonResponse
    {
        $reportType = $request->get('type', 'dashboard');
        $format = $request->get('format', 'json');

        $data = match ($reportType) {
            'dashboard' => $this->getDashboardData(),
            'project_performance' => $this->getProjectPerformanceData($request),
            'task_efficiency' => $this->getTaskEfficiencyData($request),
            'budget_analysis' => $this->getBudgetAnalysisData($request),
            'user_productivity' => $this->getUserProductivityData($request),
            default => throw new \InvalidArgumentException('Invalid report type'),
        };

        return response()->json([
            'success' => true,
            'data' => $data,
            'export_info' => [
                'type' => $reportType,
                'format' => $format,
                'export_date' => now()->toISOString(),
                'filters' => $request->except(['type', 'format']),
            ],
        ]);
    }

    private function getDashboardData()
    {
        return [
            'total_projects' => Project::count(),
            'total_tasks' => Task::count(),
            'total_users' => User::count(),
            'total_budget' => Budget::sum('amount'),
        ];
    }

    private function getProjectPerformanceData(Request $request)
    {
        $query = Project::with(['manager']);
        if ($request->has('date_from')) {
            $query->where('start_date', '>=', $request->date_from);
        }
        return $query->get();
    }

    private function getTaskEfficiencyData(Request $request)
    {
        $query = Task::with(['project', 'assignedTo']);
        if ($request->has('project_id')) {
            $query->where('project_id', $request->project_id);
        }
        return $query->get();
    }

    private function getBudgetAnalysisData(Request $request)
    {
        $query = Budget::with(['project']);
        if ($request->has('project_id')) {
            $query->where('project_id', $request->project_id);
        }
        return $query->get();
    }

    private function getUserProductivityData(Request $request)
    {
        return User::with(['assignedTasks'])->get();
    }
}
