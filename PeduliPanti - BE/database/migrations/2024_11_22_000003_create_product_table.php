
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
        Schema::dropIfExists('product');
        Schema::create('product', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('productID');
            $table->unsignedInteger('categoryID');
            $table->string('name', 45);
            $table->integer('price');
            $table->text('description');
            $table->tinyInteger('requestable');
            $table->binary('image')->nullable();

            $table->index(["categoryID"], 'categoryID_idx');


            $table->foreign('categoryID')
                ->references('categoryID')->on('category')
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
        Schema::dropIfExists('product');
    }
};
