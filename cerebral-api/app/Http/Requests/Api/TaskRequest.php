<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class TaskRequest extends FormRequest
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
        $taskId = $this->route('task');

        $rules = [
            'title' => 'sometimes|string|max:255|min:3',
            'description' => 'sometimes|string|min:10|max:2000',
            'project_id' => 'sometimes|exists:projects,id',
            'assigned_to' => 'sometimes|exists:users,id',
            'status' => 'sometimes|in:pending,in_progress,review,completed,cancelled',
            'priority' => 'sometimes|in:low,medium,high,critical',
            'estimated_hours' => 'nullable|numeric|min:0.5|max:1000',
            'actual_hours' => 'nullable|numeric|min:0|max:1000',
            'start_date' => 'nullable|date|after_or_equal:today',
            'due_date' => 'nullable|date|after:start_date',
            'completed_at' => 'nullable|date|after:start_date',
            'progress' => 'nullable|numeric|min:0|max:100',
            'attachments' => 'array',
            'attachments.*' => 'string|max:255',
        ];

        // Ajouter les règles obligatoires seulement pour la création
        if (!$taskId) {
            $rules['title'] = 'required|string|max:255|min:3';
            $rules['description'] = 'required|string|min:10|max:2000';
            $rules['project_id'] = 'required|exists:projects,id';
            $rules['assigned_to'] = 'required|exists:users,id';
            $rules['status'] = 'required|in:pending,in_progress,review,completed,cancelled';
            $rules['priority'] = 'required|in:low,medium,high,critical';
            $rules['created_by'] = 'required|exists:users,id';
        }

        return $rules;
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'title.required' => 'Le titre de la tâche est obligatoire',
            'title.min' => 'Le titre doit contenir au moins 3 caractères',
            'title.max' => 'Le titre ne doit pas dépasser 255 caractères',
            'description.required' => 'La description de la tâche est obligatoire',
            'description.min' => 'La description doit contenir au moins 10 caractères',
            'description.max' => 'La description ne doit pas dépasser 2000 caractères',
            'project_id.required' => 'Le projet est obligatoire',
            'project_id.exists' => 'Le projet sélectionné n\'existe pas',
            'assigned_to.required' => 'L\'assignation est obligatoire',
            'assigned_to.exists' => 'L\'utilisateur assigné n\'existe pas',
            'status.required' => 'Le statut est obligatoire',
            'status.in' => 'Le statut doit être l\'un des suivants: pending, in_progress, review, completed, cancelled',
            'priority.required' => 'La priorité est obligatoire',
            'priority.in' => 'La priorité doit être l\'un des suivants: low, medium, high, critical',
            'estimated_hours.numeric' => 'Les heures estimées doivent être un nombre',
            'estimated_hours.min' => 'Les heures estimées doivent être d\'au moins 0.5',
            'estimated_hours.max' => 'Les heures estimées ne doivent pas dépasser 1000',
            'actual_hours.numeric' => 'Les heures réelles doivent être un nombre',
            'actual_hours.min' => 'Les heures réelles doivent être positives',
            'actual_hours.max' => 'Les heures réelles ne doivent pas dépasser 1000',
            'start_date.date' => 'La date de début doit être une date valide',
            'start_date.after_or_equal' => 'La date de début doit être aujourd\'hui ou dans le futur',
            'due_date.date' => 'La date d\'échéance doit être une date valide',
            'due_date.after' => 'La date d\'échéance doit être après la date de début',
            'completed_at.date' => 'La date de completion doit être une date valide',
            'completed_at.after' => 'La date de completion doit être après la date de début',
            'progress.numeric' => 'La progression doit être un nombre',
            'progress.min' => 'La progression doit être d\'au moins 0%',
            'progress.max' => 'La progression ne doit pas dépasser 100%',
            'attachments.array' => 'Les pièces jointes doivent être dans un tableau',
            'attachments.*.string' => 'Chaque pièce jointe doit être une chaîne de caractères',
            'attachments.*.max' => 'Chaque pièce jointe ne doit pas dépasser 255 caractères',
            'created_by.required' => 'L\'utilisateur créateur est obligatoire',
            'created_by.exists' => 'L\'utilisateur créateur n\'existe pas',
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
            'title' => trim($this->title),
            'description' => trim($this->description),
        ]);
    }
}
