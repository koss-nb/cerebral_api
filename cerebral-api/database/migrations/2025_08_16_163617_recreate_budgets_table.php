<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::dropIfExists('budgets');
        Schema::create('budgets', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('project_id');
            $table->string('category', 100);
            $table->text('description');
            $table->decimal('amount', 15, 2);
            $table->string('currency', 3)->default('EUR');
            $table->enum('type', ['income', 'expense', 'revenue', 'cost', 'investment', 'loan'])->default('expense');
            $table->enum('status', ['planned', 'pending', 'approved', 'rejected', 'executed', 'cancelled'])->default('planned');
            $table->integer('fiscal_year');
            $table->string('period', 20)->nullable();
            $table->date('start_date');
            $table->date('end_date');
            $table->unsignedBigInteger('approved_by')->nullable();
            $table->timestamp('approved_at')->nullable();
            $table->string('payment_method', 100)->nullable();
            $table->string('payment_terms', 100)->nullable();
            $table->date('due_date')->nullable();
            $table->string('vendor_supplier', 255)->nullable();
            $table->string('invoice_number', 100)->nullable();
            $table->string('reference_number', 100)->nullable();
            $table->json('tags')->nullable();
            $table->json('attachments')->nullable();
            $table->text('notes')->nullable();
            $table->boolean('is_recurring')->default(false);
            $table->string('recurrence_pattern', 50)->nullable();
            $table->date('recurrence_end_date')->nullable();
            $table->json('budget_line_items')->nullable();
            $table->enum('risk_level', ['low', 'medium', 'high', 'critical'])->default('medium');
            $table->decimal('contingency_amount', 15, 2)->nullable();
            $table->decimal('contingency_percentage', 5, 2)->nullable();
            $table->decimal('exchange_rate', 10, 4)->default(1.0000);
            $table->string('base_currency', 3)->default('EUR');
            $table->decimal('tax_rate', 5, 2)->nullable();
            $table->decimal('tax_amount', 15, 2)->nullable();
            $table->decimal('discount_percentage', 5, 2)->nullable();
            $table->decimal('discount_amount', 15, 2)->nullable();
            $table->decimal('total_amount', 15, 2)->nullable();
            $table->boolean('is_approved')->default(false);
            $table->boolean('is_executed')->default(false);
            $table->timestamp('execution_date')->nullable();
            $table->text('execution_notes')->nullable();
            $table->decimal('variance_amount', 15, 2)->nullable();
            $table->decimal('variance_percentage', 5, 2)->nullable();
            $table->text('justification')->nullable();
            $table->string('approval_workflow', 100)->nullable();
            $table->date('next_review_date')->nullable();
            $table->string('review_frequency', 50)->nullable();
            $table->unsignedBigInteger('created_by');
            $table->timestamps();

            $table->foreign('project_id')->references('id')->on('projects')->onDelete('cascade');
            $table->foreign('approved_by')->references('id')->on('users')->onDelete('set null');
            $table->foreign('created_by')->references('id')->on('users')->onDelete('cascade');

            $table->index(['project_id', 'status']);
            $table->index(['type', 'status']);
            $table->index(['fiscal_year', 'category']);
            $table->index('due_date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('budgets');
    }
};
