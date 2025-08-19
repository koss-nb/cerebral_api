<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Issue;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class IssueController extends Controller
{
    /**
     * @OA\Get(
     *     path="/issues",
     *     summary="Liste des problèmes",
     *     tags={"Problèmes"},
     *     @OA\Parameter(
     *         name="status",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par statut"
     *     ),
     *     @OA\Parameter(
     *         name="priority",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par priorité"
     *     ),
     *     @OA\Parameter(
     *         name="type",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string"),
     *         description="Filtrer par type"
     *     ),
     *     @OA\Parameter(
     *         name="project_id",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="integer"),
     *         description="Filtrer par projet"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Liste des problèmes",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function index(Request $request): JsonResponse
    {
        $query = Issue::with(['project', 'task', 'reportedBy', 'assignedTo']);

        if ($request->status) {
            $query->ofStatus($request->status);
        }

        if ($request->priority) {
            $query->ofPriority($request->priority);
        }

        if ($request->type) {
            $query->ofType($request->type);
        }

        if ($request->project_id) {
            $query->where('project_id', $request->project_id);
        }

        $issues = $query->orderBy('reported_at', 'desc')->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $issues,
        ]);
    }

    /**
     * @OA\Post(
     *     path="/issues",
     *     summary="Signaler un problème",
     *     tags={"Problèmes"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"title", "description", "priority", "type"},
     *             @OA\Property(property="title", type="string", example="Fuite d'eau", description="Titre du problème"),
     *             @OA\Property(property="description", type="string", example="Fuite d'eau dans la salle de bain", description="Description détaillée"),
     *             @OA\Property(property="priority", type="string", example="high", description="Priorité (low/medium/high/critical)"),
     *             @OA\Property(property="type", type="string", example="technical", description="Type (safety/quality/logistics/technical/other)"),
     *             @OA\Property(property="project_id", type="integer", example=1, description="ID du projet (optionnel)"),
     *             @OA\Property(property="task_id", type="integer", example=1, description="ID de la tâche (optionnel)"),
     *             @OA\Property(property="location", type="string", example="Villa A3 - Salle de bain", description="Localisation"),
     *             @OA\Property(property="assigned_to", type="integer", example=1, description="ID de l'utilisateur assigné (optionnel)")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Problème signalé",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Problème signalé avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string|min:10',
            'priority' => 'required|in:low,medium,high,critical',
            'type' => 'required|in:safety,quality,logistics,technical,other',
            'project_id' => 'nullable|exists:projects,id',
            'task_id' => 'nullable|exists:tasks,id',
            'location' => 'nullable|string|max:255',
            'assigned_to' => 'nullable|exists:users,id',
        ]);

        $issue = Issue::create([
            ...$request->all(),
            'reported_by' => Auth::id(),
            'reported_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Problème signalé avec succès',
            'data' => $issue->load(['project', 'task', 'reportedBy', 'assignedTo']),
        ]);
    }

    /**
     * @OA\Get(
     *     path="/issues/{issue}",
     *     summary="Détails d'un problème",
     *     tags={"Problèmes"},
     *     @OA\Parameter(
     *         name="issue",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du problème"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Détails du problème",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function show(Issue $issue): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $issue->load(['project', 'task', 'reportedBy', 'assignedTo']),
        ]);
    }

    /**
     * @OA\Put(
     *     path="/issues/{issue}",
     *     summary="Modifier un problème",
     *     tags={"Problèmes"},
     *     @OA\Parameter(
     *         name="issue",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du problème"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="title", type="string", example="Fuite d'eau - Mise à jour"),
     *             @OA\Property(property="description", type="string", example="Description mise à jour"),
     *             @OA\Property(property="priority", type="string", example="critical"),
     *             @OA\Property(property="status", type="string", example="in_progress")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Problème modifié",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Problème modifié avec succès"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function update(Request $request, Issue $issue): JsonResponse
    {
        $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'sometimes|string|min:10',
            'priority' => 'sometimes|in:low,medium,high,critical',
            'type' => 'sometimes|in:safety,quality,logistics,technical,other',
            'status' => 'sometimes|in:open,in_progress,resolved,closed',
            'project_id' => 'sometimes|exists:projects,id',
            'task_id' => 'sometimes|exists:tasks,id',
            'location' => 'nullable|string|max:255',
            'assigned_to' => 'nullable|exists:users,id',
        ]);

        $issue->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Problème modifié avec succès',
            'data' => $issue->load(['project', 'task', 'reportedBy', 'assignedTo']),
        ]);
    }

    /**
     * @OA\Delete(
     *     path="/issues/{issue}",
     *     summary="Supprimer un problème",
     *     tags={"Problèmes"},
     *     @OA\Parameter(
     *         name="issue",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du problème"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Problème supprimé",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Problème supprimé avec succès")
     *         )
     *     )
     * )
     */
    public function destroy(Issue $issue): JsonResponse
    {
        $issue->delete();

        return response()->json([
            'success' => true,
            'message' => 'Problème supprimé avec succès',
        ]);
    }

    /**
     * @OA\Post(
     *     path="/issues/{issue}/resolve",
     *     summary="Résoudre un problème",
     *     tags={"Problèmes"},
     *     @OA\Parameter(
     *         name="issue",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du problème"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="resolution_notes", type="string", example="Problème résolu en remplaçant le joint", description="Notes de résolution")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Problème résolu",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Problème résolu"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function resolve(Request $request, Issue $issue): JsonResponse
    {
        $request->validate([
            'resolution_notes' => 'nullable|string',
        ]);

        if ($issue->isResolved()) {
            return response()->json([
                'success' => false,
                'message' => 'Ce problème est déjà résolu',
            ], 400);
        }

        $issue->markAsResolved($request->resolution_notes);

        return response()->json([
            'success' => true,
            'message' => 'Problème résolu avec succès',
            'data' => $issue->load(['project', 'task', 'reportedBy', 'assignedTo']),
        ]);
    }

    /**
     * @OA\Post(
     *     path="/issues/{issue}/assign",
     *     summary="Assigner un problème",
     *     tags={"Problèmes"},
     *     @OA\Parameter(
     *         name="issue",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer"),
     *         description="ID du problème"
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"assigned_to"},
     *             @OA\Property(property="assigned_to", type="integer", example=1, description="ID de l'utilisateur à assigner")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Problème assigné",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Problème assigné"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function assign(Request $request, Issue $issue): JsonResponse
    {
        $request->validate([
            'assigned_to' => 'required|exists:users,id',
        ]);

        $issue->update([
            'assigned_to' => $request->assigned_to,
            'status' => 'in_progress',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Problème assigné avec succès',
            'data' => $issue->load(['project', 'task', 'reportedBy', 'assignedTo']),
        ]);
    }

    /**
     * @OA\Get(
     *     path="/issues/critical",
     *     summary="Problèmes critiques",
     *     tags={"Problèmes"},
     *     @OA\Response(
     *         response=200,
     *         description="Problèmes critiques",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function critical(): JsonResponse
    {
        $criticalIssues = Issue::where('priority', 'critical')
            ->where('status', '!=', 'resolved')
            ->with(['project', 'task', 'reportedBy', 'assignedTo'])
            ->orderBy('reported_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $criticalIssues,
        ]);
    }

    /**
     * @OA\Get(
     *     path="/issues/my-assigned",
     *     summary="Problèmes assignés à l'utilisateur connecté",
     *     tags={"Problèmes"},
     *     @OA\Response(
     *         response=200,
     *         description="Problèmes assignés",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function myAssigned(): JsonResponse
    {
        $myIssues = Issue::where('assigned_to', Auth::id())
            ->where('status', '!=', 'resolved')
            ->with(['project', 'task', 'reportedBy'])
            ->orderBy('priority', 'desc')
            ->orderBy('reported_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $myIssues,
        ]);
    }
}
