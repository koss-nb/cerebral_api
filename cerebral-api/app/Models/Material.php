<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Material extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'category',
        'unit',
        'current_stock',
        'min_stock',
        'max_stock',
        'unit_price',
        'supplier',
        'supplier_contact',
        'location',
        'status',
        'created_by',
    ];

    protected $casts = [
        'current_stock' => 'decimal:2',
        'min_stock' => 'decimal:2',
        'max_stock' => 'decimal:2',
        'unit_price' => 'decimal:2',
    ];

    /**
     * Get the user who created the material.
     */
    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the deliveries associated with this material.
     */
    public function deliveries(): BelongsToMany
    {
        return $this->belongsToMany(Delivery::class, 'delivery_material')
            ->withPivot('quantity', 'received_quantity', 'notes')
            ->withTimestamps();
    }

    /**
     * Check if the material is in low stock.
     */
    public function isLowStock(): bool
    {
        return $this->current_stock <= $this->min_stock;
    }

    /**
     * Check if the material is out of stock.
     */
    public function isOutOfStock(): bool
    {
        return $this->current_stock <= 0;
    }

    /**
     * Update the stock level.
     */
    public function updateStock(float $quantity, string $operation = 'add'): void
    {
        if ($operation === 'add') {
            $this->current_stock += $quantity;
        } elseif ($operation === 'subtract') {
            $this->current_stock = max(0, $this->current_stock - $quantity);
        }

        $this->updateStatus();
        $this->save();
    }

    /**
     * Update the status based on current stock.
     */
    protected function updateStatus(): void
    {
        if ($this->current_stock <= 0) {
            $this->status = 'out_of_stock';
        } elseif ($this->isLowStock()) {
            $this->status = 'low_stock';
        } else {
            $this->status = 'available';
        }
    }

    /**
     * Get the stock percentage.
     */
    public function getStockPercentageAttribute(): float
    {
        if ($this->max_stock <= 0) {
            return 0;
        }

        return ($this->current_stock / $this->max_stock) * 100;
    }
}
