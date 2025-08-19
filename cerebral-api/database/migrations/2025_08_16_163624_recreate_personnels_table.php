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
        Schema::dropIfExists('personnels');
        Schema::create('personnels', function (Blueprint $table) {
            $table->id();
            $table->string('first_name', 100);
            $table->string('last_name', 100);
            $table->string('email', 255)->unique();
            $table->string('phone', 20)->nullable();
            $table->string('position', 255);
            $table->string('department', 100);
            $table->date('hire_date');
            $table->decimal('salary', 15, 2)->nullable();
            $table->enum('status', ['active', 'inactive', 'on_leave', 'terminated'])->default('active');
            $table->string('employee_id', 50)->unique();
            $table->unsignedBigInteger('manager_id')->nullable();
            $table->json('skills')->nullable();
            $table->json('certifications')->nullable();
            $table->json('languages')->nullable();
            $table->json('emergency_contact')->nullable();
            $table->string('address', 500)->nullable();
            $table->string('city', 100)->nullable();
            $table->string('postal_code', 20)->nullable();
            $table->string('country', 100)->nullable();
            $table->date('date_of_birth')->nullable();
            $table->enum('gender', ['male', 'female', 'other', 'prefer_not_to_say'])->nullable();
            $table->enum('marital_status', ['single', 'married', 'divorced', 'widowed', 'other'])->nullable();
            $table->string('nationality', 100)->nullable();
            $table->string('passport_number', 50)->nullable();
            $table->string('tax_id', 50)->nullable();
            $table->string('bank_account', 100)->nullable();
            $table->enum('contract_type', ['full_time', 'part_time', 'contract', 'intern', 'temporary'])->default('full_time');
            $table->string('work_schedule', 100)->nullable();
            $table->boolean('overtime_eligible')->default(false);
            $table->boolean('remote_work_allowed')->default(false);
            $table->integer('probation_period')->nullable();
            $table->decimal('performance_rating', 3, 1)->nullable();
            $table->text('notes')->nullable();
            $table->string('avatar', 500)->nullable();
            $table->json('documents')->nullable();
            $table->unsignedBigInteger('created_by');
            $table->timestamps();

            $table->foreign('manager_id')->references('id')->on('personnels')->onDelete('set null');
            $table->foreign('created_by')->references('id')->on('users')->onDelete('cascade');
            
            $table->index(['department', 'status']);
            $table->index(['position', 'status']);
            $table->index('hire_date');
            $table->index('employee_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('personnels');
    }
};
