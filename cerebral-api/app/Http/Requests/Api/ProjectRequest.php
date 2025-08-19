<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class ProjectRequest extends FormRequest
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
        $projectId = $this->route('project');

        return [
            'name' => 'required|string|max:255|min:3',
            'description' => 'required|string|min:10|max:1000',
            'start_date' => 'required|date|after_or_equal:today',
            'end_date' => 'required|date|after:start_date',
            'budget' => 'required|numeric|min:0|max:999999999.99',
            'status' => 'required|in:planning,in_progress,on_hold,completed,cancelled',
            'priority' => 'required|in:low,medium,high,critical',
            'client_name' => 'required|string|max:255',
            'client_email' => 'required|email|max:255',
            'client_phone' => 'nullable|string|max:20',
            'location' => 'required|string|max:255',
            'manager_id' => 'required|exists:users,id',
            'team_members' => 'array',
            'team_members.*' => 'exists:users,id',
            'tags' => 'array',
            'tags.*' => 'string|max:50',
            'attachments' => 'array',
            'attachments.*' => 'file|mimes:pdf,doc,docx,xls,xlsx,jpg,jpeg,png|max:10240',
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'name.required' => 'Le nom du projet est obligatoire',
            'name.min' => 'Le nom du projet doit contenir au moins 3 caractères',
            'description.required' => 'La description du projet est obligatoire',
            'description.min' => 'La description doit contenir au moins 10 caractères',
            'start_date.required' => 'La date de début est obligatoire',
            'start_date.after_or_equal' => 'La date de début doit être aujourd\'hui ou dans le futur',
            'end_date.required' => 'La date de fin est obligatoire',
            'end_date.after' => 'La date de fin doit être après la date de début',
            'budget.required' => 'Le budget est obligatoire',
            'budget.min' => 'Le budget doit être positif',
            'status.required' => 'Le statut est obligatoire',
            'status.in' => 'Le statut doit être l\'un des suivants: planning, in_progress, on_hold, completed, cancelled',
            'priority.required' => 'La priorité est obligatoire',
            'priority.in' => 'La priorité doit être l\'un des suivants: low, medium, high, critical',
            'client_name.required' => 'Le nom du client est obligatoire',
            'client_email.required' => 'L\'email du client est obligatoire',
            'client_email.email' => 'L\'email du client doit être valide',
            'location.required' => 'L\'emplacement est obligatoire',
            'manager_id.required' => 'Le gestionnaire est obligatoire',
            'manager_id.exists' => 'Le gestionnaire sélectionné n\'existe pas',
            'team_members.array' => 'Les membres de l\'équipe doivent être dans un tableau',
            'team_members.*.exists' => 'Un ou plusieurs membres de l\'équipe n\'existent pas',
            'attachments.*.file' => 'Les pièces jointes doivent être des fichiers',
            'attachments.*.mimes' => 'Les pièces jointes doivent être au format: pdf, doc, docx, xls, xlsx, jpg, jpeg, png',
            'attachments.*.max' => 'Les pièces jointes ne doivent pas dépasser 10MB',
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
            'name' => trim($this->name),
            'description' => trim($this->description),
            'client_name' => trim($this->client_name),
            'client_email' => strtolower(trim($this->client_email)),
            'location' => trim($this->location),
        ]);
    }
}
