<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Budget extends Model
{
    use HasFactory;

    protected $fillable = [
        'project_id',
        'category',
        'description',
        'amount',
        'currency',
        'type',
        'status',
        'fiscal_year',
        'period',
        'start_date',
        'end_date',
        'approved_by',
        'approved_at',
        'payment_method',
        'payment_terms',
        'due_date',
        'vendor_supplier',
        'invoice_number',
        'reference_number',
        'tags',
        'attachments',
        'notes',
        'is_recurring',
        'recurrence_pattern',
        'recurrence_end_date',
        'budget_line_items',
        'risk_level',
        'contingency_amount',
        'contingency_percentage',
        'exchange_rate',
        'base_currency',
        'tax_rate',
        'tax_amount',
        'discount_percentage',
        'discount_amount',
        'total_amount',
        'is_approved',
        'is_executed',
        'execution_date',
        'execution_notes',
        'variance_amount',
        'variance_percentage',
        'justification',
        'approval_workflow',
        'next_review_date',
        'review_frequency',
        'created_by',
    ];

    protected $casts = [
        'amount' => 'decimal:2',
        'start_date' => 'date',
        'end_date' => 'date',
        'due_date' => 'date',
        'recurrence_end_date' => 'date',
        'next_review_date' => 'date',
        'approved_at' => 'datetime',
        'execution_date' => 'datetime',
        'tags' => 'array',
        'attachments' => 'array',
        'budget_line_items' => 'array',
        'contingency_amount' => 'decimal:2',
        'contingency_percentage' => 'decimal:2',
        'exchange_rate' => 'decimal:4',
        'tax_rate' => 'decimal:2',
        'tax_amount' => 'decimal:2',
        'discount_percentage' => 'decimal:2',
        'discount_amount' => 'decimal:2',
        'total_amount' => 'decimal:2',
        'variance_amount' => 'decimal:2',
        'variance_percentage' => 'decimal:2',
        'is_recurring' => 'boolean',
        'is_approved' => 'boolean',
        'is_executed' => 'boolean',
    ];

    /**
     * Get the project this budget belongs to.
     */
    public function project()
    {
        return $this->belongsTo(Project::class);
    }

    /**
     * Get the user who approved this budget.
     */
    public function approvedBy()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    /**
     * Get the user who created this budget.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Scope for income transactions.
     */
    public function scopeIncome($query)
    {
        return $query->where('type', 'income');
    }

    /**
     * Scope for expense transactions.
     */
    public function scopeExpense($query)
    {
        return $query->where('type', 'expense');
    }

    /**
     * Scope for approved budgets.
     */
    public function scopeApproved($query)
    {
        return $query->where('is_approved', true);
    }

    /**
     * Scope for executed budgets.
     */
    public function scopeExecuted($query)
    {
        return $query->where('is_executed', true);
    }

    /**
     * Scope for budgets by status.
     */
    public function scopeByStatus($query, $status)
    {
        return $query->where('status', $status);
    }

    /**
     * Scope for budgets by category.
     */
    public function scopeByCategory($query, $category)
    {
        return $query->where('category', $category);
    }

    /**
     * Scope for budgets by fiscal year.
     */
    public function scopeByFiscalYear($query, $year)
    {
        return $query->where('fiscal_year', $year);
    }

    /**
     * Scope for budgets by period.
     */
    public function scopeByPeriod($query, $period)
    {
        return $query->where('period', $period);
    }

    /**
     * Scope for overdue budgets.
     */
    public function scopeOverdue($query)
    {
        return $query->where('due_date', '<', now())
            ->where('status', '!=', 'executed');
    }

    /**
     * Get formatted amount with currency.
     */
    public function getFormattedAmountAttribute()
    {
        return number_format($this->amount, 2, ',', ' ') . ' ' . $this->currency;
    }

    /**
     * Get formatted total amount with currency.
     */
    public function getFormattedTotalAmountAttribute()
    {
        if (!$this->total_amount) return $this->formatted_amount;
        return number_format($this->total_amount, 2, ',', ' ') . ' ' . $this->currency;
    }

    /**
     * Check if this is an income transaction.
     */
    public function getIsIncomeAttribute()
    {
        return in_array($this->type, ['income', 'revenue']);
    }

    /**
     * Check if this is an expense transaction.
     */
    public function getIsExpenseAttribute()
    {
        return in_array($this->type, ['expense', 'cost']);
    }

    /**
     * Check if budget is overdue.
     */
    public function getIsOverdueAttribute()
    {
        if (!$this->due_date || $this->status === 'executed') {
            return false;
        }
        return now()->isAfter($this->due_date);
    }

    /**
     * Calculate remaining amount.
     */
    public function getRemainingAmountAttribute()
    {
        if (!$this->total_amount) return $this->amount;
        return $this->total_amount - $this->amount;
    }

    /**
     * Get budget efficiency percentage.
     */
    public function getEfficiencyAttribute()
    {
        if (!$this->estimated_amount || !$this->actual_amount) {
            return 100;
        }

        $efficiency = (($this->estimated_amount - $this->actual_amount) / $this->estimated_amount) * 100;
        return round($efficiency, 2);
    }

    /**
     * Get risk level color.
     */
    public function getRiskLevelColorAttribute()
    {
        return match ($this->risk_level) {
            'low' => 'green',
            'medium' => 'yellow',
            'high' => 'orange',
            'critical' => 'red',
            default => 'gray'
        };
    }

    /**
     * Get status color.
     */
    public function getStatusColorAttribute()
    {
        return match ($this->status) {
            'planned' => 'blue',
            'approved' => 'green',
            'pending' => 'yellow',
            'rejected' => 'red',
            'executed' => 'purple',
            'cancelled' => 'gray',
            default => 'gray'
        };
    }
}
