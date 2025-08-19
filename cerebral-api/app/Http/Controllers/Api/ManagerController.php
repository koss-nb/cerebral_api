<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use App\Models\Project;
use App\Models\User;
use App\Models\Personnel;
use App\Models\Budget;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ManagerController extends Controller
{
    /**
     * Dashboard spécifique manager
     */
    public function dashboard(): JsonResponse
    {
        $user = Auth::user();

        // Équipe du manager
        $teamMembers = Personnel::where('manager_id', $user->id)
            ->with(['user', 'department'])
            ->get();

        // Projets gérés par le manager
        $managedProjects = Project::where('manager_id', $user->id)
            ->with(['tasks', 'manager', 'client'])
            ->get();

        // Tâches de l'équipe
        $teamTasks = Task::whereIn('assigned_to', $teamMembers->pluck('user_id'))
            ->with(['project', 'assignedTo', 'createdBy'])
            ->get();

        // Statistiques de l'équipe
        $teamStats = [
            'total_members' => $teamMembers->count(),
            'active_members' => $teamMembers->where('is_active', true)->count(),
            'total_projects' => $managedProjects->count(),
            'active_projects' => $managedProjects->where('status', 'active')->count(),
            'total_tasks' => $teamTasks->count(),
            'completed_tasks' => $teamTasks->where('status', 'completed')->count(),
            'pending_tasks' => $teamTasks->whereIn('status', ['pending', 'in_progress'])->count(),
        ];

        // Budgets gérés
        $managedBudgets = Budget::whereIn('project_id', $managedProjects->pluck('id'))
            ->get();

        $budgetStats = [
            'total_budget' => $managedBudgets->sum('amount'),
            'spent_budget' => $managedBudgets->sum('spent'),
            'remaining_budget' => $managedBudgets->sum('amount') - $managedBudgets->sum('spent'),
        ];

        return response()->json([
            'success' => true,
            'data' => [
                'team_stats' => $teamStats,
                'budget_stats' => $budgetStats,
                'team_members' => $teamMembers,
                'managed_projects' => $managedProjects,
                'team_tasks' => $teamTasks,
            ]
        ]);
    }

    /**
     * Équipe du manager
     */
    public function myTeam(): JsonResponse
    {
        $user = Auth::user();

        $teamMembers = Personnel::where('manager_id', $user->id)
            ->with(['user', 'department', 'skills'])
            ->get();

        // Ajouter les statistiques de performance pour chaque membre
        $teamWithStats = $teamMembers->map(function ($member) {
            $memberStats = [
                'tasks_completed_this_month' => Task::where('assigned_to', $member->user_id)
                    ->where('status', 'completed')
                    ->whereMonth('completed_at', Carbon::now()->month)
                    ->count(),

                'tasks_in_progress' => Task::where('assigned_to', $member->user_id)
                    ->whereIn('status', ['pending', 'in_progress'])
                    ->count(),

                'performance_score' => $this->calculateMemberPerformance($member->user_id),
            ];

            $member->performance_stats = $memberStats;
            return $member;
        });

        return response()->json([
            'success' => true,
            'data' => $teamWithStats
        ]);
    }

    /**
     * Projets gérés par le manager
     */
    public function myManagedProjects(): JsonResponse
    {
        $user = Auth::user();

        $projects = Project::where('manager_id', $user->id)
            ->with(['tasks', 'manager', 'client', 'budget'])
            ->orderBy('created_at', 'desc')
            ->get();

        // Ajouter les statistiques pour chaque projet
        $projectsWithStats = $projects->map(function ($project) {
            $projectStats = [
                'total_tasks' => $project->tasks->count(),
                'completed_tasks' => $project->tasks->where('status', 'completed')->count(),
                'progress_percentage' => $project->tasks->count() > 0
                    ? round(($project->tasks->where('status', 'completed')->count() / $project->tasks->count()) * 100, 2)
                    : 0,
                'overdue_tasks' => $project->tasks->where('due_date', '<', Carbon::now())
                    ->whereNotIn('status', ['completed', 'cancelled'])
                    ->count(),
            ];

            $project->stats = $projectStats;
            return $project;
        });

        return response()->json([
            'success' => true,
            'data' => $projectsWithStats
        ]);
    }

    /**
     * Budgets gérés par le manager
     */
    public function myBudgets(): JsonResponse
    {
        $user = Auth::user();

        $budgets = Budget::whereIn('project_id', function ($query) use ($user) {
            $query->select('id')
                ->from('projects')
                ->where('manager_id', $user->id);
        })->with(['project'])->get();

        return response()->json([
            'success' => true,
            'data' => $budgets
        ]);
    }

    /**
     * Performance de l'équipe
     */
    public function teamPerformance(): JsonResponse
    {
        $user = Auth::user();
        $startOfMonth = Carbon::now()->startOfMonth();
        $endOfMonth = Carbon::now()->endOfMonth();

        // Récupérer l'équipe
        $teamMembers = Personnel::where('manager_id', $user->id)
            ->with('user')
            ->get();

        $teamMemberIds = $teamMembers->pluck('user_id');

        // Statistiques de performance de l'équipe
        $teamPerformance = [
            'total_tasks_assigned' => Task::whereIn('assigned_to', $teamMemberIds)
                ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
                ->count(),

            'total_tasks_completed' => Task::whereIn('assigned_to', $teamMemberIds)
                ->where('status', 'completed')
                ->whereBetween('completed_at', [$startOfMonth, $endOfMonth])
                ->count(),

            'tasks_on_time' => Task::whereIn('assigned_to', $teamMemberIds)
                ->where('status', 'completed')
                ->where('completed_at', '<=', DB::raw('due_date'))
                ->whereBetween('completed_at', [$startOfMonth, $endOfMonth])
                ->count(),

            'tasks_late' => Task::whereIn('assigned_to', $teamMemberIds)
                ->where('status', 'completed')
                ->where('completed_at', '>', DB::raw('due_date'))
                ->whereBetween('completed_at', [$startOfMonth, $endOfMonth])
                ->count(),
        ];

        // Calculer les taux
        $teamPerformance['completion_rate'] = $teamPerformance['total_tasks_assigned'] > 0
            ? round(($teamPerformance['total_tasks_completed'] / $teamPerformance['total_tasks_assigned']) * 100, 2)
            : 0;

        $teamPerformance['on_time_rate'] = $teamPerformance['total_tasks_completed'] > 0
            ? round(($teamPerformance['tasks_on_time'] / $teamPerformance['total_tasks_completed']) * 100, 2)
            : 0;

        // Performance par membre
        $memberPerformance = $teamMembers->map(function ($member) use ($startOfMonth, $endOfMonth) {
            $memberTasks = Task::where('assigned_to', $member->user_id)
                ->whereBetween('created_at', [$startOfMonth, $endOfMonth]);

            $completedTasks = Task::where('assigned_to', $member->user_id)
                ->where('status', 'completed')
                ->whereBetween('completed_at', [$startOfMonth, $endOfMonth]);

            return [
                'member_id' => $member->id,
                'member_name' => $member->user->first_name . ' ' . $member->user->last_name,
                'total_tasks' => $memberTasks->count(),
                'completed_tasks' => $completedTasks->count(),
                'completion_rate' => $memberTasks->count() > 0
                    ? round(($completedTasks->count() / $memberTasks->count()) * 100, 2)
                    : 0,
                'performance_score' => $this->calculateMemberPerformance($member->user_id),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => [
                'team_performance' => $teamPerformance,
                'member_performance' => $memberPerformance,
            ]
        ]);
    }

    /**
     * Tâches de l'équipe
     */
    public function teamTasks(Request $request): JsonResponse
    {
        $user = Auth::user();
        $perPage = $request->get('per_page', 15);

        // Récupérer l'équipe
        $teamMembers = Personnel::where('manager_id', $user->id)
            ->pluck('user_id');

        $tasks = Task::whereIn('assigned_to', $teamMembers)
            ->with(['project', 'assignedTo', 'createdBy'])
            ->orderBy('priority', 'desc')
            ->orderBy('due_date', 'asc')
            ->paginate($perPage);

        return response()->json([
            'success' => true,
            'data' => $tasks
        ]);
    }

    /**
     * Rapports d'équipe
     */
    public function teamReports(): JsonResponse
    {
        $user = Auth::user();
        $startOfMonth = Carbon::now()->startOfMonth();
        $endOfMonth = Carbon::now()->endOfMonth();

        // Récupérer l'équipe
        $teamMembers = Personnel::where('manager_id', $user->id)
            ->with('user')
            ->get();

        $teamMemberIds = $teamMembers->pluck('user_id');

        // Rapport de productivité
        $productivityReport = [
            'period' => [
                'start' => $startOfMonth->format('Y-m-d'),
                'end' => $endOfMonth->format('Y-m-d'),
            ],
            'team_size' => $teamMembers->count(),
            'tasks_metrics' => [
                'assigned' => Task::whereIn('assigned_to', $teamMemberIds)
                    ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
                    ->count(),
                'completed' => Task::whereIn('assigned_to', $teamMemberIds)
                    ->where('status', 'completed')
                    ->whereBetween('completed_at', [$startOfMonth, $endOfMonth])
                    ->count(),
                'overdue' => Task::whereIn('assigned_to', $teamMemberIds)
                    ->where('due_date', '<', Carbon::now())
                    ->whereNotIn('status', ['completed', 'cancelled'])
                    ->count(),
            ],
            'performance_metrics' => [
                'average_completion_time' => $this->calculateAverageCompletionTime($teamMemberIds, $startOfMonth, $endOfMonth),
                'quality_score' => $this->calculateTeamQualityScore($teamMemberIds, $startOfMonth, $endOfMonth),
            ],
        ];

        // Rapport de charge de travail
        $workloadReport = $teamMembers->map(function ($member) use ($startOfMonth, $endOfMonth) {
            $assignedTasks = Task::where('assigned_to', $member->user_id)
                ->whereBetween('created_at', [$startOfMonth, $endOfMonth]);

            $completedTasks = Task::where('assigned_to', $member->user_id)
                ->where('status', 'completed')
                ->whereBetween('completed_at', [$startOfMonth, $endOfMonth]);

            return [
                'member_id' => $member->id,
                'member_name' => $member->user->first_name . ' ' . $member->user->last_name,
                'assigned_tasks' => $assignedTasks->count(),
                'completed_tasks' => $completedTasks->count(),
                'pending_tasks' => $assignedTasks->whereIn('status', ['pending', 'in_progress'])->count(),
                'workload_percentage' => $this->calculateWorkloadPercentage($member->user_id),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => [
                'productivity_report' => $productivityReport,
                'workload_report' => $workloadReport,
            ]
        ]);
    }

    /**
     * Assigner une tâche à l'équipe
     */
    public function assignTask(Request $request): JsonResponse
    {
        $user = Auth::user();

        $request->validate([
            'task_id' => 'required|exists:tasks,id',
            'assigned_to' => 'required|exists:users,id',
            'assignment_notes' => 'nullable|string',
        ]);

        // Vérifier que l'utilisateur assigné fait partie de l'équipe
        $isTeamMember = Personnel::where('manager_id', $user->id)
            ->where('user_id', $request->assigned_to)
            ->exists();

        if (!$isTeamMember) {
            return response()->json([
                'success' => false,
                'message' => 'L\'utilisateur n\'appartient pas à votre équipe'
            ], 403);
        }

        $task = Task::find($request->task_id);
        $task->update([
            'assigned_to' => $request->assigned_to,
            'assigned_by' => $user->id,
            'assignment_notes' => $request->assignment_notes,
            'assigned_at' => Carbon::now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Tâche assignée avec succès',
            'data' => $task->load(['project', 'assignedTo', 'createdBy'])
        ]);
    }

    /**
     * Réassigner une tâche
     */
    public function reassignTask(Request $request): JsonResponse
    {
        $user = Auth::user();

        $request->validate([
            'task_id' => 'required|exists:tasks,id',
            'new_assigned_to' => 'required|exists:users,id',
            'reassignment_reason' => 'required|string',
        ]);

        // Vérifier que le nouvel utilisateur fait partie de l'équipe
        $isTeamMember = Personnel::where('manager_id', $user->id)
            ->where('user_id', $request->new_assigned_to)
            ->exists();

        if (!$isTeamMember) {
            return response()->json([
                'success' => false,
                'message' => 'L\'utilisateur n\'appartient pas à votre équipe'
            ], 403);
        }

        $task = Task::find($request->task_id);
        $task->update([
            'assigned_to' => $request->new_assigned_to,
            'assigned_by' => $user->id,
            'assignment_notes' => $task->assignment_notes . "\n\nRéassignation: " . $request->reassignment_reason,
            'assigned_at' => Carbon::now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Tâche réassignée avec succès',
            'data' => $task->load(['project', 'assignedTo', 'createdBy'])
        ]);
    }

    /**
     * Charge de travail de l'équipe
     */
    public function teamWorkload(): JsonResponse
    {
        $user = Auth::user();

        $teamMembers = Personnel::where('manager_id', $user->id)
            ->with('user')
            ->get();

        $workloadData = $teamMembers->map(function ($member) {
            $pendingTasks = Task::where('assigned_to', $member->user_id)
                ->whereIn('status', ['pending', 'in_progress'])
                ->count();

            $urgentTasks = Task::where('assigned_to', $member->user_id)
                ->where('priority', 'high')
                ->whereIn('status', ['pending', 'in_progress'])
                ->count();

            $overdueTasks = Task::where('assigned_to', $member->user_id)
                ->where('due_date', '<', Carbon::now())
                ->whereNotIn('status', ['completed', 'cancelled'])
                ->count();

            return [
                'member_id' => $member->id,
                'member_name' => $member->user->first_name . ' ' . $member->user->last_name,
                'pending_tasks' => $pendingTasks,
                'urgent_tasks' => $urgentTasks,
                'overdue_tasks' => $overdueTasks,
                'workload_level' => $this->calculateWorkloadLevel($pendingTasks, $urgentTasks, $overdueTasks),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $workloadData
        ]);
    }

    /**
     * Approuver une tâche
     */
    public function approveTask(Request $request, Task $task): JsonResponse
    {
        $user = Auth::user();

        // Vérifier que la tâche appartient à un projet géré par le manager
        $isManagedProject = Project::where('id', $task->project_id)
            ->where('manager_id', $user->id)
            ->exists();

        if (!$isManagedProject) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à approuver cette tâche'
            ], 403);
        }

        $request->validate([
            'approval_notes' => 'nullable|string',
            'quality_score' => 'nullable|integer|min:1|max:10',
        ]);

        $task->update([
            'status' => 'approved',
            'approved_by' => $user->id,
            'approved_at' => Carbon::now(),
            'approval_notes' => $request->approval_notes,
            'quality_score' => $request->quality_score,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Tâche approuvée',
            'data' => $task->load(['project', 'assignedTo', 'createdBy'])
        ]);
    }

    /**
     * Approuver un budget
     */
    public function approveBudget(Request $request, Budget $budget): JsonResponse
    {
        $user = Auth::user();

        // Vérifier que le budget appartient à un projet géré par le manager
        $isManagedProject = Project::where('id', $budget->project_id)
            ->where('manager_id', $user->id)
            ->exists();

        if (!$isManagedProject) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à approuver ce budget'
            ], 403);
        }

        $request->validate([
            'approval_notes' => 'nullable|string',
        ]);

        $budget->update([
            'status' => 'approved',
            'approved_by' => $user->id,
            'approved_at' => Carbon::now(),
            'approval_notes' => $request->approval_notes,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Budget approuvé',
            'data' => $budget->load('project')
        ]);
    }

    /**
     * Approuver une feuille de temps
     */
    public function approveTimesheet(Request $request): JsonResponse
    {
        $user = Auth::user();

        $request->validate([
            'user_id' => 'required|exists:users,id',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after:start_date',
            'approval_notes' => 'nullable|string',
        ]);

        // Vérifier que l'utilisateur fait partie de l'équipe
        $isTeamMember = Personnel::where('manager_id', $user->id)
            ->where('user_id', $request->user_id)
            ->exists();

        if (!$isTeamMember) {
            return response()->json([
                'success' => false,
                'message' => 'L\'utilisateur n\'appartient pas à votre équipe'
            ], 403);
        }

        // Marquer les entrées de temps comme approuvées
        $approvedEntries = DB::table('time_tracking')
            ->where('user_id', $request->user_id)
            ->whereBetween('clock_in', [$request->start_date, $request->end_date])
            ->update([
                'approved_by' => $user->id,
                'approved_at' => Carbon::now(),
                'approval_notes' => $request->approval_notes,
            ]);

        return response()->json([
            'success' => true,
            'message' => 'Feuille de temps approuvée',
            'data' => [
                'approved_entries' => $approvedEntries,
                'period' => [
                    'start_date' => $request->start_date,
                    'end_date' => $request->end_date,
                ]
            ]
        ]);
    }

    /**
     * Rapport de productivité
     */
    public function productivityReport(Request $request): JsonResponse
    {
        $user = Auth::user();
        $startDate = $request->get('start_date', Carbon::now()->startOfMonth());
        $endDate = $request->get('end_date', Carbon::now()->endOfMonth());

        // Récupérer l'équipe
        $teamMembers = Personnel::where('manager_id', $user->id)
            ->pluck('user_id');

        $productivityData = [
            'period' => [
                'start_date' => $startDate,
                'end_date' => $endDate,
            ],
            'team_performance' => [
                'total_tasks' => Task::whereIn('assigned_to', $teamMembers)
                    ->whereBetween('created_at', [$startDate, $endDate])
                    ->count(),
                'completed_tasks' => Task::whereIn('assigned_to', $teamMembers)
                    ->where('status', 'completed')
                    ->whereBetween('completed_at', [$startDate, $endDate])
                    ->count(),
                'average_completion_time' => $this->calculateAverageCompletionTime($teamMembers, $startDate, $endDate),
                'quality_score' => $this->calculateTeamQualityScore($teamMembers, $startDate, $endDate),
            ],
            'member_breakdown' => $this->getMemberProductivityBreakdown($teamMembers, $startDate, $endDate),
        ];

        return response()->json([
            'success' => true,
            'data' => $productivityData
        ]);
    }

    /**
     * Rapport de variance budgétaire
     */
    public function budgetVarianceReport(): JsonResponse
    {
        $user = Auth::user();

        $managedProjects = Project::where('manager_id', $user->id)
            ->with('budget')
            ->get();

        $varianceData = $managedProjects->map(function ($project) {
            $budget = $project->budget;
            if (!$budget) return null;

            $variance = $budget->amount - $budget->spent;
            $variancePercentage = $budget->amount > 0 ? ($variance / $budget->amount) * 100 : 0;

            return [
                'project_id' => $project->id,
                'project_name' => $project->name,
                'budgeted_amount' => $budget->amount,
                'spent_amount' => $budget->spent,
                'variance' => $variance,
                'variance_percentage' => round($variancePercentage, 2),
                'status' => $variance >= 0 ? 'under_budget' : 'over_budget',
            ];
        })->filter();

        return response()->json([
            'success' => true,
            'data' => $varianceData
        ]);
    }

    /**
     * Rapport de timeline
     */
    public function timelineReport(): JsonResponse
    {
        $user = Auth::user();

        $managedProjects = Project::where('manager_id', $user->id)
            ->with(['tasks' => function ($query) {
                $query->orderBy('due_date', 'asc');
            }])
            ->get();

        $timelineData = $managedProjects->map(function ($project) {
            $tasks = $project->tasks;
            $onTimeTasks = $tasks->where('status', 'completed')
                ->filter(function ($task) {
                    return $task->completed_at <= $task->due_date;
                });

            $delayedTasks = $tasks->where('status', 'completed')
                ->filter(function ($task) {
                    return $task->completed_at > $task->due_date;
                });

            return [
                'project_id' => $project->id,
                'project_name' => $project->name,
                'start_date' => $project->start_date,
                'end_date' => $project->end_date,
                'total_tasks' => $tasks->count(),
                'completed_tasks' => $tasks->where('status', 'completed')->count(),
                'on_time_tasks' => $onTimeTasks->count(),
                'delayed_tasks' => $delayedTasks->count(),
                'timeline_performance' => $tasks->count() > 0
                    ? round(($onTimeTasks->count() / $tasks->count()) * 100, 2)
                    : 0,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $timelineData
        ]);
    }

    // Méthodes utilitaires privées

    private function calculateMemberPerformance($userId): float
    {
        $lastMonth = Carbon::now()->subMonth();

        $totalTasks = Task::where('assigned_to', $userId)
            ->where('created_at', '>=', $lastMonth)
            ->count();

        if ($totalTasks === 0) return 0;

        $completedTasks = Task::where('assigned_to', $userId)
            ->where('status', 'completed')
            ->where('created_at', '>=', $lastMonth)
            ->count();

        $onTimeTasks = Task::where('assigned_to', $userId)
            ->where('status', 'completed')
            ->where('completed_at', '<=', DB::raw('due_date'))
            ->where('created_at', '>=', $lastMonth)
            ->count();

        $completionRate = ($completedTasks / $totalTasks) * 0.6;
        $onTimeRate = $completedTasks > 0 ? ($onTimeTasks / $completedTasks) * 0.4 : 0;

        return round(($completionRate + $onTimeRate) * 100, 2);
    }

    private function calculateAverageCompletionTime($userIds, $startDate, $endDate): float
    {
        $completedTasks = Task::whereIn('assigned_to', $userIds)
            ->where('status', 'completed')
            ->whereNotNull('completed_at')
            ->whereBetween('completed_at', [$startDate, $endDate])
            ->get();

        if ($completedTasks->isEmpty()) return 0;

        $totalDays = $completedTasks->sum(function ($task) {
            return Carbon::parse($task->created_at)->diffInDays($task->completed_at);
        });

        return round($totalDays / $completedTasks->count(), 2);
    }

    private function calculateTeamQualityScore($userIds, $startDate, $endDate): float
    {
        $completedTasks = Task::whereIn('assigned_to', $userIds)
            ->where('status', 'completed')
            ->whereNotNull('quality_score')
            ->whereBetween('completed_at', [$startDate, $endDate])
            ->get();

        if ($completedTasks->isEmpty()) return 0;

        return round($completedTasks->avg('quality_score'), 2);
    }

    private function calculateWorkloadPercentage($userId): float
    {
        $pendingTasks = Task::where('assigned_to', $userId)
            ->whereIn('status', ['pending', 'in_progress'])
            ->count();

        // Considérer 10 tâches comme charge normale (100%)
        return min(($pendingTasks / 10) * 100, 100);
    }

    private function calculateWorkloadLevel($pendingTasks, $urgentTasks, $overdueTasks): string
    {
        if ($overdueTasks > 0) return 'critical';
        if ($urgentTasks > 3) return 'high';
        if ($pendingTasks > 8) return 'medium';
        return 'low';
    }

    private function getMemberProductivityBreakdown($userIds, $startDate, $endDate): array
    {
        return User::whereIn('id', $userIds)->get()->map(function ($user) use ($startDate, $endDate) {
            $tasks = Task::where('assigned_to', $user->id)
                ->whereBetween('created_at', [$startDate, $endDate]);

            $completedTasks = Task::where('assigned_to', $user->id)
                ->where('status', 'completed')
                ->whereBetween('completed_at', [$startDate, $endDate]);

            return [
                'user_id' => $user->id,
                'user_name' => $user->first_name . ' ' . $user->last_name,
                'assigned_tasks' => $tasks->count(),
                'completed_tasks' => $completedTasks->count(),
                'completion_rate' => $tasks->count() > 0
                    ? round(($completedTasks->count() / $tasks->count()) * 100, 2)
                    : 0,
                'average_completion_time' => $this->calculateAverageCompletionTime([$user->id], $startDate, $endDate),
            ];
        })->toArray();
    }
}
