<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class BudgetRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true; // L'autorisation est gérée par le middleware
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        $budgetId = $this->route('budget');
        
        return [
            'project_id' => 'required|exists:projects,id',
            'category' => 'required|string|max:255',
            'description' => 'required|string|min:10|max:1000',
            'amount' => 'required|numeric|min:0.01|max:999999999.99',
            'currency' => 'required|string|max:3|in:EUR,USD,GBP,JPY,CHF,CAD,AUD',
            'type' => 'required|in:income,expense,investment,loan,revenue,cost',
            'status' => 'required|in:planned,approved,pending,rejected,executed,cancelled',
            'fiscal_year' => 'required|integer|min:2020|max:2030',
            'period' => 'required|in:monthly,quarterly,yearly,custom',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after:start_date',
            'approved_by' => 'nullable|exists:users,id',
            'approved_at' => 'nullable|date|after_or_equal:start_date',
            'payment_method' => 'nullable|string|max:100',
            'payment_terms' => 'nullable|string|max:255',
            'due_date' => 'nullable|date|after:start_date',
            'vendor_supplier' => 'nullable|string|max:255',
            'invoice_number' => 'nullable|string|max:100',
            'reference_number' => 'nullable|string|max:100',
            'tags' => 'array',
            'tags.*' => 'string|max:50',
            'attachments' => 'array',
            'attachments.*' => 'file|mimes:pdf,doc,docx,xls,xlsx,jpg,jpeg,png|max:10240',
            'notes' => 'nullable|string|max:2000',
            'is_recurring' => 'boolean',
            'recurrence_pattern' => 'nullable|string|in:daily,weekly,monthly,quarterly,yearly',
            'recurrence_end_date' => 'nullable|date|after:end_date',
            'budget_line_items' => 'array',
            'budget_line_items.*.description' => 'required|string|max:255',
            'budget_line_items.*.amount' => 'required|numeric|min:0.01',
            'budget_line_items.*.category' => 'required|string|max:100',
            'budget_line_items.*.quantity' => 'nullable|numeric|min:1',
            'budget_line_items.*.unit_price' => 'nullable|numeric|min:0.01',
            'risk_level' => 'nullable|in:low,medium,high,critical',
            'contingency_amount' => 'nullable|numeric|min:0|max:999999999.99',
            'contingency_percentage' => 'nullable|numeric|min:0|max:100',
            'exchange_rate' => 'nullable|numeric|min:0.0001|max:10000',
            'base_currency' => 'nullable|string|max:3|in:EUR,USD,GBP,JPY,CHF,CAD,AUD',
            'tax_rate' => 'nullable|numeric|min:0|max:100',
            'tax_amount' => 'nullable|numeric|min:0|max:999999999.99',
            'discount_percentage' => 'nullable|numeric|min:0|max:100',
            'discount_amount' => 'nullable|numeric|min:0|max:999999999.99',
            'total_amount' => 'nullable|numeric|min:0|max:999999999.99',
            'is_approved' => 'boolean',
            'is_executed' => 'boolean',
            'execution_date' => 'nullable|date|after_or_equal:approved_at',
            'execution_notes' => 'nullable|string|max:1000',
            'variance_amount' => 'nullable|numeric',
            'variance_percentage' => 'nullable|numeric|min:-100|max:100',
            'justification' => 'nullable|string|max:1000',
            'approval_workflow' => 'nullable|string|max:255',
            'next_review_date' => 'nullable|date|after:today',
            'review_frequency' => 'nullable|string|in:weekly,monthly,quarterly,yearly',
            'created_by' => 'required|exists:users,id',
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'project_id.required' => 'Le projet est obligatoire',
            'project_id.exists' => 'Le projet sélectionné n\'existe pas',
            'category.required' => 'La catégorie est obligatoire',
            'description.required' => 'La description est obligatoire',
            'description.min' => 'La description doit contenir au moins 10 caractères',
            'description.max' => 'La description ne doit pas dépasser 1000 caractères',
            'amount.required' => 'Le montant est obligatoire',
            'amount.numeric' => 'Le montant doit être un nombre',
            'amount.min' => 'Le montant doit être supérieur à 0',
            'amount.max' => 'Le montant ne doit pas dépasser 999999999.99',
            'currency.required' => 'La devise est obligatoire',
            'currency.in' => 'La devise doit être l\'une des suivantes: EUR, USD, GBP, JPY, CHF, CAD, AUD',
            'type.required' => 'Le type est obligatoire',
            'type.in' => 'Le type doit être l\'un des suivants: income, expense, investment, loan, revenue, cost',
            'status.required' => 'Le statut est obligatoire',
            'status.in' => 'Le statut doit être l\'un des suivants: planned, approved, pending, rejected, executed, cancelled',
            'fiscal_year.required' => 'L\'année fiscale est obligatoire',
            'fiscal_year.integer' => 'L\'année fiscale doit être un nombre entier',
            'fiscal_year.min' => 'L\'année fiscale doit être d\'au moins 2020',
            'fiscal_year.max' => 'L\'année fiscale ne doit pas dépasser 2030',
            'period.required' => 'La période est obligatoire',
            'period.in' => 'La période doit être l\'une des suivantes: monthly, quarterly, yearly, custom',
            'start_date.required' => 'La date de début est obligatoire',
            'start_date.date' => 'La date de début doit être une date valide',
            'end_date.required' => 'La date de fin est obligatoire',
            'end_date.date' => 'La date de fin doit être une date valide',
            'end_date.after' => 'La date de fin doit être après la date de début',
            'approved_by.exists' => 'L\'utilisateur approuvant n\'existe pas',
            'approved_at.date' => 'La date d\'approbation doit être une date valide',
            'approved_at.after_or_equal' => 'La date d\'approbation doit être égale ou après la date de début',
            'payment_method.max' => 'La méthode de paiement ne doit pas dépasser 100 caractères',
            'payment_terms.max' => 'Les conditions de paiement ne doivent pas dépasser 255 caractères',
            'due_date.date' => 'La date d\'échéance doit être une date valide',
            'due_date.after' => 'La date d\'échéance doit être après la date de début',
            'vendor_supplier.max' => 'Le fournisseur ne doit pas dépasser 255 caractères',
            'invoice_number.max' => 'Le numéro de facture ne doit pas dépasser 100 caractères',
            'reference_number.max' => 'Le numéro de référence ne doit pas dépasser 100 caractères',
            'tags.array' => 'Les tags doivent être dans un tableau',
            'tags.*.string' => 'Chaque tag doit être une chaîne de caractères',
            'tags.*.max' => 'Chaque tag ne doit pas dépasser 50 caractères',
            'attachments.array' => 'Les pièces jointes doivent être dans un tableau',
            'attachments.*.file' => 'Les pièces jointes doivent être des fichiers',
            'attachments.*.mimes' => 'Les pièces jointes doivent être au format: pdf, doc, docx, xls, xlsx, jpg, jpeg, png',
            'attachments.*.max' => 'Les pièces jointes ne doivent pas dépasser 10MB',
            'notes.max' => 'Les notes ne doivent pas dépasser 2000 caractères',
            'is_recurring.boolean' => 'Le champ récurrent doit être vrai ou faux',
            'recurrence_pattern.in' => 'Le modèle de récurrence doit être l\'un des suivants: daily, weekly, monthly, quarterly, yearly',
            'recurrence_end_date.date' => 'La date de fin de récurrence doit être une date valide',
            'recurrence_end_date.after' => 'La date de fin de récurrence doit être après la date de fin',
            'budget_line_items.array' => 'Les éléments de budget doivent être dans un tableau',
            'budget_line_items.*.description.required' => 'La description de l\'élément est obligatoire',
            'budget_line_items.*.description.max' => 'La description de l\'élément ne doit pas dépasser 255 caractères',
            'budget_line_items.*.amount.required' => 'Le montant de l\'élément est obligatoire',
            'budget_line_items.*.amount.numeric' => 'Le montant de l\'élément doit être un nombre',
            'budget_line_items.*.amount.min' => 'Le montant de l\'élément doit être supérieur à 0',
            'budget_line_items.*.category.required' => 'La catégorie de l\'élément est obligatoire',
            'budget_line_items.*.category.max' => 'La catégorie de l\'élément ne doit pas dépasser 100 caractères',
            'budget_line_items.*.quantity.numeric' => 'La quantité doit être un nombre',
            'budget_line_items.*.quantity.min' => 'La quantité doit être d\'au moins 1',
            'budget_line_items.*.unit_price.numeric' => 'Le prix unitaire doit être un nombre',
            'budget_line_items.*.unit_price.min' => 'Le prix unitaire doit être supérieur à 0',
            'risk_level.in' => 'Le niveau de risque doit être l\'un des suivants: low, medium, high, critical',
            'contingency_amount.numeric' => 'Le montant de contingence doit être un nombre',
            'contingency_amount.min' => 'Le montant de contingence doit être positif',
            'contingency_amount.max' => 'Le montant de contingence ne doit pas dépasser 999999999.99',
            'contingency_percentage.numeric' => 'Le pourcentage de contingence doit être un nombre',
            'contingency_percentage.min' => 'Le pourcentage de contingence doit être d\'au moins 0%',
            'contingency_percentage.max' => 'Le pourcentage de contingence ne doit pas dépasser 100%',
            'exchange_rate.numeric' => 'Le taux de change doit être un nombre',
            'exchange_rate.min' => 'Le taux de change doit être supérieur à 0.0001',
            'exchange_rate.max' => 'Le taux de change ne doit pas dépasser 10000',
            'base_currency.in' => 'La devise de base doit être l\'une des suivantes: EUR, USD, GBP, JPY, CHF, CAD, AUD',
            'tax_rate.numeric' => 'Le taux de taxe doit être un nombre',
            'tax_rate.min' => 'Le taux de taxe doit être d\'au moins 0%',
            'tax_rate.max' => 'Le taux de taxe ne doit pas dépasser 100%',
            'tax_amount.numeric' => 'Le montant de taxe doit être un nombre',
            'tax_amount.min' => 'Le montant de taxe doit être positif',
            'tax_amount.max' => 'Le montant de taxe ne doit pas dépasser 999999999.99',
            'discount_percentage.numeric' => 'Le pourcentage de remise doit être un nombre',
            'discount_percentage.min' => 'Le pourcentage de remise doit être d\'au moins 0%',
            'discount_percentage.max' => 'Le pourcentage de remise ne doit pas dépasser 100%',
            'discount_amount.numeric' => 'Le montant de remise doit être un nombre',
            'discount_amount.min' => 'Le montant de remise doit être positif',
            'discount_amount.max' => 'Le montant de remise ne doit pas dépasser 999999999.99',
            'total_amount.numeric' => 'Le montant total doit être un nombre',
            'total_amount.min' => 'Le montant total doit être positif',
            'total_amount.max' => 'Le montant total ne doit pas dépasser 999999999.99',
            'is_approved.boolean' => 'Le champ approuvé doit être vrai ou faux',
            'is_executed.boolean' => 'Le champ exécuté doit être vrai ou faux',
            'execution_date.date' => 'La date d\'exécution doit être une date valide',
            'execution_date.after_or_equal' => 'La date d\'exécution doit être égale ou après la date d\'approbation',
            'execution_notes.max' => 'Les notes d\'exécution ne doivent pas dépasser 1000 caractères',
            'variance_amount.numeric' => 'Le montant de variance doit être un nombre',
            'variance_percentage.numeric' => 'Le pourcentage de variance doit être un nombre',
            'variance_percentage.min' => 'Le pourcentage de variance doit être d\'au moins -100%',
            'variance_percentage.max' => 'Le pourcentage de variance ne doit pas dépasser 100%',
            'justification.max' => 'La justification ne doit pas dépasser 1000 caractères',
            'approval_workflow.max' => 'Le workflow d\'approbation ne doit pas dépasser 255 caractères',
            'next_review_date.date' => 'La prochaine date de révision doit être une date valide',
            'next_review_date.after' => 'La prochaine date de révision doit être dans le futur',
            'review_frequency.in' => 'La fréquence de révision doit être l\'une des suivantes: weekly, monthly, quarterly, yearly',
        ];
    }

    /**
     * Handle a failed validation attempt.
     */
    protected function failedValidation(Validator $validator): void
    {
        throw new HttpResponseException(
            response()->json([
                'success' => false,
                'message' => 'Erreur de validation',
                'errors' => $validator->errors(),
            ], 422)
        );
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        // Nettoyer et formater les données avant validation
        $this->merge([
            'category' => trim($this->category),
            'description' => trim($this->description),
            'currency' => strtoupper(trim($this->currency)),
            'payment_method' => $this->payment_method ? trim($this->payment_method) : null,
            'payment_terms' => $this->payment_terms ? trim($this->payment_terms) : null,
            'vendor_supplier' => $this->vendor_supplier ? trim($this->vendor_supplier) : null,
            'invoice_number' => $this->invoice_number ? trim($this->invoice_number) : null,
            'reference_number' => $this->reference_number ? trim($this->reference_number) : null,
            'notes' => $this->notes ? trim($this->notes) : null,
            'justification' => $this->justification ? trim($this->justification) : null,
            'execution_notes' => $this->execution_notes ? trim($this->execution_notes) : null,
            'approval_workflow' => $this->approval_workflow ? trim($this->approval_workflow) : null,
            'is_recurring' => $this->boolean('is_recurring'),
            'is_approved' => $this->boolean('is_approved'),
            'is_executed' => $this->boolean('is_executed'),
        ]);
    }
}
