
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
        Schema::dropIfExists('bundle_product');
        Schema::create('bundle_product', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->unsignedInteger('bundleID');
            $table->unsignedInteger('productID');

            $table->index(["bundleID"], 'bundleID_idx');

            $table->index(["productID"], 'productID_idx');


            $table->foreign('bundleID')
                ->references('bundleID')->on('bundle')
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
        Schema::dropIfExists('bundle_product');
    }
};
