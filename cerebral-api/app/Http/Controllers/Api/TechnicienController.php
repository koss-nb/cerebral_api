<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use App\Models\Project;
use App\Models\User;
use App\Models\TimeTracking;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class TechnicienController extends Controller
{
    /**
     * Dashboard spécifique technicien
     */
    public function dashboard(): JsonResponse
    {
        $user = Auth::user();

        // Tâches assignées au technicien
        $assignedTasks = Task::where('assigned_to', $user->id)
            ->with(['project', 'assignedTo', 'createdBy'])
            ->get();

        // Tâches en cours
        $currentTasks = $assignedTasks->where('status', 'in_progress');

        // Tâches urgentes (priorité haute + en retard)
        $urgentTasks = $assignedTasks->where('priority', 'high')
            ->where('due_date', '<', Carbon::now());

        // Tâches complétées ce mois
        $completedThisMonth = Task::where('assigned_to', $user->id)
            ->where('status', 'completed')
            ->whereMonth('completed_at', Carbon::now()->month)
            ->count();

        // Temps travaillé aujourd'hui
        $todayWorked = TimeTracking::where('user_id', $user->id)
            ->whereDate('clock_in', Carbon::today())
            ->sum(DB::raw('TIMESTAMPDIFF(MINUTE, clock_in, COALESCE(clock_out, NOW()))'));

        // Projets assignés
        $assignedProjects = Project::whereHas('tasks', function ($query) use ($user) {
            $query->where('assigned_to', $user->id);
        })->with(['tasks', 'manager'])->get();

        return response()->json([
            'success' => true,
            'data' => [
                'stats' => [
                    'total_assigned_tasks' => $assignedTasks->count(),
                    'current_tasks' => $currentTasks->count(),
                    'urgent_tasks' => $urgentTasks->count(),
                    'completed_this_month' => $completedThisMonth,
                    'hours_worked_today' => round($todayWorked / 60, 2),
                ],
                'tasks' => [
                    'assigned' => $assignedTasks,
                    'current' => $currentTasks,
                    'urgent' => $urgentTasks,
                ],
                'projects' => $assignedProjects,
            ]
        ]);
    }

    /**
     * Statistiques technicien
     */
    public function stats(): JsonResponse
    {
        $user = Auth::user();
        $startOfMonth = Carbon::now()->startOfMonth();
        $endOfMonth = Carbon::now()->endOfMonth();

        // Statistiques du mois
        $monthlyStats = [
            'tasks_completed' => Task::where('assigned_to', $user->id)
                ->where('status', 'completed')
                ->whereBetween('completed_at', [$startOfMonth, $endOfMonth])
                ->count(),

            'hours_worked' => TimeTracking::where('user_id', $user->id)
                ->whereBetween('clock_in', [$startOfMonth, $endOfMonth])
                ->sum(DB::raw('TIMESTAMPDIFF(MINUTE, clock_in, COALESCE(clock_out, NOW()))')) / 60,

            'tasks_on_time' => Task::where('assigned_to', $user->id)
                ->where('status', 'completed')
                ->where('completed_at', '<=', DB::raw('due_date'))
                ->whereBetween('completed_at', [$startOfMonth, $endOfMonth])
                ->count(),

            'tasks_late' => Task::where('assigned_to', $user->id)
                ->where('status', 'completed')
                ->where('completed_at', '>', DB::raw('due_date'))
                ->whereBetween('completed_at', [$startOfMonth, $endOfMonth])
                ->count(),
        ];

        // Performance par semaine (4 dernières semaines)
        $weeklyPerformance = [];
        for ($i = 3; $i >= 0; $i--) {
            $weekStart = Carbon::now()->subWeeks($i)->startOfWeek();
            $weekEnd = Carbon::now()->subWeeks($i)->endOfWeek();

            $weeklyPerformance[] = [
                'week' => $weekStart->format('Y-m-d'),
                'tasks_completed' => Task::where('assigned_to', $user->id)
                    ->where('status', 'completed')
                    ->whereBetween('completed_at', [$weekStart, $weekEnd])
                    ->count(),
                'hours_worked' => TimeTracking::where('user_id', $user->id)
                    ->whereBetween('clock_in', [$weekStart, $weekEnd])
                    ->sum(DB::raw('TIMESTAMPDIFF(MINUTE, clock_in, COALESCE(clock_out, NOW()))')) / 60,
            ];
        }

        return response()->json([
            'success' => true,
            'data' => [
                'monthly_stats' => $monthlyStats,
                'weekly_performance' => $weeklyPerformance,
            ]
        ]);
    }

    /**
     * Tâches assignées au technicien connecté
     */
    public function assignedTasks(): JsonResponse
    {
        $user = Auth::user();

        $tasks = Task::where('assigned_to', $user->id)
            ->with(['project', 'assignedTo', 'createdBy'])
            ->orderBy('priority', 'desc')
            ->orderBy('due_date', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $tasks
        ]);
    }

    /**
     * Projets assignés au technicien
     */
    public function assignedProjects(): JsonResponse
    {
        $user = Auth::user();

        $projects = Project::whereHas('tasks', function ($query) use ($user) {
            $query->where('assigned_to', $user->id);
        })->with(['tasks' => function ($query) use ($user) {
            $query->where('assigned_to', $user->id);
        }, 'manager'])->get();

        return response()->json([
            'success' => true,
            'data' => $projects
        ]);
    }

    /**
     * Performance du technicien
     */
    public function performance(): JsonResponse
    {
        $user = Auth::user();
        $lastMonth = Carbon::now()->subMonth();

        // Calcul de la performance
        $totalTasks = Task::where('assigned_to', $user->id)
            ->where('created_at', '>=', $lastMonth)
            ->count();

        $completedTasks = Task::where('assigned_to', $user->id)
            ->where('status', 'completed')
            ->where('created_at', '>=', $lastMonth)
            ->count();

        $onTimeTasks = Task::where('assigned_to', $user->id)
            ->where('status', 'completed')
            ->where('completed_at', '<=', DB::raw('due_date'))
            ->where('created_at', '>=', $lastMonth)
            ->count();

        $performance = [
            'completion_rate' => $totalTasks > 0 ? round(($completedTasks / $totalTasks) * 100, 2) : 0,
            'on_time_rate' => $completedTasks > 0 ? round(($onTimeTasks / $completedTasks) * 100, 2) : 0,
            'total_tasks' => $totalTasks,
            'completed_tasks' => $completedTasks,
            'on_time_tasks' => $onTimeTasks,
        ];

        return response()->json([
            'success' => true,
            'data' => $performance
        ]);
    }

    /**
     * Historique des tâches complétées
     */
    public function completedTasks(Request $request): JsonResponse
    {
        $user = Auth::user();
        $perPage = $request->get('per_page', 15);

        $tasks = Task::where('assigned_to', $user->id)
            ->where('status', 'completed')
            ->with(['project', 'assignedTo', 'createdBy'])
            ->orderBy('completed_at', 'desc')
            ->paginate($perPage);

        return response()->json([
            'success' => true,
            'data' => $tasks
        ]);
    }

    /**
     * Tâches en cours du technicien
     */
    public function currentTasks(): JsonResponse
    {
        $user = Auth::user();

        $tasks = Task::where('assigned_to', $user->id)
            ->whereIn('status', ['pending', 'in_progress'])
            ->with(['project', 'assignedTo', 'createdBy'])
            ->orderBy('priority', 'desc')
            ->orderBy('due_date', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $tasks
        ]);
    }

    /**
     * Tâches urgentes du technicien
     */
    public function urgentTasks(): JsonResponse
    {
        $user = Auth::user();

        $tasks = Task::where('assigned_to', $user->id)
            ->where(function ($query) {
                $query->where('priority', 'high')
                    ->orWhere('due_date', '<', Carbon::now());
            })
            ->whereIn('status', ['pending', 'in_progress'])
            ->with(['project', 'assignedTo', 'createdBy'])
            ->orderBy('due_date', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $tasks
        ]);
    }

    /**
     * Pointage - Entrée
     */
    public function clockIn(): JsonResponse
    {
        $user = Auth::user();

        // Vérifier si déjà pointé
        $existingClockIn = TimeTracking::where('user_id', $user->id)
            ->whereNull('clock_out')
            ->first();

        if ($existingClockIn) {
            return response()->json([
                'success' => false,
                'message' => 'Vous êtes déjà pointé en entrée'
            ], 400);
        }

        $timeTracking = TimeTracking::create([
            'user_id' => $user->id,
            'clock_in' => Carbon::now(),
            'type' => 'work',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Pointage d\'entrée enregistré',
            'data' => $timeTracking
        ]);
    }

    /**
     * Pointage - Sortie
     */
    public function clockOut(): JsonResponse
    {
        $user = Auth::user();

        $timeTracking = TimeTracking::where('user_id', $user->id)
            ->whereNull('clock_out')
            ->first();

        if (!$timeTracking) {
            return response()->json([
                'success' => false,
                'message' => 'Aucun pointage d\'entrée trouvé'
            ], 400);
        }

        $timeTracking->update([
            'clock_out' => Carbon::now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Pointage de sortie enregistré',
            'data' => $timeTracking
        ]);
    }

    /**
     * Feuille de temps
     */
    public function timeSheet(Request $request): JsonResponse
    {
        $user = Auth::user();
        $startDate = $request->get('start_date', Carbon::now()->startOfWeek());
        $endDate = $request->get('end_date', Carbon::now()->endOfWeek());

        $timeSheet = TimeTracking::where('user_id', $user->id)
            ->whereBetween('clock_in', [$startDate, $endDate])
            ->orderBy('clock_in', 'asc')
            ->get();

        $totalHours = $timeSheet->sum(function ($entry) {
            if ($entry->clock_out) {
                return Carbon::parse($entry->clock_in)->diffInMinutes($entry->clock_out);
            }
            return Carbon::parse($entry->clock_in)->diffInMinutes(Carbon::now());
        }) / 60;

        return response()->json([
            'success' => true,
            'data' => [
                'entries' => $timeSheet,
                'total_hours' => round($totalHours, 2),
                'period' => [
                    'start_date' => $startDate,
                    'end_date' => $endDate,
                ]
            ]
        ]);
    }

    /**
     * Marquer une tâche comme complétée
     */
    public function completeTask(Request $request, Task $task): JsonResponse
    {
        $user = Auth::user();

        // Vérifier que la tâche est assignée au technicien
        if ($task->assigned_to !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à compléter cette tâche'
            ], 403);
        }

        $task->update([
            'status' => 'completed',
            'completed_at' => Carbon::now(),
            'progress' => 100,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Tâche marquée comme complétée',
            'data' => $task->load(['project', 'assignedTo', 'createdBy'])
        ]);
    }

    /**
     * Valider une tâche
     */
    public function validateTask(Request $request, Task $task): JsonResponse
    {
        $user = Auth::user();

        // Vérifier que la tâche est assignée au technicien
        if ($task->assigned_to !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à valider cette tâche'
            ], 403);
        }

        $request->validate([
            'validation_notes' => 'nullable|string',
            'quality_score' => 'nullable|integer|min:1|max:10',
        ]);

        $task->update([
            'status' => 'validated',
            'validation_notes' => $request->validation_notes,
            'quality_score' => $request->quality_score,
            'validated_at' => Carbon::now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Tâche validée',
            'data' => $task->load(['project', 'assignedTo', 'createdBy'])
        ]);
    }

    /**
     * Signaler un problème sur une tâche
     */
    public function reportIssue(Request $request, Task $task): JsonResponse
    {
        $user = Auth::user();

        // Vérifier que la tâche est assignée au technicien
        if ($task->assigned_to !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Vous n\'êtes pas autorisé à signaler un problème sur cette tâche'
            ], 403);
        }

        $request->validate([
            'issue_description' => 'required|string',
            'issue_type' => 'required|in:technical,resource,time,other',
            'priority' => 'required|in:low,medium,high,urgent',
        ]);

        // Créer un incident
        $incident = DB::table('incidents')->insert([
            'task_id' => $task->id,
            'reported_by' => $user->id,
            'description' => $request->issue_description,
            'type' => $request->issue_type,
            'priority' => $request->priority,
            'status' => 'open',
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);

        // Mettre à jour le statut de la tâche
        $task->update([
            'status' => 'on_hold',
            'notes' => $task->notes . "\n\nProblème signalé: " . $request->issue_description,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Problème signalé avec succès',
            'data' => [
                'task' => $task->load(['project', 'assignedTo', 'createdBy']),
                'incident_id' => DB::getPdo()->lastInsertId(),
            ]
        ]);
    }

    /**
     * Documents du technicien
     */
    public function documents(): JsonResponse
    {
        $user = Auth::user();

        // Récupérer les documents liés aux projets du technicien
        $documents = DB::table('documents')
            ->whereIn('project_id', function ($query) use ($user) {
                $query->select('project_id')
                    ->from('tasks')
                    ->where('assigned_to', $user->id);
            })
            ->orWhere('uploaded_by', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $documents
        ]);
    }

    /**
     * Upload de document
     */
    public function uploadDocument(Request $request): JsonResponse
    {
        $user = Auth::user();

        $request->validate([
            'file' => 'required|file|max:10240', // 10MB max
            'project_id' => 'required|exists:projects,id',
            'description' => 'nullable|string',
        ]);

        $file = $request->file('file');
        $fileName = time() . '_' . $file->getClientOriginalName();
        $filePath = $file->storeAs('documents', $fileName, 'public');

        $document = DB::table('documents')->insert([
            'project_id' => $request->project_id,
            'uploaded_by' => $user->id,
            'file_name' => $fileName,
            'file_path' => $filePath,
            'description' => $request->description,
            'file_size' => $file->getSize(),
            'mime_type' => $file->getMimeType(),
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Document uploadé avec succès',
            'data' => [
                'file_name' => $fileName,
                'file_path' => $filePath,
                'document_id' => DB::getPdo()->lastInsertId(),
            ]
        ]);
    }

    /**
     * Télécharger un document
     */
    public function downloadDocument($documentId): JsonResponse
    {
        $user = Auth::user();

        $document = DB::table('documents')
            ->where('id', $documentId)
            ->where(function ($query) use ($user) {
                $query->where('uploaded_by', $user->id)
                    ->orWhereIn('project_id', function ($subQuery) use ($user) {
                        $subQuery->select('project_id')
                            ->from('tasks')
                            ->where('assigned_to', $user->id);
                    });
            })
            ->first();

        if (!$document) {
            return response()->json([
                'success' => false,
                'message' => 'Document non trouvé ou accès non autorisé'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $document
        ]);
    }
}
