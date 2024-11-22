
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
        Schema::dropIfExists('request_product');
        Schema::create('request_product', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->unsignedInteger('requestID');
            $table->unsignedInteger('productID');
            $table->integer('requested_qty');
            $table->integer('donated_qty');
            $table->string('status_approval', 45);

            $table->index(["requestID"], 'requestID_idx');

            $table->index(["productID"], 'productID_idx');


            $table->foreign('requestID')
                ->references('requestID')->on('request_list')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('productID')
                ->references('productID')->on('product')
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
        Schema::dropIfExists('request_product');
    }
};
