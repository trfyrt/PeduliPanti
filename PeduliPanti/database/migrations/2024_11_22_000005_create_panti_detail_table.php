
<?php
        /**
     *namespace Database\Migrations;
     */


use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class  extends Migration
{
        /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::disableForeignKeyConstraints();
        Schema::dropIfExists('panti_detail');
        Schema::create('panti_detail', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('pantiID');
            $table->text('name');
            $table->unsignedInteger('organizer');
            $table->text('address');
            $table->integer('child_number')->default('10');
            $table->date('founding_date')->nullable();
            $table->integer('donation_total')->default('5000000');
            $table->integer('priority_value')->nullable();
            $table->text('description')->nullable();
            $table->json('origin');
            
            $table->index(["organizer"], 'userID_idx');


            $table->foreign('organizer')
                ->references('userID')->on('user')
                ->onDelete('no action')
                ->onUpdate('no action');
        });
 Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down()
    {
        Schema::dropIfExists('panti_detail');
    }
};
