<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TimeTracking extends Model
{
    use HasFactory;

    protected $table = 'time_tracking';

    protected $fillable = [
        'user_id',
        'project_id',
        'clock_in',
        'clock_out',
        'notes',
        'location',
        'status',
    ];

    protected $casts = [
        'clock_in' => 'datetime',
        'clock_out' => 'datetime',
    ];

    /**
     * Get the user associated with the time tracking.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the project associated with the time tracking.
     */
    public function project(): BelongsTo
    {
        return $this->belongsTo(Project::class);
    }

    /**
     * Calculate the duration in hours.
     */
    public function getDurationAttribute(): float
    {
        if (!$this->clock_out) {
            return 0;
        }

        return $this->clock_in->diffInHours($this->clock_out, true);
    }

    /**
     * Check if the time tracking is active.
     */
    public function isActive(): bool
    {
        return $this->status === 'active' && !$this->clock_out;
    }

    /**
     * Check if the time tracking is completed.
     */
    public function isCompleted(): bool
    {
        return $this->status === 'completed' && $this->clock_out;
    }
}
