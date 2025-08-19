<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\TaskRequest;
use App\Http\Resources\TaskResource;
use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class TaskController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Task::with(['project', 'assignedTo', 'createdBy']);

        // Filtres
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('priority')) {
            $query->where('priority', $request->priority);
        }

        if ($request->has('project_id')) {
            $query->where('project_id', $request->project_id);
        }

        if ($request->has('assigned_to')) {
            $query->where('assigned_to', $request->assigned_to);
        }

        // Recherche
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%");
            });
        }

        // Tri
        $sortBy = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        $tasks = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => TaskResource::collection($tasks),
            'meta' => [
                'current_page' => $tasks->currentPage(),
                'last_page' => $tasks->lastPage(),
                'per_page' => $tasks->perPage(),
                'total' => $tasks->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(TaskRequest $request): JsonResponse
    {
        $task = Task::create($request->validated());

        return response()->json([
            'success' => true,
            'message' => 'Tâche créée avec succès',
            'data' => new TaskResource($task->load(['project', 'assignedTo', 'createdBy'])),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Task $task): JsonResponse
    {
        // Recharger la tâche avec ses relations
        $task->refresh();
        $task->load(['project', 'assignedTo', 'createdBy']);

        return response()->json([
            'success' => true,
            'data' => new TaskResource($task->load(['project', 'assignedTo', 'createdBy'])),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(TaskRequest $request, Task $task): JsonResponse
    {
        // Utiliser l'ID de la route directement
        $taskId = $request->route('task');
        $task->update($request->validated());

        // Récupérer la tâche mise à jour directement depuis la base de données
        $updatedTask = Task::with(['project', 'assignedTo', 'createdBy'])->find($taskId);

        return response()->json([
            'success' => true,
            'message' => 'Tâche mise à jour avec succès',
            'data' => $updatedTask,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Task $task): JsonResponse
    {
        $task->delete();

        return response()->json([
            'success' => true,
            'message' => 'Tâche supprimée avec succès',
        ]);
    }

    /**
     * Update task status.
     */
    public function updateStatus(Request $request, Task $task): JsonResponse
    {
        $request->validate([
            'status' => 'required|string|in:pending,in_progress,review,completed,cancelled',
            'progress' => 'nullable|numeric|min:0|max:100',
        ]);

        $task->update([
            'status' => $request->status,
            'progress' => $request->progress ?? $task->progress,
            'completed_at' => $request->status === 'completed' ? now() : null,
        ]);

        // Récupérer la tâche mise à jour directement depuis la base de données
        $taskId = $request->route('task');
        $updatedTask = Task::with(['project', 'assignedTo', 'createdBy'])->find($taskId);

        return response()->json([
            'success' => true,
            'message' => 'Tâche mise à jour avec succès',
            'data' => $updatedTask,
        ]);
    }

    /**
     * Update task progress.
     */
    public function updateProgress(Request $request, Task $task): JsonResponse
    {
        $request->validate([
            'progress' => 'required|numeric|min:0|max:100',
        ]);

        $task->update(['progress' => $request->progress]);

        // Récupérer la tâche mise à jour directement depuis la base de données
        $taskId = $request->route('task');
        $updatedTask = Task::with(['project', 'assignedTo', 'createdBy'])->find($taskId);

        return response()->json([
            'success' => true,
            'message' => 'Progression de la tâche mise à jour avec succès',
            'data' => $updatedTask,
        ]);
    }

    /**
     * @OA\Put(
     *     path="/tasks/{task}/assign",
     *     summary="Assigner une tâche à un utilisateur",
     *     tags={"Tâches"},
     *     @OA\Parameter(
     *         name="task",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID de la tâche"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"assigned_to"},
     *             @OA\Property(property="assigned_to", type="integer", example=1, description="ID de l'utilisateur à qui assigner la tâche"),
     *             @OA\Property(property="assignment_notes", type="string", example="Notes d'assignation", description="Notes optionnelles pour l'assignation")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Tâche assignée avec succès",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Tâche assignée avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     ),
     *     @OA\Response(
     *         response=422,
     *         description="Erreur de validation"
     *     )
     * )
     * 
     * Assign task to user.
     */
    public function assign(Request $request, Task $task): JsonResponse
    {
        $request->validate([
            'assigned_to' => 'required|exists:users,id',
            'assignment_notes' => 'nullable|string|max:500',
        ]);

        $task->update([
            'assigned_to' => $request->assigned_to,
            'assigned_by' => $request->user()->id,
            'assignment_notes' => $request->assignment_notes,
            'assigned_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Tâche assignée avec succès',
            'data' => $task->load(['assignedTo', 'assignedBy']),
        ]);
    }

    /**
     * Get my tasks (assigned to current user).
     */
    public function myTasks(Request $request): JsonResponse
    {
        $user = $request->user();
        $query = Task::with(['project', 'assignedTo', 'createdBy'])
            ->where('assigned_to', $user->id);

        // Filtres
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('priority')) {
            $query->where('priority', $request->priority);
        }

        $tasks = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $tasks->items(),
            'meta' => [
                'current_page' => $tasks->currentPage(),
                'last_page' => $tasks->lastPage(),
                'per_page' => $tasks->perPage(),
                'total' => $tasks->total(),
            ],
        ]);
    }

    /**
     * Get overdue tasks.
     */
    public function overdueTasks(Request $request): JsonResponse
    {
        $query = Task::with(['project', 'assignedTo'])
            ->where('due_date', '<', now())
            ->where('status', '!=', 'completed');

        $tasks = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $tasks->items(),
            'meta' => [
                'current_page' => $tasks->currentPage(),
                'last_page' => $tasks->lastPage(),
                'per_page' => $tasks->perPage(),
                'total' => $tasks->total(),
            ],
        ]);
    }
}
