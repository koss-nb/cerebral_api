<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Personnel extends Model
{
    use HasFactory;

    protected $fillable = [
        'first_name',
        'last_name',
        'email',
        'phone',
        'position',
        'department',
        'hire_date',
        'salary',
        'status',
        'employee_id',
        'manager_id',
        'user_id',
        'skills',
        'certifications',
        'languages',
        'emergency_contact',
        'address',
        'city',
        'postal_code',
        'country',
        'date_of_birth',
        'gender',
        'marital_status',
        'nationality',
        'passport_number',
        'tax_id',
        'bank_account',
        'contract_type',
        'work_schedule',
        'overtime_eligible',
        'remote_work_allowed',
        'probation_period',
        'performance_rating',
        'notes',
        'avatar',
        'documents',
        'created_by',
    ];

    protected $casts = [
        'hire_date' => 'date',
        'date_of_birth' => 'date',
        'salary' => 'decimal:2',
        'skills' => 'array',
        'certifications' => 'array',
        'languages' => 'array',
        'emergency_contact' => 'array',
        'documents' => 'array',
        'overtime_eligible' => 'boolean',
        'remote_work_allowed' => 'boolean',
        'performance_rating' => 'decimal:2',
    ];

    /**
     * Get the user who created this personnel record.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the user account associated with this personnel.
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Get the manager of this personnel.
     */
    public function manager()
    {
        return $this->belongsTo(Personnel::class, 'manager_id');
    }

    /**
     * Get the personnel managed by this personnel.
     */
    public function subordinates()
    {
        return $this->hasMany(Personnel::class, 'manager_id');
    }

    /**
     * Get the projects this personnel is assigned to.
     */
    public function projects()
    {
        return $this->belongsToMany(Project::class, 'project_personnel')
                    ->withPivot('role', 'start_date', 'end_date')
                    ->withTimestamps();
    }

    /**
     * Get the tasks assigned to this personnel.
     */
    public function tasks()
    {
        return $this->hasMany(Task::class, 'assigned_to', 'id');
    }

    /**
     * Check if personnel is active.
     */
    public function getIsActiveAttribute()
    {
        return $this->status === 'active';
    }

    /**
     * Get personnel full name.
     */
    public function getFullNameAttribute()
    {
        return $this->first_name . ' ' . $this->last_name;
    }

    /**
     * Get personnel initials.
     */
    public function getInitialsAttribute()
    {
        return strtoupper(substr($this->first_name, 0, 1) . substr($this->last_name, 0, 1));
    }

    /**
     * Get personnel display name.
     */
    public function getDisplayNameAttribute()
    {
        return $this->first_name . ' ' . substr($this->last_name, 0, 1) . '.';
    }

    /**
     * Scope for active personnel.
     */
    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    /**
     * Scope for personnel by department.
     */
    public function scopeByDepartment($query, $department)
    {
        return $query->where('department', $department);
    }

    /**
     * Scope for personnel by contract type.
     */
    public function scopeByContractType($query, $contractType)
    {
        return $query->where('contract_type', $contractType);
    }

    /**
     * Scope for personnel by position.
     */
    public function scopeByPosition($query, $position)
    {
        return $query->where('position', $position);
    }

    /**
     * Get personnel age.
     */
    public function getAgeAttribute()
    {
        if (!$this->date_of_birth) {
            return null;
        }
        return $this->date_of_birth->age;
    }

    /**
     * Get personnel tenure in years.
     */
    public function getTenureYearsAttribute()
    {
        if (!$this->hire_date) {
            return null;
        }
        return $this->hire_date->diffInYears(now());
    }

    /**
     * Check if personnel is on probation.
     */
    public function getIsOnProbationAttribute()
    {
        if (!$this->probation_period || !$this->hire_date) {
            return false;
        }
        return $this->hire_date->addDays($this->probation_period)->isFuture();
    }
}
