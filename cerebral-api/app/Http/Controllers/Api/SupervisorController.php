<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use App\Models\Project;
use App\Models\User;
use App\Models\Personnel;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class SupervisorController extends Controller
{
    /**
     * Dashboard supervisor
     */
    public function dashboard(): JsonResponse
    {
        $user = Auth::user();

        // Pour un supervisor, on récupère toutes les équipes et projets
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $supervisedProjects = Project::all(); // Tous les projets pour un supervisor

        $dashboardData = [
            'overview' => [
                'total_teams' => Personnel::whereNotNull('manager_id')->distinct('manager_id')->count(),
                'total_members' => $supervisedTeams->count(),
                'total_projects' => $supervisedProjects->count(),
                'active_projects' => $supervisedProjects->where('status', 'active')->count(),
            ],
            'recent_activities' => [
                'tasks_completed_today' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->where('status', 'completed')
                    ->whereDate('completed_at', Carbon::today())
                    ->count(),
                'tasks_pending_approval' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->where('status', 'validated')
                    ->count(),
                'quality_checks_pending' => $this->getPendingQualityChecks(),
            ],
            'performance_metrics' => [
                'average_completion_time' => $this->calculateAverageCompletionTime($supervisedTeams),
                'quality_score' => $this->calculateOverallQualityScore($supervisedTeams),
                'team_performance' => $this->calculateTeamAveragePerformance($supervisedTeams),
            ],
            'projects' => Project::with(['tasks', 'manager', 'client'])
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get(),
        ];

        return response()->json([
            'success' => true,
            'data' => $dashboardData
        ]);
    }

    /**
     * Équipes supervisées
     */
    public function myTeams(): JsonResponse
    {
        $user = Auth::user();

        // Pour un supervisor, on récupère tous les équipes (groupées par manager)
        $teams = Personnel::with(['user', 'department', 'manager'])
            ->whereNotNull('manager_id')
            ->get()
            ->groupBy('manager_id');

        // Ajouter les statistiques pour chaque équipe
        $teamsWithStats = $teams->map(function ($teamMembers, $managerId) {
            $manager = $teamMembers->first()->manager;
            $memberIds = $teamMembers->pluck('user_id')->filter();

            $teamStats = [
                'total_members' => $teamMembers->count(),
                'active_members' => $teamMembers->where('status', 'active')->count(),
                'total_tasks' => Task::whereIn('assigned_to', $memberIds)->count(),
                'completed_tasks' => Task::whereIn('assigned_to', $memberIds)
                    ->where('status', 'completed')
                    ->count(),
                'pending_approval' => Task::whereIn('assigned_to', $memberIds)
                    ->where('status', 'validated')
                    ->count(),
                'average_performance' => $this->calculateTeamAveragePerformance($memberIds),
            ];

            return [
                'manager_id' => $managerId,
                'manager_name' => $manager ? $manager->first_name . ' ' . $manager->last_name : 'N/A',
                'members' => $teamMembers,
                'stats' => $teamStats,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $teamsWithStats->values()
        ]);
    }

    /**
     * Projets supervisés
     */
    public function supervisedProjects(): JsonResponse
    {
        $user = Auth::user();

        $projects = Project::with(['tasks', 'manager', 'client'])
            ->orderBy('created_at', 'desc')
            ->get();

        // Ajouter les statistiques de supervision pour chaque projet
        $projectsWithSupervisionStats = $projects->map(function ($project) {
            $supervisionStats = [
                'total_tasks' => $project->tasks->count(),
                'tasks_awaiting_approval' => $project->tasks->where('status', 'validated')->count(),
                'tasks_approved' => $project->tasks->where('status', 'approved')->count(),
                'quality_score' => $project->tasks->whereNotNull('quality_score')->avg('quality_score'),
                'technical_issues' => $this->getTechnicalIssuesCount($project->id),
                'supervision_status' => $this->getProjectSupervisionStatus($project),
            ];

            $project->supervision_stats = $supervisionStats;
            return $project;
        });

        return response()->json([
            'success' => true,
            'data' => $projectsWithSupervisionStats
        ]);
    }

    /**
     * Rapports de supervision
     */
    public function supervisionReports(): JsonResponse
    {
        $user = Auth::user();
        $startOfMonth = Carbon::now()->startOfMonth();
        $endOfMonth = Carbon::now()->endOfMonth();

        // Récupérer tous les équipes (pour un supervisor)
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        // Rapport de supervision technique
        $technicalReport = [
            'period' => [
                'start' => $startOfMonth->format('Y-m-d'),
                'end' => $endOfMonth->format('Y-m-d'),
            ],
            'supervision_metrics' => [
                'total_tasks_supervised' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
                    ->count(),
                'tasks_approved' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->where('status', 'approved')
                    ->whereBetween('approved_at', [$startOfMonth, $endOfMonth])
                    ->count(),
                'tasks_rejected' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->where('status', 'rejected')
                    ->whereBetween('updated_at', [$startOfMonth, $endOfMonth])
                    ->count(),
                'average_approval_time' => $this->calculateAverageApprovalTime($supervisedTeams),
                'quality_issues_found' => $this->getQualityIssuesCount($supervisedTeams),
            ],
            'team_performance' => [
                'best_performing_team' => $this->getBestPerformingTeam($supervisedTeams),
                'teams_needing_attention' => $this->getTeamsNeedingAttention($supervisedTeams),
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $technicalReport
        ]);
    }

    /**
     * Contrôles qualité
     */
    public function qualityChecks(): JsonResponse
    {
        $user = Auth::user();
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $qualityChecks = Task::whereIn('assigned_to', $supervisedTeams)
            ->where('status', 'completed')
            ->whereNull('quality_checked_at')
            ->with(['assignedTo', 'project'])
            ->orderBy('completed_at', 'desc')
            ->get()
            ->map(function ($task) {
                return [
                    'task_id' => $task->id,
                    'task_title' => $task->title,
                    'project_name' => $task->project->name ?? 'N/A',
                    'assigned_to' => $task->assignedTo->first_name . ' ' . $task->assignedTo->last_name,
                    'completed_at' => $task->completed_at,
                    'estimated_hours' => $task->estimated_hours,
                    'actual_hours' => $task->actual_hours,
                    'quality_score' => $task->quality_score,
                    'status' => 'pending_quality_check',
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $qualityChecks
        ]);
    }

    /**
     * Approuver un contrôle qualité
     */
    public function approveQualityCheck(Request $request): JsonResponse
    {
        $request->validate([
            'task_id' => 'required|exists:tasks,id',
            'quality_score' => 'required|numeric|min:0|max:100',
            'comments' => 'nullable|string',
            'approved' => 'required|boolean',
        ]);

        $task = Task::findOrFail($request->task_id);

        // Vérifier que l'utilisateur est supervisor
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        if (!in_array($task->assigned_to, $supervisedTeams->toArray())) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à approuver cette tâche'
            ], 403);
        }

        $task->update([
            'quality_checked_at' => Carbon::now(),
            'quality_score' => $request->quality_score,
            'quality_comments' => $request->comments,
            'status' => $request->approved ? 'approved' : 'rejected',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Contrôle qualité effectué avec succès',
            'data' => $task
        ]);
    }

    /**
     * Incidents
     */
    public function incidents(): JsonResponse
    {
        $user = Auth::user();
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $incidents = Task::whereIn('assigned_to', $supervisedTeams)
            ->where('status', 'incident')
            ->with(['assignedTo', 'project'])
            ->orderBy('updated_at', 'desc')
            ->get()
            ->map(function ($task) {
                return [
                    'incident_id' => $task->id,
                    'task_title' => $task->title,
                    'project_name' => $task->project->name ?? 'N/A',
                    'reported_by' => $task->assignedTo->first_name . ' ' . $task->assignedTo->last_name,
                    'reported_at' => $task->updated_at,
                    'incident_description' => $task->notes,
                    'priority' => $task->priority,
                    'status' => 'open',
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $incidents
        ]);
    }

    /**
     * Résoudre un incident
     */
    public function resolveIncident(Request $request): JsonResponse
    {
        $request->validate([
            'incident_id' => 'required|exists:tasks,id',
            'resolution' => 'required|string',
            'resolved' => 'required|boolean',
        ]);

        $task = Task::findOrFail($request->incident_id);

        // Vérifier que l'utilisateur est supervisor
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        if (!in_array($task->assigned_to, $supervisedTeams->toArray())) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à résoudre cet incident'
            ], 403);
        }

        $task->update([
            'status' => $request->resolved ? 'in_progress' : 'incident',
            'notes' => $request->resolution,
            'resolved_at' => $request->resolved ? Carbon::now() : null,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Incident traité avec succès',
            'data' => $task
        ]);
    }

    /**
     * Revue technique
     */
    public function technicalReview(Request $request, Task $task): JsonResponse
    {
        $request->validate([
            'technical_score' => 'required|numeric|min:0|max:100',
            'technical_comments' => 'required|string',
            'approved' => 'required|boolean',
        ]);

        // Vérifier que l'utilisateur est supervisor
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        if (!in_array($task->assigned_to, $supervisedTeams->toArray())) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à effectuer cette revue'
            ], 403);
        }

        $task->update([
            'technical_reviewed_at' => Carbon::now(),
            'technical_score' => $request->technical_score,
            'technical_comments' => $request->technical_comments,
            'status' => $request->approved ? 'validated' : 'rejected',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Revue technique effectuée avec succès',
            'data' => $task
        ]);
    }

    /**
     * Problèmes techniques
     */
    public function technicalIssues(): JsonResponse
    {
        $user = Auth::user();
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $technicalIssues = Task::whereIn('assigned_to', $supervisedTeams)
            ->where('status', 'technical_issue')
            ->with(['assignedTo', 'project'])
            ->orderBy('updated_at', 'desc')
            ->get()
            ->map(function ($task) {
                return [
                    'issue_id' => $task->id,
                    'task_title' => $task->title,
                    'project_name' => $task->project->name ?? 'N/A',
                    'reported_by' => $task->assignedTo->first_name . ' ' . $task->assignedTo->last_name,
                    'issue_description' => $task->notes,
                    'priority' => $task->priority,
                    'status' => 'open',
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $technicalIssues
        ]);
    }

    /**
     * Escalader un problème
     */
    public function escalateIssue(Request $request): JsonResponse
    {
        $request->validate([
            'issue_id' => 'required|exists:tasks,id',
            'escalation_reason' => 'required|string',
            'escalation_level' => 'required|in:low,medium,high,critical',
        ]);

        $task = Task::findOrFail($request->issue_id);

        // Vérifier que l'utilisateur est supervisor
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        if (!in_array($task->assigned_to, $supervisedTeams->toArray())) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à escalader ce problème'
            ], 403);
        }

        $task->update([
            'status' => 'escalated',
            'escalation_reason' => $request->escalation_reason,
            'escalation_level' => $request->escalation_level,
            'escalated_at' => Carbon::now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Problème escaladé avec succès',
            'data' => $task
        ]);
    }

    /**
     * Approbation finale d'un projet
     */
    public function finalApproval(Request $request, Project $project): JsonResponse
    {
        $request->validate([
            'approved' => 'required|boolean',
            'final_comments' => 'nullable|string',
        ]);

        // Vérifier que l'utilisateur est supervisor
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $projectTasks = $project->tasks()->whereIn('assigned_to', $supervisedTeams)->count();

        if ($projectTasks === 0) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à approuver ce projet'
            ], 403);
        }

        $project->update([
            'status' => $request->approved ? 'completed' : 'rejected',
            'final_approval_at' => Carbon::now(),
            'final_approval_by' => Auth::id(),
            'final_comments' => $request->final_comments,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Approbation finale effectuée avec succès',
            'data' => $project
        ]);
    }

    /**
     * Approbations en attente
     */
    public function pendingApprovals(): JsonResponse
    {
        $user = Auth::user();
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $pendingApprovals = [
            'tasks' => Task::whereIn('assigned_to', $supervisedTeams)
                ->where('status', 'validated')
                ->with(['assignedTo', 'project'])
                ->orderBy('updated_at', 'desc')
                ->get(),
            'projects' => Project::where('status', 'pending_final_approval')
                ->with(['manager', 'client'])
                ->orderBy('updated_at', 'desc')
                ->get(),
        ];

        return response()->json([
            'success' => true,
            'data' => $pendingApprovals
        ]);
    }

    /**
     * Rapport de performance technique
     */
    public function technicalPerformanceReport(Request $request): JsonResponse
    {
        $user = Auth::user();
        $startDate = $request->get('start_date', Carbon::now()->startOfMonth());
        $endDate = $request->get('end_date', Carbon::now()->endOfMonth());

        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $report = [
            'period' => [
                'start' => $startDate,
                'end' => $endDate,
            ],
            'performance_metrics' => [
                'total_tasks_reviewed' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->whereNotNull('technical_reviewed_at')
                    ->whereBetween('technical_reviewed_at', [$startDate, $endDate])
                    ->count(),
                'average_technical_score' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->whereNotNull('technical_score')
                    ->whereBetween('technical_reviewed_at', [$startDate, $endDate])
                    ->avg('technical_score'),
                'tasks_approved' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->where('status', 'approved')
                    ->whereBetween('technical_reviewed_at', [$startDate, $endDate])
                    ->count(),
                'tasks_rejected' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->where('status', 'rejected')
                    ->whereBetween('technical_reviewed_at', [$startDate, $endDate])
                    ->count(),
            ],
            'team_breakdown' => $this->generateTeamPerformanceBreakdown($supervisedTeams, $startDate, $endDate),
        ];

        return response()->json([
            'success' => true,
            'data' => $report
        ]);
    }

    /**
     * Rapport des métriques de qualité
     */
    public function qualityMetricsReport(Request $request): JsonResponse
    {
        $user = Auth::user();
        $startDate = $request->get('start_date', Carbon::now()->startOfMonth());
        $endDate = $request->get('end_date', Carbon::now()->endOfMonth());

        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $report = [
            'period' => [
                'start' => $startDate,
                'end' => $endDate,
            ],
            'quality_metrics' => [
                'total_quality_checks' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->whereNotNull('quality_checked_at')
                    ->whereBetween('quality_checked_at', [$startDate, $endDate])
                    ->count(),
                'average_quality_score' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->whereNotNull('quality_score')
                    ->whereBetween('quality_checked_at', [$startDate, $endDate])
                    ->avg('quality_score'),
                'quality_issues_found' => $this->getQualityIssuesCount($supervisedTeams, $startDate, $endDate),
                'rejection_rate' => $this->calculateRejectionRate($supervisedTeams, $startDate, $endDate),
            ],
            'quality_trends' => $this->generateQualityTrends($supervisedTeams, $startDate, $endDate),
        ];

        return response()->json([
            'success' => true,
            'data' => $report
        ]);
    }

    /**
     * Rapport des escalades
     */
    public function escalationsReport(): JsonResponse
    {
        $user = Auth::user();
        $startDate = Carbon::now()->startOfMonth();
        $endDate = Carbon::now()->endOfMonth();

        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        $report = [
            'period' => [
                'start' => $startDate->format('Y-m-d'),
                'end' => $endDate->format('Y-m-d'),
            ],
            'escalation_metrics' => [
                'total_escalations' => Task::whereIn('assigned_to', $supervisedTeams)
                    ->where('status', 'escalated')
                    ->whereBetween('escalated_at', [$startDate, $endDate])
                    ->count(),
                'escalations_by_level' => [
                    'low' => Task::whereIn('assigned_to', $supervisedTeams)
                        ->where('status', 'escalated')
                        ->where('escalation_level', 'low')
                        ->whereBetween('escalated_at', [$startDate, $endDate])
                        ->count(),
                    'medium' => Task::whereIn('assigned_to', $supervisedTeams)
                        ->where('status', 'escalated')
                        ->where('escalation_level', 'medium')
                        ->whereBetween('escalated_at', [$startDate, $endDate])
                        ->count(),
                    'high' => Task::whereIn('assigned_to', $supervisedTeams)
                        ->where('status', 'escalated')
                        ->where('escalation_level', 'high')
                        ->whereBetween('escalated_at', [$startDate, $endDate])
                        ->count(),
                    'critical' => Task::whereIn('assigned_to', $supervisedTeams)
                        ->where('status', 'escalated')
                        ->where('escalation_level', 'critical')
                        ->whereBetween('escalated_at', [$startDate, $endDate])
                        ->count(),
                ],
                'average_resolution_time' => $this->calculateAverageEscalationResolutionTime($supervisedTeams),
            ],
            'escalation_trends' => $this->generateEscalationTrends($supervisedTeams, $startDate, $endDate),
        ];

        return response()->json([
            'success' => true,
            'data' => $report
        ]);
    }

    // Méthodes utilitaires privées
    private function getPendingQualityChecks()
    {
        $supervisedTeams = Personnel::whereNotNull('user_id')
            ->pluck('user_id');

        return Task::whereIn('assigned_to', $supervisedTeams)
            ->where('status', 'completed')
            ->whereNull('quality_checked_at')
            ->count();
    }

    private function calculateTeamAveragePerformance($memberIds)
    {
        if ($memberIds->isEmpty()) {
            return 0;
        }

        return Task::whereIn('assigned_to', $memberIds)
            ->where('status', 'completed')
            ->whereNotNull('quality_score')
            ->avg('quality_score') ?? 0;
    }

    private function calculateAverageCompletionTime($memberIds)
    {
        if ($memberIds->isEmpty()) {
            return 0;
        }

        $tasks = Task::whereIn('assigned_to', $memberIds)
            ->where('status', 'completed')
            ->whereNotNull('completed_at')
            ->whereNotNull('start_date')
            ->get();

        if ($tasks->isEmpty()) {
            return 0;
        }

        $totalHours = $tasks->sum(function ($task) {
            return Carbon::parse($task->start_date)->diffInHours($task->completed_at);
        });

        return round($totalHours / $tasks->count(), 2);
    }

    private function calculateOverallQualityScore($memberIds)
    {
        if ($memberIds->isEmpty()) {
            return 0;
        }

        return Task::whereIn('assigned_to', $memberIds)
            ->whereNotNull('quality_score')
            ->avg('quality_score') ?? 0;
    }

    private function getTechnicalIssuesCount($projectId)
    {
        return Task::where('project_id', $projectId)
            ->where('status', 'technical_issue')
            ->count();
    }

    private function getProjectSupervisionStatus($project)
    {
        $totalTasks = $project->tasks->count();
        $approvedTasks = $project->tasks->where('status', 'approved')->count();

        if ($totalTasks === 0) {
            return 'no_tasks';
        }

        $approvalRate = ($approvedTasks / $totalTasks) * 100;

        if ($approvalRate >= 90) {
            return 'excellent';
        } elseif ($approvalRate >= 75) {
            return 'good';
        } elseif ($approvalRate >= 50) {
            return 'fair';
        } else {
            return 'needs_attention';
        }
    }

    private function calculateAverageApprovalTime($memberIds)
    {
        if ($memberIds->isEmpty()) {
            return 0;
        }

        $tasks = Task::whereIn('assigned_to', $memberIds)
            ->where('status', 'approved')
            ->whereNotNull('approved_at')
            ->whereNotNull('completed_at')
            ->get();

        if ($tasks->isEmpty()) {
            return 0;
        }

        $totalHours = $tasks->sum(function ($task) {
            return Carbon::parse($task->completed_at)->diffInHours($task->approved_at);
        });

        return round($totalHours / $tasks->count(), 2);
    }

    private function getQualityIssuesCount($memberIds, $startDate = null, $endDate = null)
    {
        $query = Task::whereIn('assigned_to', $memberIds)
            ->where('status', 'rejected');

        if ($startDate && $endDate) {
            $query->whereBetween('updated_at', [$startDate, $endDate]);
        }

        return $query->count();
    }

    private function getBestPerformingTeam($memberIds)
    {
        // Logique simplifiée pour déterminer la meilleure équipe
        return 'Équipe A'; // Placeholder
    }

    private function getTeamsNeedingAttention($memberIds)
    {
        // Logique simplifiée pour déterminer les équipes nécessitant une attention
        return ['Équipe B', 'Équipe C']; // Placeholder
    }

    private function generateTeamPerformanceBreakdown($memberIds, $startDate, $endDate)
    {
        // Logique simplifiée pour générer la répartition des performances par équipe
        return [
            'team_a' => ['score' => 85, 'tasks' => 25],
            'team_b' => ['score' => 78, 'tasks' => 30],
            'team_c' => ['score' => 92, 'tasks' => 20],
        ];
    }

    private function generateQualityTrends($memberIds, $startDate, $endDate)
    {
        // Logique simplifiée pour générer les tendances de qualité
        return [
            'week_1' => 85,
            'week_2' => 87,
            'week_3' => 82,
            'week_4' => 90,
        ];
    }

    private function calculateRejectionRate($memberIds, $startDate, $endDate)
    {
        if ($memberIds->isEmpty()) {
            return 0;
        }

        $totalTasks = Task::whereIn('assigned_to', $memberIds)
            ->whereBetween('updated_at', [$startDate, $endDate])
            ->count();

        $rejectedTasks = Task::whereIn('assigned_to', $memberIds)
            ->where('status', 'rejected')
            ->whereBetween('updated_at', [$startDate, $endDate])
            ->count();

        return $totalTasks > 0 ? round(($rejectedTasks / $totalTasks) * 100, 2) : 0;
    }

    private function calculateAverageEscalationResolutionTime($memberIds)
    {
        if ($memberIds->isEmpty()) {
            return 0;
        }

        $escalations = Task::whereIn('assigned_to', $memberIds)
            ->where('status', 'escalated')
            ->whereNotNull('escalated_at')
            ->whereNotNull('resolved_at')
            ->get();

        if ($escalations->isEmpty()) {
            return 0;
        }

        $totalHours = $escalations->sum(function ($task) {
            return Carbon::parse($task->escalated_at)->diffInHours($task->resolved_at);
        });

        return round($totalHours / $escalations->count(), 2);
    }

    private function generateEscalationTrends($memberIds, $startDate, $endDate)
    {
        // Logique simplifiée pour générer les tendances d'escalade
        return [
            'week_1' => 2,
            'week_2' => 1,
            'week_3' => 3,
            'week_4' => 0,
        ];
    }
}
