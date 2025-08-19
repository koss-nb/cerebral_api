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
        Schema::create('media', function (Blueprint $table) {
            $table->id();
            $table->string('filename');
            $table->string('original_name');
            $table->string('mime_type');
            $table->string('extension');
            $table->bigInteger('file_size'); // en bytes
            $table->string('file_path');
            $table->string('url')->nullable();
            $table->string('title')->nullable();
            $table->text('description')->nullable();
            $table->enum('type', ['image', 'document', 'video', 'audio'])->default('image');
            $table->string('category')->nullable(); // plan, photo, rapport, etc.
            $table->unsignedBigInteger('uploaded_by');
            $table->morphs('mediable'); // Polymorphic relationship
            $table->timestamps();

            $table->foreign('uploaded_by')->references('id')->on('users')->onDelete('cascade');
            $table->index(['type', 'category']);
            $table->index(['mediable_type', 'mediable_id'], 'media_mediable_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('media');
    }
};
