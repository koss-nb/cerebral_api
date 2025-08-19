<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TimeTracking;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class TimeTrackingController extends Controller
{
    /**
     * @OA\Post(
     *     path="/time-tracking/clock-in",
     *     summary="Pointer l'arrivée",
     *     tags={"Pointage"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"project_id"},
     *             @OA\Property(property="project_id", type="integer", example=1, description="ID du projet"),
     *             @OA\Property(property="notes", type="string", example="Arrivée sur le chantier", description="Notes optionnelles"),
     *             @OA\Property(property="location", type="string", example="Villa A3", description="Localisation optionnelle")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Pointage d'arrivée enregistré",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Pointage d'arrivée enregistré"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function clockIn(Request $request): JsonResponse
    {
        $request->validate([
            'project_id' => 'required|exists:projects,id',
            'notes' => 'nullable|string|max:500',
            'location' => 'nullable|string|max:255',
        ]);

        // Vérifier qu'il n'y a pas déjà un pointage actif
        $activeTracking = TimeTracking::where('user_id', Auth::id())
            ->where('status', 'active')
            ->whereNull('clock_out')
            ->first();

        if ($activeTracking) {
            throw ValidationException::withMessages([
                'clock_in' => 'Vous avez déjà un pointage actif. Veuillez pointer votre départ d\'abord.'
            ]);
        }

        $timeTracking = TimeTracking::create([
            'user_id' => Auth::id(),
            'project_id' => $request->project_id,
            'clock_in' => now(),
            'notes' => $request->notes,
            'location' => $request->location,
            'status' => 'active',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Pointage d\'arrivée enregistré',
            'data' => $timeTracking->load(['user', 'project']),
        ]);
    }

    /**
     * @OA\Post(
     *     path="/time-tracking/clock-out",
     *     summary="Pointer le départ",
     *     tags={"Pointage"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="notes", type="string", example="Fin de journée", description="Notes optionnelles")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Pointage de départ enregistré",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Pointage de départ enregistré"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function clockOut(Request $request): JsonResponse
    {
        $request->validate([
            'notes' => 'nullable|string|max:500',
        ]);

        $activeTracking = TimeTracking::where('user_id', Auth::id())
            ->where('status', 'active')
            ->whereNull('clock_out')
            ->first();

        if (!$activeTracking) {
            throw ValidationException::withMessages([
                'clock_out' => 'Aucun pointage actif trouvé.'
            ]);
        }

        $activeTracking->update([
            'clock_out' => now(),
            'status' => 'completed',
            'notes' => $request->notes ? $activeTracking->notes . "\n" . $request->notes : $activeTracking->notes,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Pointage de départ enregistré',
            'data' => $activeTracking->load(['user', 'project']),
        ]);
    }

    /**
     * @OA\Get(
     *     path="/time-tracking/history",
     *     summary="Historique des pointages",
     *     tags={"Pointage"},
     *     @OA\Parameter(
     *         name="user_id",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="integer"),
     *         description="ID de l'utilisateur (optionnel)"
     *     ),
     *     @OA\Parameter(
     *         name="project_id",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="integer"),
     *         description="ID du projet (optionnel)"
     *     ),
     *     @OA\Parameter(
     *         name="date",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="string", format="date"),
     *         description="Date spécifique (optionnel)"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Historique des pointages",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="array", @OA\Items(type="object"))
     *         )
     *     )
     * )
     */
    public function history(Request $request): JsonResponse
    {
        $query = TimeTracking::with(['user', 'project']);

        if ($request->user_id) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->project_id) {
            $query->where('project_id', $request->project_id);
        }

        if ($request->date) {
            $query->whereDate('clock_in', $request->date);
        }

        $timeTrackings = $query->orderBy('clock_in', 'desc')->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $timeTrackings,
        ]);
    }

    /**
     * @OA\Get(
     *     path="/time-tracking/team-status",
     *     summary="Statut de l'équipe",
     *     tags={"Pointage"},
     *     @OA\Parameter(
     *         name="project_id",
     *         in="query",
     *         required=false,
     *         @OA\Schema(type="integer"),
     *         description="ID du projet (optionnel)"
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Statut de l'équipe",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function teamStatus(Request $request): JsonResponse
    {
        $query = TimeTracking::with(['user', 'project'])
            ->where('status', 'active')
            ->whereNull('clock_out');

        if ($request->project_id) {
            $query->where('project_id', $request->project_id);
        }

        $activeUsers = $query->get();

        $teamStatus = [
            'total_active' => $activeUsers->count(),
            'users' => $activeUsers->map(function ($tracking) {
                return [
                    'user_id' => $tracking->user_id,
                    'user_name' => $tracking->user->first_name . ' ' . $tracking->user->last_name,
                    'project_id' => $tracking->project_id,
                    'project_name' => $tracking->project->name ?? 'N/A',
                    'clock_in' => $tracking->clock_in,
                    'location' => $tracking->location,
                    'duration' => $tracking->clock_in->diffInHours(now(), true),
                ];
            }),
        ];

        return response()->json([
            'success' => true,
            'data' => $teamStatus,
        ]);
    }

    /**
     * @OA\Get(
     *     path="/time-tracking/current",
     *     summary="Pointage actuel de l'utilisateur",
     *     tags={"Pointage"},
     *     @OA\Response(
     *         response=200,
     *         description="Pointage actuel",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function current(): JsonResponse
    {
        $currentTracking = TimeTracking::with(['project'])
            ->where('user_id', Auth::id())
            ->where('status', 'active')
            ->whereNull('clock_out')
            ->first();

        if (!$currentTracking) {
            return response()->json([
                'success' => true,
                'data' => null,
                'message' => 'Aucun pointage actif',
            ]);
        }

        return response()->json([
            'success' => true,
            'data' => $currentTracking,
        ]);
    }
}
