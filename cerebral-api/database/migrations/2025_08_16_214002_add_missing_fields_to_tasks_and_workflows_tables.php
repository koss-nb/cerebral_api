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
        Schema::table('tasks', function (Blueprint $table) {
            $table->unsignedBigInteger('assigned_by')->nullable()->after('assigned_to');
            $table->text('assignment_notes')->nullable()->after('assigned_by');
            $table->timestamp('assigned_at')->nullable()->after('assignment_notes');
            $table->foreign('assigned_by')->references('id')->on('users')->onDelete('set null');
        });

        Schema::table('workflows', function (Blueprint $table) {
            $table->timestamp('activated_at')->nullable()->after('status');
            $table->timestamp('deactivated_at')->nullable()->after('activated_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('tasks', function (Blueprint $table) {
            $table->dropForeign(['assigned_by']);
            $table->dropColumn(['assigned_by', 'assignment_notes', 'assigned_at']);
        });

        Schema::table('workflows', function (Blueprint $table) {
            $table->dropColumn(['activated_at', 'deactivated_at']);
        });
    }
};
