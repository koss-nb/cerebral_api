<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class NotificationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $query = Notification::where('user_id', $user->id);

        // Filtres
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        // Tri par date de création (plus récent en premier)
        $query->orderBy('created_at', 'desc');

        $notifications = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $notifications->items(),
            'pagination' => [
                'current_page' => $notifications->currentPage(),
                'last_page' => $notifications->lastPage(),
                'per_page' => $notifications->perPage(),
                'total' => $notifications->total(),
            ],
        ]);
    }

    /**
     * Get unread notifications count.
     */
    public function unreadCount(Request $request): JsonResponse
    {
        $user = $request->user();
        $count = Notification::where('user_id', $user->id)
            ->where('status', 'unread')
            ->count();

        return response()->json([
            'success' => true,
            'data' => [
                'unread_count' => $count,
            ],
        ]);
    }

    /**
     * Mark notification as read.
     */
    public function markAsRead(Notification $notification): JsonResponse
    {
        // Vérifier que la notification appartient à l'utilisateur connecté
        if ($notification->user_id !== auth()->id()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized access to notification',
            ], 403);
        }

        $notification->markAsRead();

        return response()->json([
            'success' => true,
            'message' => 'Notification marked as read',
            'data' => $notification,
        ]);
    }

    /**
     * Mark all notifications as read.
     */
    public function markAllAsRead(Request $request): JsonResponse
    {
        $user = $request->user();

        Notification::where('user_id', $user->id)
            ->where('status', 'unread')
            ->update([
                'status' => 'read',
                'read_at' => now(),
            ]);

        return response()->json([
            'success' => true,
            'message' => 'All notifications marked as read',
        ]);
    }

    /**
     * Mark notification as archived.
     */
    public function archive(Notification $notification): JsonResponse
    {
        // Vérifier que la notification appartient à l'utilisateur connecté
        if ($notification->user_id !== auth()->id()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized access to notification',
            ], 403);
        }

        $notification->update(['status' => 'archived']);

        return response()->json([
            'success' => true,
            'message' => 'Notification archived',
            'data' => $notification,
        ]);
    }

    /**
     * Delete notification.
     */
    public function destroy(Notification $notification): JsonResponse
    {
        // Vérifier que la notification appartient à l'utilisateur connecté
        if ($notification->user_id !== auth()->id()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized access to notification',
            ], 403);
        }

        $notification->delete();

        return response()->json([
            'success' => true,
            'message' => 'Notification deleted successfully',
        ]);
    }

    /**
     * Get notification types.
     */
    public function types(): JsonResponse
    {
        $types = [
            'task_assigned' => 'Tâche assignée',
            'project_update' => 'Mise à jour du projet',
            'deadline_reminder' => 'Rappel de deadline',
            'budget_alert' => 'Alerte budget',
            'status_change' => 'Changement de statut',
            'comment_added' => 'Commentaire ajouté',
            'file_uploaded' => 'Fichier téléchargé',
            'approval_required' => 'Approbation requise',
            'system_alert' => 'Alerte système',
        ];

        return response()->json([
            'success' => true,
            'data' => $types,
        ]);
    }

    /**
     * Get notification preferences.
     */
    public function preferences(Request $request): JsonResponse
    {
        $user = $request->user();
        $preferences = $user->preferences['notifications'] ?? [
            'email' => true,
            'push' => true,
            'sms' => false,
            'types' => [
                'task_assigned' => true,
                'project_update' => true,
                'deadline_reminder' => true,
                'budget_alert' => true,
                'status_change' => true,
                'comment_added' => false,
                'file_uploaded' => false,
                'approval_required' => true,
                'system_alert' => true,
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $preferences,
        ]);
    }

    /**
     * Update notification preferences.
     */
    public function updatePreferences(Request $request): JsonResponse
    {
        $user = $request->user();

        $request->validate([
            'email' => 'boolean',
            'push' => 'boolean',
            'sms' => 'boolean',
            'types' => 'array',
            'types.*' => 'boolean',
        ]);

        $currentPreferences = $user->preferences ?? [];
        $currentPreferences['notifications'] = $request->all();

        $user->update(['preferences' => $currentPreferences]);

        return response()->json([
            'success' => true,
            'message' => 'Notification preferences updated successfully',
            'data' => $currentPreferences['notifications'],
        ]);
    }

    /**
     * Send test notification.
     */
    public function sendTest(Request $request): JsonResponse
    {
        $user = $request->user();

        $notification = Notification::create([
            'type' => 'system_alert',
            'title' => 'Notification de test',
            'message' => 'Ceci est une notification de test pour vérifier le système.',
            'user_id' => $user->id,
            'status' => 'unread',
            'data' => [
                'test' => true,
                'timestamp' => now()->toISOString(),
            ],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Test notification sent successfully',
            'data' => $notification,
        ]);
    }

    /**
     * Get notification statistics.
     */
    public function stats(Request $request): JsonResponse
    {
        $user = $request->user();

        $stats = [
            'total' => Notification::where('user_id', $user->id)->count(),
            'unread' => Notification::where('user_id', $user->id)
                ->where('status', 'unread')
                ->count(),
            'read' => Notification::where('user_id', $user->id)
                ->where('status', 'read')
                ->count(),
            'archived' => Notification::where('user_id', $user->id)
                ->where('status', 'archived')
                ->count(),
            'by_type' => Notification::where('user_id', $user->id)
                ->selectRaw('type, COUNT(*) as count')
                ->groupBy('type')
                ->pluck('count', 'type'),
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }
}
