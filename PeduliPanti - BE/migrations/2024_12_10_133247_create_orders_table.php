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
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('no_transaction')->unique(); // Ensure unique transaction IDs
            $table->string('name');
            $table->string('transaction_id')->nullable(); // Store Core API transaction ID
            $table->integer('qty');
            $table->integer('price');
            $table->bigInteger('grand_total');
            $table->string('payment_type')->nullable(); // Store payment type (e.g., gopay, qris)
            $table->string('status')->default('pending'); // Order status
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
