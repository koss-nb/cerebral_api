<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Delivery extends Model
{
    use HasFactory;

    protected $fillable = [
        'reference',
        'title',
        'description',
        'project_id',
        'supplier',
        'supplier_contact',
        'expected_date',
        'delivered_date',
        'status',
        'notes',
        'created_by',
        'received_by',
    ];

    protected $casts = [
        'expected_date' => 'datetime',
        'delivered_date' => 'datetime',
    ];

    /**
     * Get the project associated with the delivery.
     */
    public function project(): BelongsTo
    {
        return $this->belongsTo(Project::class);
    }

    /**
     * Get the user who created the delivery.
     */
    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the user who received the delivery.
     */
    public function receivedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'received_by');
    }

    /**
     * Get the materials associated with this delivery.
     */
    public function materials(): BelongsToMany
    {
        return $this->belongsToMany(Material::class, 'delivery_material')
            ->withPivot('quantity', 'received_quantity', 'notes')
            ->withTimestamps();
    }

    /**
     * Check if the delivery is pending.
     */
    public function isPending(): bool
    {
        return $this->status === 'pending';
    }

    /**
     * Check if the delivery is confirmed.
     */
    public function isConfirmed(): bool
    {
        return $this->status === 'confirmed';
    }

    /**
     * Check if the delivery is in transit.
     */
    public function isInTransit(): bool
    {
        return $this->status === 'in_transit';
    }

    /**
     * Check if the delivery is delivered.
     */
    public function isDelivered(): bool
    {
        return $this->status === 'delivered';
    }

    /**
     * Check if the delivery is cancelled.
     */
    public function isCancelled(): bool
    {
        return $this->status === 'cancelled';
    }

    /**
     * Mark the delivery as delivered.
     */
    public function markAsDelivered(int $receivedByUserId): void
    {
        $this->update([
            'status' => 'delivered',
            'delivered_date' => now(),
            'received_by' => $receivedByUserId,
        ]);
    }

    /**
     * Get the total quantity of materials in this delivery.
     */
    public function getTotalMaterialsQuantityAttribute(): float
    {
        return $this->materials()->sum('delivery_material.quantity');
    }

    /**
     * Get the total received quantity of materials.
     */
    public function getTotalReceivedQuantityAttribute(): float
    {
        return $this->materials()->sum('delivery_material.received_quantity');
    }
}
