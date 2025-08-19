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
        Schema::create('projects', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description')->nullable();
            $table->string('type')->default('commercial'); // residential, commercial, industrial
            $table->string('status')->default('planning'); // planning, in_progress, on_hold, completed, cancelled
            $table->string('priority')->default('medium'); // low, medium, high, critical
            $table->decimal('budget', 15, 2)->nullable();
            $table->string('currency', 3)->default('EUR');
            $table->string('client_name');
            $table->string('client_email');
            $table->string('client_phone')->nullable();
            $table->string('location');
            $table->foreignId('manager_id')->constrained('users');
            $table->date('start_date')->nullable();
            $table->date('end_date')->nullable();
            $table->decimal('progress', 5, 2)->default(0); // 0.00 to 100.00
            $table->json('team_members')->nullable();
            $table->json('tags')->nullable();
            $table->json('attachments')->nullable();
            $table->json('metadata')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('projects');
    }
};
