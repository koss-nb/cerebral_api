<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Carbon\Carbon;

class ProjectResource extends JsonResource
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
            'name' => $this->name,
            'description' => $this->description,
            'start_date' => $this->start_date ? Carbon::parse($this->start_date)->format('Y-m-d') : null,
            'end_date' => $this->end_date ? Carbon::parse($this->end_date)->format('Y-m-d') : null,
            'budget' => [
                'amount' => $this->budget,
                'formatted' => number_format($this->budget, 2, ',', ' ') . ' €',
                'currency' => 'EUR'
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
            'client' => [
                'name' => $this->client_name,
                'email' => $this->client_email,
                'phone' => $this->client_phone
            ],
            'location' => $this->location,
            'progress' => [
                'percentage' => $this->progress ?? 0,
                'label' => ($this->progress ?? 0) . '%',
                'color' => $this->getProgressColor()
            ],
            'timeline' => [
                'total_days' => $this->getTotalDays(),
                'remaining_days' => $this->getRemainingDays(),
                'is_overdue' => $this->isOverdue(),
                'is_completed' => $this->status === 'completed'
            ],
            'team' => [
                'manager' => $this->whenLoaded('manager', function() {
                    return [
                        'id' => $this->manager->id,
                        'name' => $this->manager->full_name,
                        'email' => $this->manager->email,
                        'role' => $this->manager->role
                    ];
                }),
                'members_count' => $this->team_members ? count($this->team_members) : 0,
                'members' => $this->whenLoaded('teamMembers', function() {
                    return $this->teamMembers->map(function($member) {
                        return [
                            'id' => $member->id,
                            'name' => $member->full_name,
                            'email' => $member->email,
                            'role' => $member->role
                        ];
                    });
                })
            ],
            'statistics' => [
                'tasks_count' => $this->whenLoaded('tasks', function() {
                    return $this->tasks->count();
                }),
                'completed_tasks' => $this->whenLoaded('tasks', function() {
                    return $this->tasks->where('status', 'completed')->count();
                }),
                'budget_used' => $this->whenLoaded('budgets', function() {
                    return $this->budgets->sum('amount');
                }),
                'budget_remaining' => $this->budget - ($this->whenLoaded('budgets', function() {
                    return $this->budgets->sum('amount');
                }) ?? 0)
            ],
            'tags' => $this->tags ?? [],
            'attachments' => $this->when($this->attachments, function() {
                return collect($this->attachments)->map(function($attachment) {
                    return [
                        'filename' => basename($attachment),
                        'url' => asset('storage/' . $attachment),
                        'size' => $this->getFileSize($attachment),
                        'type' => pathinfo($attachment, PATHINFO_EXTENSION)
                    ];
                });
            }),
            'created_at' => $this->created_at ? Carbon::parse($this->created_at)->format('Y-m-d H:i:s') : null,
            'updated_at' => $this->updated_at ? Carbon::parse($this->updated_at)->format('Y-m-d H:i:s') : null,
            'created_by' => $this->whenLoaded('creator', function() {
                return [
                    'id' => $this->creator->id,
                    'name' => $this->creator->full_name
                ];
            }),
            'permissions' => [
                'can_edit' => auth()->user()?->hasPermission('edit_projects') || auth()->user()?->isAdmin(),
                'can_delete' => auth()->user()?->hasPermission('delete_projects') || auth()->user()?->isAdmin(),
                'can_manage_team' => auth()->user()?->hasPermission('manage_teams') || auth()->user()?->isAdmin()
            ]
        ];
    }

    /**
     * Obtenir le label du statut
     */
    private function getStatusLabel(): string
    {
        return match($this->status) {
            'planning' => 'En planification',
            'in_progress' => 'En cours',
            'on_hold' => 'En attente',
            'completed' => 'Terminé',
            'cancelled' => 'Annulé',
            default => 'Inconnu'
        };
    }

    /**
     * Obtenir la couleur du statut
     */
    private function getStatusColor(): string
    {
        return match($this->status) {
            'planning' => 'blue',
            'in_progress' => 'green',
            'on_hold' => 'yellow',
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
        return match($this->status) {
            'planning' => '📋',
            'in_progress' => '🚀',
            'on_hold' => '⏸️',
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
        return match($this->priority) {
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
        return match($this->priority) {
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
        return match($this->priority) {
            'low' => '🟢',
            'medium' => '🟡',
            'high' => '🟠',
            'critical' => '🔴',
            default => '⚪'
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
     * Calculer le nombre total de jours
     */
    private function getTotalDays(): int
    {
        if (!$this->start_date || !$this->end_date) return 0;
        
        return Carbon::parse($this->start_date)->diffInDays($this->end_date) + 1;
    }

    /**
     * Calculer le nombre de jours restants
     */
    private function getRemainingDays(): int
    {
        if (!$this->end_date) return 0;
        
        $remaining = Carbon::now()->diffInDays($this->end_date, false);
        return max(0, $remaining);
    }

    /**
     * Vérifier si le projet est en retard
     */
    private function isOverdue(): bool
    {
        if (!$this->end_date || $this->status === 'completed') return false;
        
        return Carbon::now()->isAfter($this->end_date);
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
