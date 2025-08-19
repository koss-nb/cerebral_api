<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class PersonnelRequest extends FormRequest
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
        $personnelId = $this->route('personnel');

        return [
            'first_name' => 'required|string|max:100|min:2',
            'last_name' => 'required|string|max:100|min:2',
            'email' => 'required|email|max:255|unique:personnels,email,' . $personnelId,
            'phone' => 'nullable|string|max:20|regex:/^[\+]?[0-9\s\-\(\)]+$/',
            'position' => 'required|string|max:255',
            'department' => 'required|string|max:255',
            'hire_date' => 'required|date|before_or_equal:today',
            'salary' => 'nullable|numeric|min:0|max:999999.99',
            'status' => 'required|in:active,inactive,on_leave,terminated',
            'employee_id' => 'required|string|max:50|unique:personnels,employee_id,' . $personnelId,
            'manager_id' => 'nullable|exists:personnels,id',
            'skills' => 'array',
            'skills.*' => 'string|max:100',
            'certifications' => 'array',
            'certifications.*' => 'string|max:255',
            'languages' => 'array',
            'languages.*' => 'string|max:50',
            'emergency_contact' => 'array',
            'emergency_contact.name' => 'nullable|string|max:255',
            'emergency_contact.phone' => 'nullable|string|max:20',
            'emergency_contact.relationship' => 'nullable|string|max:100',
            'address' => 'nullable|string|max:500',
            'city' => 'nullable|string|max:100',
            'postal_code' => 'nullable|string|max:20',
            'country' => 'nullable|string|max:100',
            'date_of_birth' => 'nullable|date|before:hire_date',
            'gender' => 'nullable|in:male,female,other,prefer_not_to_say',
            'marital_status' => 'nullable|in:single,married,divorced,widowed',
            'nationality' => 'nullable|string|max:100',
            'passport_number' => 'nullable|string|max:50',
            'tax_id' => 'nullable|string|max:50',
            'bank_account' => 'nullable|string|max:50',
            'contract_type' => 'nullable|in:full_time,part_time,contract,intern,temporary',
            'work_schedule' => 'nullable|string|max:255',
            'overtime_eligible' => 'boolean',
            'remote_work_allowed' => 'boolean',
            'probation_period' => 'nullable|integer|min:0|max:365',
            'performance_rating' => 'nullable|numeric|min:0|max:5',
            'notes' => 'nullable|string|max:2000',
            'avatar' => 'nullable|file|mimes:jpg,jpeg,png|max:2048',
            'documents' => 'array',
            'documents.*' => 'file|mimes:pdf,doc,docx,xls,xlsx|max:10240',
            'created_by' => 'nullable|exists:users,id',
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'first_name.required' => 'Le prénom est obligatoire',
            'first_name.min' => 'Le prénom doit contenir au moins 2 caractères',
            'first_name.max' => 'Le prénom ne doit pas dépasser 100 caractères',
            'last_name.required' => 'Le nom de famille est obligatoire',
            'last_name.min' => 'Le nom de famille doit contenir au moins 2 caractères',
            'last_name.max' => 'Le nom de famille ne doit pas dépasser 100 caractères',
            'email.required' => 'L\'email est obligatoire',
            'email.email' => 'L\'email doit être valide',
            'email.unique' => 'Cet email est déjà utilisé',
            'phone.regex' => 'Le numéro de téléphone doit être valide',
            'position.required' => 'Le poste est obligatoire',
            'department.required' => 'Le département est obligatoire',
            'hire_date.required' => 'La date d\'embauche est obligatoire',
            'hire_date.before_or_equal' => 'La date d\'embauche ne peut pas être dans le futur',
            'salary.numeric' => 'Le salaire doit être un nombre',
            'salary.min' => 'Le salaire doit être positif',
            'salary.max' => 'Le salaire ne doit pas dépasser 999999.99',
            'status.required' => 'Le statut est obligatoire',
            'status.in' => 'Le statut doit être l\'un des suivants: active, inactive, on_leave, terminated',
            'employee_id.required' => 'L\'identifiant employé est obligatoire',
            'employee_id.unique' => 'Cet identifiant employé est déjà utilisé',
            'manager_id.exists' => 'Le manager sélectionné n\'existe pas',
            'skills.array' => 'Les compétences doivent être dans un tableau',
            'skills.*.string' => 'Chaque compétence doit être une chaîne de caractères',
            'skills.*.max' => 'Chaque compétence ne doit pas dépasser 100 caractères',
            'certifications.array' => 'Les certifications doivent être dans un tableau',
            'certifications.*.string' => 'Chaque certification doit être une chaîne de caractères',
            'certifications.*.max' => 'Chaque certification ne doit pas dépasser 255 caractères',
            'languages.array' => 'Les langues doivent être dans un tableau',
            'languages.*.string' => 'Chaque langue doit être une chaîne de caractères',
            'languages.*.max' => 'Chaque langue ne doit pas dépasser 50 caractères',
            'emergency_contact.name.string' => 'Le nom du contact d\'urgence doit être une chaîne',
            'emergency_contact.phone.string' => 'Le téléphone du contact d\'urgence doit être une chaîne',
            'emergency_contact.relationship.string' => 'La relation du contact d\'urgence doit être une chaîne',
            'address.max' => 'L\'adresse ne doit pas dépasser 500 caractères',
            'city.max' => 'La ville ne doit pas dépasser 100 caractères',
            'postal_code.max' => 'Le code postal ne doit pas dépasser 20 caractères',
            'country.max' => 'Le pays ne doit pas dépasser 100 caractères',
            'date_of_birth.date' => 'La date de naissance doit être une date valide',
            'date_of_birth.before' => 'La date de naissance doit être avant la date d\'embauche',
            'gender.in' => 'Le genre doit être l\'un des suivants: male, female, other, prefer_not_to_say',
            'marital_status.in' => 'Le statut marital doit être l\'un des suivants: single, married, divorced, widowed',
            'nationality.max' => 'La nationalité ne doit pas dépasser 100 caractères',
            'passport_number.max' => 'Le numéro de passeport ne doit pas dépasser 50 caractères',
            'tax_id.max' => 'L\'identifiant fiscal ne doit pas dépasser 50 caractères',
            'bank_account.max' => 'Le compte bancaire ne doit pas dépasser 50 caractères',
            'contract_type.required' => 'Le type de contrat est obligatoire',
            'contract_type.in' => 'Le type de contrat doit être l\'un des suivants: full_time, part_time, contract, intern, temporary',
            'work_schedule.max' => 'L\'horaire de travail ne doit pas dépasser 255 caractères',
            'overtime_eligible.boolean' => 'Le champ éligible aux heures supplémentaires doit être vrai ou faux',
            'remote_work_allowed.boolean' => 'Le champ télétravail autorisé doit être vrai ou faux',
            'probation_period.integer' => 'La période d\'essai doit être un nombre entier',
            'probation_period.min' => 'La période d\'essai doit être d\'au moins 0 jours',
            'probation_period.max' => 'La période d\'essai ne doit pas dépasser 365 jours',
            'performance_rating.numeric' => 'L\'évaluation de performance doit être un nombre',
            'performance_rating.min' => 'L\'évaluation de performance doit être d\'au moins 0',
            'performance_rating.max' => 'L\'évaluation de performance ne doit pas dépasser 5',
            'notes.max' => 'Les notes ne doivent pas dépasser 2000 caractères',
            'avatar.file' => 'L\'avatar doit être un fichier',
            'avatar.mimes' => 'L\'avatar doit être au format: jpg, jpeg, png',
            'avatar.max' => 'L\'avatar ne doit pas dépasser 2MB',
            'documents.array' => 'Les documents doivent être dans un tableau',
            'documents.*.file' => 'Les documents doivent être des fichiers',
            'documents.*.mimes' => 'Les documents doivent être au format: pdf, doc, docx, xls, xlsx',
            'documents.*.max' => 'Les documents ne doivent pas dépasser 10MB',
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
            'first_name' => trim($this->first_name),
            'last_name' => trim($this->last_name),
            'email' => strtolower(trim($this->email)),
            'phone' => $this->phone ? trim($this->phone) : null,
            'position' => trim($this->position),
            'department' => trim($this->department),
            'employee_id' => strtoupper(trim($this->employee_id)),
            'address' => $this->address ? trim($this->address) : null,
            'city' => $this->city ? trim($this->city) : null,
            'country' => $this->country ? trim($this->country) : null,
            'overtime_eligible' => $this->boolean('overtime_eligible'),
            'remote_work_allowed' => $this->boolean('remote_work_allowed'),
        ]);
    }
}
