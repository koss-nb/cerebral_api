<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Project;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class ProjectController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Project::with(['manager', 'tasks']);

        // Filtres
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        if ($request->has('priority')) {
            $query->where('priority', $request->priority);
        }

        if ($request->has('manager_id')) {
            $query->where('manager_id', $request->manager_id);
        }

        // Recherche
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%")
                    ->orWhere('location', 'like', "%{$search}%");
            });
        }

        // Tri
        $sortBy = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        $projects = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $projects->items(),
            'meta' => [
                'current_page' => $projects->currentPage(),
                'last_page' => $projects->lastPage(),
                'per_page' => $projects->perPage(),
                'total' => $projects->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'type' => 'required|string|in:residential,commercial,industrial',
            'status' => 'required|string|in:planning,in_progress,on_hold,completed,cancelled',
            'priority' => 'required|string|in:low,medium,high,critical',
            'budget' => 'nullable|numeric|min:0',
            'currency' => 'nullable|string|size:3',
            'client_name' => 'required|string|max:255',
            'client_email' => 'required|email|max:255',
            'client_phone' => 'nullable|string|max:20',
            'location' => 'required|string|max:255',
            'manager_id' => 'required|exists:users,id',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after:start_date',
            'progress' => 'nullable|numeric|min:0|max:100',
            'team_members' => 'nullable|array',
            'team_members.*' => 'exists:users,id',
            'tags' => 'nullable|array',
            'tags.*' => 'string|max:50',
            'attachments' => 'nullable|array',
            'attachments.*' => 'string',
        ]);

        $project = Project::create($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Projet créé avec succès',
            'project' => $project->load('manager'),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Project $project): JsonResponse
    {
        $project->load(['manager', 'tasks.assignedTo', 'budgets']);

        return response()->json([
            'success' => true,
            'data' => $project,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Project $project): JsonResponse
    {
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'type' => 'sometimes|string|in:residential,commercial,industrial',
            'status' => 'sometimes|string|in:active,completed,on_hold,cancelled',
            'budget' => 'nullable|numeric|min:0',
            'currency' => 'nullable|string|size:3',
            'location' => 'sometimes|string|max:255',
            'manager_id' => 'sometimes|exists:users,id',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after:start_date',
            'progress' => 'nullable|numeric|min:0|max:100',
        ]);

        $project->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Project updated successfully',
            'data' => $project->load('manager'),
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Project $project): JsonResponse
    {
        $project->delete();

        return response()->json([
            'success' => true,
            'message' => 'Projet supprimé avec succès',
        ]);
    }

    /**
     * Get project statistics.
     */
    public function stats(Project $project): JsonResponse
    {
        $stats = [
            'total_tasks' => $project->tasks()->count(),
            'completed_tasks' => $project->tasks()->where('status', 'completed')->count(),
            'pending_tasks' => $project->tasks()->where('status', 'pending')->count(),
            'in_progress_tasks' => $project->tasks()->where('status', 'in_progress')->count(),
            'total_budget_spent' => $project->budgets()->sum('amount'),
            'remaining_budget' => $project->budget ? $project->budget - $project->budgets()->sum('amount') : 0,
            'progress_percentage' => $project->progress,
            'days_remaining' => $project->end_date ? now()->diffInDays($project->end_date, false) : null,
            'is_overdue' => $project->is_overdue,
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    /**
     * Update project progress.
     */
    public function updateProgress(Request $request, Project $project): JsonResponse
    {
        $request->validate([
            'status' => 'required|string|in:planning,in_progress,on_hold,completed,cancelled',
            'progress' => 'required|numeric|min:0|max:100',
        ]);

        $project->update([
            'status' => $request->status,
            'progress' => $request->progress
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Projet mis à jour avec succès',
            'data' => $project,
        ]);
    }

    /**
     * Get projects by user role.
     */
    public function myProjects(Request $request): JsonResponse
    {
        $user = $request->user();
        $query = Project::with(['manager', 'tasks']);

        if ($user->role === 'admin') {
            // Admin voit tous les projets
        } elseif ($user->role === 'manager') {
            // Manager voit ses projets et ceux de son équipe
            $query->where('manager_id', $user->id);
        } else {
            // Autres utilisateurs voient seulement les projets auxquels ils sont assignés
            $query->whereHas('tasks', function ($q) use ($user) {
                $q->where('assigned_to', $user->id);
            });
        }

        $projects = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $projects->items(),
            'pagination' => [
                'current_page' => $projects->currentPage(),
                'last_page' => $projects->lastPage(),
                'per_page' => $projects->perPage(),
                'total' => $projects->total(),
            ],
        ]);
    }
}
