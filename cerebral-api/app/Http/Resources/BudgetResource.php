<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Carbon\Carbon;

class BudgetResource extends JsonResource
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
            'project' => [
                'id' => $this->whenLoaded('project', function() {
                    return $this->project->id;
                }),
                'name' => $this->whenLoaded('project', function() {
                    return $this->project->name;
                }),
            ],
            'basic_info' => [
                'category' => $this->category,
                'description' => $this->description,
                'type' => [
                    'value' => $this->type,
                    'label' => $this->getTypeLabel(),
                    'color' => $this->getTypeColor(),
                    'is_income' => $this->is_income,
                    'is_expense' => $this->is_expense,
                ],
                'status' => [
                    'value' => $this->status,
                    'label' => $this->getStatusLabel(),
                    'color' => $this->getStatusColor(),
                    'icon' => $this->getStatusIcon(),
                ],
            ],
            'financial_details' => [
                'amount' => [
                    'value' => $this->amount,
                    'formatted' => $this->formatted_amount,
                    'currency' => $this->currency,
                ],
                'total_amount' => [
                    'value' => $this->total_amount,
                    'formatted' => $this->formatted_total_amount,
                    'currency' => $this->currency,
                ],
                'remaining_amount' => [
                    'value' => $this->remaining_amount,
                    'formatted' => $this->getFormattedRemainingAmount(),
                    'currency' => $this->currency,
                ],
                'tax_rate' => $this->tax_rate,
                'tax_amount' => $this->tax_amount,
                'discount_percentage' => $this->discount_percentage,
                'discount_amount' => $this->discount_amount,
            ],
            'timeline' => [
                'fiscal_year' => $this->fiscal_year,
                'period' => [
                    'value' => $this->period,
                    'label' => $this->getPeriodLabel(),
                ],
                'start_date' => $this->start_date ? Carbon::parse($this->start_date)->format('Y-m-d') : null,
                'end_date' => $this->end_date ? Carbon::parse($this->end_date)->format('Y-m-d') : null,
                'due_date' => $this->due_date ? Carbon::parse($this->due_date)->format('Y-m-d') : null,
                'is_overdue' => $this->is_overdue,
                'next_review_date' => $this->next_review_date ? Carbon::parse($this->next_review_date)->format('Y-m-d') : null,
                'review_frequency' => $this->review_frequency,
            ],
            'approval_info' => [
                'is_approved' => $this->is_approved,
                'approved_at' => $this->approved_at ? Carbon::parse($this->approved_at)->format('Y-m-d H:i:s') : null,
                'approved_by' => $this->whenLoaded('approvedBy', function() {
                    return [
                        'id' => $this->approvedBy->id,
                        'name' => $this->approvedBy->full_name,
                        'email' => $this->approvedBy->email,
                    ];
                }),
                'approval_workflow' => $this->approval_workflow,
            ],
            'execution_info' => [
                'is_executed' => $this->is_executed,
                'execution_date' => $this->execution_date ? Carbon::parse($this->execution_date)->format('Y-m-d H:i:s') : null,
                'execution_notes' => $this->execution_notes,
                'variance_amount' => $this->variance_amount,
                'variance_percentage' => $this->variance_percentage,
                'efficiency' => $this->efficiency,
            ],
            'risk_management' => [
                'risk_level' => [
                    'value' => $this->risk_level,
                    'label' => $this->getRiskLevelLabel(),
                    'color' => $this->getRiskLevelColor(),
                ],
                'contingency_amount' => $this->contingency_amount,
                'contingency_percentage' => $this->contingency_percentage,
                'justification' => $this->justification,
            ],
            'payment_details' => [
                'payment_method' => $this->payment_method,
                'payment_terms' => $this->payment_terms,
                'vendor_supplier' => $this->vendor_supplier,
                'invoice_number' => $this->invoice_number,
                'reference_number' => $this->reference_number,
            ],
            'recurrence' => [
                'is_recurring' => $this->is_recurring,
                'pattern' => $this->recurrence_pattern,
                'end_date' => $this->recurrence_end_date ? Carbon::parse($this->recurrence_end_date)->format('Y-m-d') : null,
            ],
            'line_items' => $this->when($this->budget_line_items, function() {
                return collect($this->budget_line_items)->map(function($item) {
                    return [
                        'description' => $item['description'] ?? null,
                        'amount' => $item['amount'] ?? null,
                        'category' => $item['category'] ?? null,
                        'quantity' => $item['quantity'] ?? null,
                        'unit_price' => $item['unit_price'] ?? null,
                    ];
                });
            }),
            'metadata' => [
                'tags' => $this->tags ?? [],
                'attachments' => $this->when($this->attachments, function() {
                    return collect($this->attachments)->map(function($attachment) {
                        return [
                            'filename' => basename($attachment),
                            'url' => asset('storage/' . $attachment),
                            'type' => pathinfo($attachment, PATHINFO_EXTENSION)
                        ];
                    });
                }),
                'notes' => $this->notes,
            ],
            'exchange_info' => [
                'exchange_rate' => $this->exchange_rate,
                'base_currency' => $this->base_currency,
            ],
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
                'can_edit' => auth()->user()?->hasPermission('edit_budgets') || auth()->user()?->isAdmin(),
                'can_delete' => auth()->user()?->hasPermission('delete_budgets') || auth()->user()?->isAdmin(),
                'can_approve' => auth()->user()?->hasPermission('approve_budgets') || auth()->user()?->isAdmin(),
                'can_execute' => auth()->user()?->hasPermission('execute_budgets') || auth()->user()?->isAdmin(),
                'can_view_financial' => auth()->user()?->hasPermission('view_financial_data') || auth()->user()?->isAdmin(),
            ]
        ];
    }

    /**
     * Obtenir le label du type
     */
    private function getTypeLabel(): string
    {
        return match($this->type) {
            'income' => 'Revenus',
            'expense' => 'Dépenses',
            'investment' => 'Investissement',
            'loan' => 'Prêt',
            'revenue' => 'Chiffre d\'affaires',
            'cost' => 'Coût',
            default => 'Inconnu'
        };
    }

    /**
     * Obtenir la couleur du type
     */
    private function getTypeColor(): string
    {
        return match($this->type) {
            'income', 'revenue' => 'green',
            'expense', 'cost' => 'red',
            'investment' => 'blue',
            'loan' => 'orange',
            default => 'gray'
        };
    }

    /**
     * Obtenir le label du statut
     */
    private function getStatusLabel(): string
    {
        return match($this->status) {
            'planned' => 'Planifié',
            'approved' => 'Approuvé',
            'pending' => 'En attente',
            'rejected' => 'Rejeté',
            'executed' => 'Exécuté',
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
            'planned' => 'blue',
            'approved' => 'green',
            'pending' => 'yellow',
            'rejected' => 'red',
            'executed' => 'purple',
            'cancelled' => 'gray',
            default => 'gray'
        };
    }

    /**
     * Obtenir l'icône du statut
     */
    private function getStatusIcon(): string
    {
        return match($this->status) {
            'planned' => '📋',
            'approved' => '✅',
            'pending' => '⏳',
            'rejected' => '❌',
            'executed' => '🎯',
            'cancelled' => '🚫',
            default => '❓'
        };
    }

    /**
     * Obtenir le label de la période
     */
    private function getPeriodLabel(): string
    {
        return match($this->period) {
            'monthly' => 'Mensuel',
            'quarterly' => 'Trimestriel',
            'yearly' => 'Annuel',
            'custom' => 'Personnalisé',
            default => 'Inconnu'
        };
    }

    /**
     * Obtenir le label du niveau de risque
     */
    private function getRiskLevelLabel(): string
    {
        return match($this->risk_level) {
            'low' => 'Faible',
            'medium' => 'Moyen',
            'high' => 'Élevé',
            'critical' => 'Critique',
            default => 'Non défini'
        };
    }

    /**
     * Obtenir la couleur du niveau de risque
     */
    private function getRiskLevelColor(): string
    {
        return match($this->risk_level) {
            'low' => 'green',
            'medium' => 'yellow',
            'high' => 'orange',
            'critical' => 'red',
            default => 'gray'
        };
    }

    /**
     * Obtenir le montant restant formaté
     */
    private function getFormattedRemainingAmount(): string
    {
        if (!$this->remaining_amount) return '0,00 ' . $this->currency;
        return number_format($this->remaining_amount, 2, ',', ' ') . ' ' . $this->currency;
    }
}
