<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Project extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'type',
        'status',
        'priority',
        'budget',
        'currency',
        'client_name',
        'client_email',
        'client_phone',
        'location',
        'manager_id',
        'start_date',
        'end_date',
        'progress',
        'team_members',
        'tags',
        'attachments',
        'metadata',
    ];

    protected $casts = [
        'start_date' => 'date',
        'end_date' => 'date',
        'budget' => 'decimal:2',
        'progress' => 'decimal:2',
        'team_members' => 'array',
        'tags' => 'array',
        'attachments' => 'array',
        'metadata' => 'array',
    ];

    /**
     * Get the manager of the project.
     */
    public function manager()
    {
        return $this->belongsTo(User::class, 'manager_id');
    }

    /**
     * Get the tasks for the project.
     */
    public function tasks()
    {
        return $this->hasMany(Task::class);
    }

    /**
     * Get the budget records for the project.
     */
    public function budgets()
    {
        return $this->hasMany(Budget::class);
    }

    /**
     * Calculate the total budget spent.
     */
    public function getTotalSpentAttribute()
    {
        return $this->budgets()->sum('amount');
    }

    /**
     * Calculate the remaining budget.
     */
    public function getRemainingBudgetAttribute()
    {
        if (!$this->budget) {
            return 0;
        }
        return $this->budget - $this->total_spent;
    }

    /**
     * Check if project is overdue.
     */
    public function getIsOverdueAttribute()
    {
        if (!$this->end_date) {
            return false;
        }
        return now()->isAfter($this->end_date) && $this->status !== 'completed';
    }
}
