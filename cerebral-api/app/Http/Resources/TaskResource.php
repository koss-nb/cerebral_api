<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Carbon\Carbon;

class TaskResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'description' => $this->description,
            'project' => [
                'id' => $this->whenLoaded('project', function () {
                    return $this->project->id;
                }),
                'name' => $this->whenLoaded('project', function () {
                    return $this->project->name;
                }),
            ],
            'assigned_to' => [
                'id' => $this->whenLoaded('assignedTo', function () {
                    return $this->assignedTo->id;
                }),
                'name' => $this->whenLoaded('assignedTo', function () {
                    return $this->assignedTo->full_name;
                }),
                'email' => $this->whenLoaded('assignedTo', function () {
                    return $this->assignedTo->email;
                }),
                'avatar' => $this->whenLoaded('assignedTo', function () {
                    return $this->assignedTo->avatar;
                }),
            ],
            'status' => [
                'value' => $this->status,
                'label' => $this->getStatusLabel(),
                'color' => $this->getStatusColor(),
                'icon' => $this->getStatusIcon()
            ],
            'priority' => [
                'value' => $this->priority,
                'label' => $this->getPriorityLabel(),
                'color' => $this->getPriorityColor(),
                'icon' => $this->getPriorityIcon()
            ],
            'type' => [
                'value' => $this->type,
                'label' => $this->getTypeLabel(),
                'color' => $this->getTypeColor()
            ],
            'time_tracking' => [
                'estimated_hours' => $this->estimated_hours,
                'actual_hours' => $this->actual_hours,
                'remaining_hours' => $this->getRemainingHours(),
                'time_spent_percentage' => $this->getTimeSpentPercentage(),
                'is_overdue' => $this->isOverdue(),
            ],
            'dates' => [
                'start_date' => $this->start_date ? Carbon::parse($this->start_date)->format('Y-m-d') : null,
                'due_date' => $this->due_date ? Carbon::parse($this->due_date)->format('Y-m-d') : null,
                'completed_at' => $this->completed_at ? Carbon::parse($this->completed_at)->format('Y-m-d H:i:s') : null,
                'days_remaining' => $this->getDaysRemaining(),
                'is_overdue' => $this->isOverdue(),
            ],
            'progress' => [
                'percentage' => $this->progress ?? 0,
                'label' => ($this->progress ?? 0) . '%',
                'color' => $this->getProgressColor(),
                'status' => $this->getProgressStatus()
            ],
            'metadata' => [
                'tags' => $this->tags ?? [],
                'is_urgent' => $this->is_urgent ?? false,
                'is_recurring' => $this->is_recurring ?? false,
                'recurrence_pattern' => $this->recurrence_pattern,
                'dependencies_count' => $this->whenLoaded('dependencies', function () {
                    return $this->dependencies->count();
                }),
                'attachments_count' => $this->attachments ? count($this->attachments) : 0,
            ],
            'dependencies' => $this->whenLoaded('dependencies', function () {
                return $this->dependencies->map(function ($dependency) {
                    return [
                        'id' => $dependency->id,
                        'title' => $dependency->title,
                        'status' => $dependency->status,
                        'progress' => $dependency->progress
                    ];
                });
            }),
            'attachments' => $this->when($this->attachments, function () {
                return collect($this->attachments)->map(function ($attachment) {
                    return [
                        'filename' => basename($attachment),
                        'url' => asset('storage/' . $attachment),
                        'size' => $this->getFileSize($attachment),
                        'type' => pathinfo($attachment, PATHINFO_EXTENSION)
                    ];
                });
            }),
            'notes' => $this->notes,
            'created_at' => $this->created_at ? Carbon::parse($this->created_at)->format('Y-m-d H:i:s') : null,
            'updated_at' => $this->updated_at ? Carbon::parse($this->updated_at)->format('Y-m-d H:i:s') : null,
            'created_by' => $this->whenLoaded('creator', function () {
                return [
                    'id' => $this->creator->id,
                    'name' => $this->creator->full_name
                ];
            }),
            'permissions' => [
                'can_edit' => auth()->user()?->hasPermission('edit_tasks') || auth()->user()?->isAdmin(),
                'can_delete' => auth()->user()?->hasPermission('delete_tasks') || auth()->user()?->isAdmin(),
                'can_assign' => auth()->user()?->hasPermission('assign_tasks') || auth()->user()?->isAdmin(),
                'can_complete' => auth()->user()?->hasPermission('complete_tasks') || auth()->user()?->isAdmin()
            ]
        ];
    }

    /**
     * Obtenir le label du statut
     */
    private function getStatusLabel(): string
    {
        return match ($this->status) {
            'pending' => 'En attente',
            'in_progress' => 'En cours',
            'review' => 'En révision',
            'completed' => 'Terminée',
            'cancelled' => 'Annulée',
            default => 'Inconnu'
        };
    }

    /**
     * Obtenir la couleur du statut
     */
    private function getStatusColor(): string
    {
        return match ($this->status) {
            'pending' => 'gray',
            'in_progress' => 'blue',
            'review' => 'yellow',
            'completed' => 'green',
            'cancelled' => 'red',
            default => 'gray'
        };
    }

    /**
     * Obtenir l'icône du statut
     */
    private function getStatusIcon(): string
    {
        return match ($this->status) {
            'pending' => '⏳',
            'in_progress' => '🚀',
            'review' => '🔍',
            'completed' => '✅',
            'cancelled' => '❌',
            default => '❓'
        };
    }

    /**
     * Obtenir le label de la priorité
     */
    private function getPriorityLabel(): string
    {
        return match ($this->priority) {
            'low' => 'Basse',
            'medium' => 'Moyenne',
            'high' => 'Haute',
            'critical' => 'Critique',
            default => 'Inconnue'
        };
    }

    /**
     * Obtenir la couleur de la priorité
     */
    private function getPriorityColor(): string
    {
        return match ($this->priority) {
            'low' => 'gray',
            'medium' => 'blue',
            'high' => 'orange',
            'critical' => 'red',
            default => 'gray'
        };
    }

    /**
     * Obtenir l'icône de la priorité
     */
    private function getPriorityIcon(): string
    {
        return match ($this->priority) {
            'low' => '🟢',
            'medium' => '🟡',
            'high' => '🟠',
            'critical' => '🔴',
            default => '⚪'
        };
    }

    /**
     * Obtenir le label du type
     */
    private function getTypeLabel(): string
    {
        return match ($this->type) {
            'feature' => 'Fonctionnalité',
            'bug' => 'Correction',
            'improvement' => 'Amélioration',
            'documentation' => 'Documentation',
            'testing' => 'Test',
            default => 'Inconnu'
        };
    }

    /**
     * Obtenir la couleur du type
     */
    private function getTypeColor(): string
    {
        return match ($this->type) {
            'feature' => 'green',
            'bug' => 'red',
            'improvement' => 'blue',
            'documentation' => 'purple',
            'testing' => 'orange',
            default => 'gray'
        };
    }

    /**
     * Obtenir la couleur de la progression
     */
    private function getProgressColor(): string
    {
        $progress = $this->progress ?? 0;

        if ($progress >= 80) return 'green';
        if ($progress >= 60) return 'blue';
        if ($progress >= 40) return 'yellow';
        if ($progress >= 20) return 'orange';
        return 'red';
    }

    /**
     * Obtenir le statut de la progression
     */
    private function getProgressStatus(): string
    {
        $progress = $this->progress ?? 0;

        if ($progress === 0) return 'Non commencée';
        if ($progress < 25) return 'Débutée';
        if ($progress < 50) return 'En cours';
        if ($progress < 75) return 'Bien avancée';
        if ($progress < 100) return 'Presque terminée';
        return 'Terminée';
    }

    /**
     * Calculer les heures restantes
     */
    private function getRemainingHours(): float
    {
        if (!$this->estimated_hours) return 0;
        return max(0, $this->estimated_hours - ($this->actual_hours ?? 0));
    }

    /**
     * Calculer le pourcentage de temps passé
     */
    private function getTimeSpentPercentage(): float
    {
        if (!$this->estimated_hours) return 0;
        return min(100, (($this->actual_hours ?? 0) / $this->estimated_hours) * 100);
    }

    /**
     * Calculer les jours restants
     */
    private function getDaysRemaining(): int
    {
        if (!$this->due_date) return 0;

        $remaining = Carbon::now()->diffInDays($this->due_date, false);
        return max(0, $remaining);
    }

    /**
     * Vérifier si la tâche est en retard
     */
    private function isOverdue(): bool
    {
        if (!$this->due_date || $this->status === 'completed') return false;

        return Carbon::now()->isAfter($this->due_date);
    }

    /**
     * Obtenir la taille du fichier
     */
    private function getFileSize(string $path): string
    {
        $fullPath = storage_path('app/public/' . $path);

        if (!file_exists($fullPath)) return '0 B';

        $size = filesize($fullPath);
        $units = ['B', 'KB', 'MB', 'GB'];
        $i = 0;

        while ($size >= 1024 && $i < count($units) - 1) {
            $size /= 1024;
            $i++;
        }

        return round($size, 2) . ' ' . $units[$i];
    }
}
