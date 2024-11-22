
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
        Schema::dropIfExists('transaction_order');
        Schema::create('transaction_order', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->string('transactionID', 45)->primary();
            $table->unsignedInteger('userID');
            $table->unsignedInteger('cartID');
            $table->string('method', 45);
            $table->string('order_status', 45);
            $table->timestamps();

            $table->index(["cartID"], 'cartID_idx');

            $table->index(["userID"], 'userID_idx');


            $table->foreign('cartID')
                ->references('cartID')->on('cart')
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
        Schema::dropIfExists('transaction_order');
    }
};
