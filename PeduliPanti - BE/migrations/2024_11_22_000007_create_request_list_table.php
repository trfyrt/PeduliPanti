
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
        Schema::dropIfExists('request_list');
        Schema::create('request_list', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->increments('requestID');
            $table->unsignedInteger('pantiID');
            $table->unsignedInteger('productID');
            $table->integer('requested_qty');
            $table->integer('donated_qty');
            $table->string('status_approval', 45)->default('pending');
            
            $table->index(["productID"], 'productID_idx');
            
            $table->index(["pantiID"], 'pantiID_idx');

            $table->foreign('productID')
                ->references('productID')->on('product')
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
        Schema::dropIfExists('request_list');
    }
};
