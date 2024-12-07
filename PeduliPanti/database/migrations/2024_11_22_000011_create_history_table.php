
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
        Schema::dropIfExists('history');
        Schema::create('history', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->unsignedInteger('transactionID');
            $table->unsignedInteger('pantiID');
            $table->unsignedInteger('userID');

            $table->index(["transactionID"], 'transactionID_idx');

            $table->index(["pantiID"], 'pantiID_idx');

            $table->index(["userID"], 'userID_idx');


            $table->foreign('transactionID')
                ->references('transactionID')->on('transaction_order')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('pantiID')
                ->references('pantiID')->on('panti_detail')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('userID')
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
        Schema::dropIfExists('history');
    }
};
