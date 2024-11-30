<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::disableForeignKeyConstraints();

        Schema::table('user', function (Blueprint $table) {
            $table->enum('role', ['donatur', 'yayasan', 'panti_asuhan', 'admin'])->default('donatur')->change();
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
        });

        Schema::create('role_requests', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('user_id');
            $table->string('requested_role');
            $table->string('documents')->nullable();
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->timestamps();

            $table->foreign('user_id')->references('userID')->on('user')->onDelete('cascade');
        });

        Schema::enableForeignKeyConstraints();
    }

    public function down()
    {
        Schema::dropIfExists('role_requests');
        Schema::table('user', function (Blueprint $table) {
            $table->dropColumn('status');
        });
    }
};
