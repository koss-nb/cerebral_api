<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Workflow extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'type',
        'status',
        'steps',
        'conditions',
        'created_by',
        'is_active',
        'metadata',
        'activated_at',
        'deactivated_at',
    ];

    protected $casts = [
        'steps' => 'array',
        'conditions' => 'array',
        'metadata' => 'array',
        'is_active' => 'boolean',
        'activated_at' => 'datetime',
        'deactivated_at' => 'datetime',
    ];

    /**
     * Get the user who created the workflow.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Check if workflow is active.
     */
    public function getIsActiveAttribute()
    {
        return $this->status === 'active' && $this->getAttribute('is_active');
    }

    /**
     * Get workflow steps as array.
     */
    public function getStepsArrayAttribute()
    {
        return $this->steps ?? [];
    }
}
