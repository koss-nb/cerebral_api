<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Carbon\Carbon;

class PersonnelResource extends JsonResource
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
            'personal_info' => [
                'first_name' => $this->first_name,
                'last_name' => $this->last_name,
                'full_name' => $this->full_name,
                'display_name' => $this->display_name,
                'initials' => $this->initials,
                'email' => $this->email,
                'phone' => $this->phone,
                'date_of_birth' => $this->date_of_birth ? Carbon::parse($this->date_of_birth)->format('Y-m-d') : null,
                'age' => $this->age,
                'gender' => [
                    'value' => $this->gender,
                    'label' => $this->getGenderLabel(),
                ],
                'marital_status' => [
                    'value' => $this->marital_status,
                    'label' => $this->getMaritalStatusLabel(),
                ],
                'nationality' => $this->nationality,
            ],
            'professional_info' => [
                'employee_id' => $this->employee_id,
                'position' => $this->position,
                'department' => $this->department,
                'hire_date' => $this->hire_date ? Carbon::parse($this->hire_date)->format('Y-m-d') : null,
                'tenure_years' => $this->tenure_years,
                'is_on_probation' => $this->is_on_probation,
                'contract_type' => [
                    'value' => $this->contract_type,
                    'label' => $this->getContractTypeLabel(),
                    'color' => $this->getContractTypeColor(),
                ],
                'work_schedule' => $this->work_schedule,
                'overtime_eligible' => $this->overtime_eligible,
                'remote_work_allowed' => $this->remote_work_allowed,
            ],
            'compensation' => [
                'salary' => [
                    'amount' => $this->salary,
                    'formatted' => $this->salary ? number_format($this->salary, 2, ',', ' ') . ' €' : null,
                    'currency' => 'EUR'
                ],
                'performance_rating' => [
                    'value' => $this->performance_rating,
                    'label' => $this->performance_rating ? $this->performance_rating . '/5' : 'Non évalué',
                    'color' => $this->getPerformanceColor(),
                ],
            ],
            'status' => [
                'value' => $this->status,
                'label' => $this->getStatusLabel(),
                'color' => $this->getStatusColor(),
                'icon' => $this->getStatusIcon(),
                'is_active' => $this->is_active,
            ],
            'skills_and_certifications' => [
                'skills' => $this->skills ?? [],
                'certifications' => $this->certifications ?? [],
                'languages' => $this->languages ?? [],
                'skills_count' => $this->skills ? count($this->skills) : 0,
                'certifications_count' => $this->certifications ? count($this->certifications) : 0,
                'languages_count' => $this->languages ? count($this->languages) : 0,
            ],
            'location' => [
                'address' => $this->address,
                'city' => $this->city,
                'postal_code' => $this->postal_code,
                'country' => $this->country,
                'full_address' => $this->getFullAddress(),
            ],
            'emergency_contact' => $this->emergency_contact ? [
                'name' => $this->emergency_contact['name'] ?? null,
                'phone' => $this->emergency_contact['phone'] ?? null,
                'relationship' => $this->emergency_contact['relationship'] ?? null,
            ] : null,
            'manager' => $this->whenLoaded('manager', function() {
                return [
                    'id' => $this->manager->id,
                    'name' => $this->manager->full_name,
                    'position' => $this->manager->position,
                    'email' => $this->manager->email,
                ];
            }),
            'subordinates' => $this->whenLoaded('subordinates', function() {
                return $this->subordinates->map(function($subordinate) {
                    return [
                        'id' => $subordinate->id,
                        'name' => $subordinate->full_name,
                        'position' => $subordinate->position,
                        'status' => $subordinate->status,
                    ];
                });
            }),
            'subordinates_count' => $this->whenLoaded('subordinates', function() {
                return $this->subordinates->count();
            }),
            'documents' => $this->when($this->documents, function() {
                return collect($this->documents)->map(function($document) {
                    return [
                        'filename' => basename($document),
                        'url' => asset('storage/' . $document),
                        'type' => pathinfo($document, PATHINFO_EXTENSION)
                    ];
                });
            }),
            'avatar' => $this->avatar ? [
                'url' => asset('storage/' . $this->avatar),
                'filename' => basename($this->avatar),
            ] : null,
            'notes' => $this->notes,
            'created_at' => $this->created_at ? Carbon::parse($this->created_at)->format('Y-m-d H:i:s') : null,
            'updated_at' => $this->updated_at ? Carbon::parse($this->updated_at)->format('Y-m-d H:i:s') : null,
            'created_by' => $this->whenLoaded('creator', function() {
                return [
                    'id' => $this->creator->id,
                    'name' => $this->creator->full_name,
                    'email' => $this->creator->email,
                ];
            }),
            'permissions' => [
                'can_edit' => auth()->user()?->hasPermission('edit_personnel') || auth()->user()?->isAdmin(),
                'can_delete' => auth()->user()?->hasPermission('delete_personnel') || auth()->user()?->isAdmin(),
                'can_manage' => auth()->user()?->hasPermission('manage_personnel') || auth()->user()?->isAdmin(),
                'can_view_salary' => auth()->user()?->hasPermission('view_salaries') || auth()->user()?->isAdmin(),
            ]
        ];
    }

    /**
     * Obtenir le label du genre
     */
    private function getGenderLabel(): string
    {
        return match($this->gender) {
            'male' => 'Homme',
            'female' => 'Femme',
            'other' => 'Autre',
            'prefer_not_to_say' => 'Préfère ne pas dire',
            default => 'Non spécifié'
        };
    }

    /**
     * Obtenir le label du statut marital
     */
    private function getMaritalStatusLabel(): string
    {
        return match($this->marital_status) {
            'single' => 'Célibataire',
            'married' => 'Marié(e)',
            'divorced' => 'Divorcé(e)',
            'widowed' => 'Veuf/Veuve',
            default => 'Non spécifié'
        };
    }

    /**
     * Obtenir le label du type de contrat
     */
    private function getContractTypeLabel(): string
    {
        return match($this->contract_type) {
            'full_time' => 'Temps plein',
            'part_time' => 'Temps partiel',
            'contract' => 'Contrat',
            'intern' => 'Stage',
            'temporary' => 'Temporaire',
            default => 'Non spécifié'
        };
    }

    /**
     * Obtenir la couleur du type de contrat
     */
    private function getContractTypeColor(): string
    {
        return match($this->contract_type) {
            'full_time' => 'green',
            'part_time' => 'blue',
            'contract' => 'orange',
            'intern' => 'yellow',
            'temporary' => 'red',
            default => 'gray'
        };
    }

    /**
     * Obtenir le label du statut
     */
    private function getStatusLabel(): string
    {
        return match($this->status) {
            'active' => 'Actif',
            'inactive' => 'Inactif',
            'on_leave' => 'En congé',
            'terminated' => 'Terminé',
            default => 'Inconnu'
        };
    }

    /**
     * Obtenir la couleur du statut
     */
    private function getStatusColor(): string
    {
        return match($this->status) {
            'active' => 'green',
            'inactive' => 'gray',
            'on_leave' => 'yellow',
            'terminated' => 'red',
            default => 'gray'
        };
    }

    /**
     * Obtenir l'icône du statut
     */
    private function getStatusIcon(): string
    {
        return match($this->status) {
            'active' => '✅',
            'inactive' => '⏸️',
            'on_leave' => '🏖️',
            'terminated' => '❌',
            default => '❓'
        };
    }

    /**
     * Obtenir la couleur de la performance
     */
    private function getPerformanceColor(): string
    {
        if (!$this->performance_rating) return 'gray';
        
        if ($this->performance_rating >= 4.5) return 'green';
        if ($this->performance_rating >= 4.0) return 'blue';
        if ($this->performance_rating >= 3.5) return 'yellow';
        if ($this->performance_rating >= 3.0) return 'orange';
        return 'red';
    }

    /**
     * Obtenir l'adresse complète
     */
    private function getFullAddress(): string
    {
        $parts = [];
        
        if ($this->address) $parts[] = $this->address;
        if ($this->postal_code) $parts[] = $this->postal_code;
        if ($this->city) $parts[] = $this->city;
        if ($this->country) $parts[] = $this->country;
        
        return implode(', ', $parts);
    }
}
