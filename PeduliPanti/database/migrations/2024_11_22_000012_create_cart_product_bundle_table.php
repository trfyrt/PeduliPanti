
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
        Schema::dropIfExists('cart_product_bundle');
        Schema::create('cart_product_bundle', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->unsignedInteger('cartID');
            $table->unsignedInteger('pantiID');
            $table->unsignedInteger('requestID')->nullable();
            $table->unsignedInteger('productID')->nullable();
            $table->unsignedInteger('bundleID')->nullable();
            $table->integer('quantity');
            $table->integer('total_price');

            $table->index(["productID"], 'productID_idx');

            $table->index(["bundleID"], 'bundleID_idx');

            $table->index(["cartID"], 'cartID_idx');

            $table->index(["requestID"], 'requestID_idx');

            $table->index(["pantiID"], 'pantiID_idx');


            $table->foreign('productID')
                ->references('productID')->on('product')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('bundleID')
                ->references('bundleID')->on('bundle')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('cartID')
                ->references('cartID')->on('cart')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('requestID')
                ->references('requestID')->on('request_list')
                ->onDelete('no action')
                ->onUpdate('no action');

            $table->foreign('pantiID')
                ->references('pantiID')->on('panti_detail')
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
        Schema::dropIfExists('cart_product_bundle');
    }
};
