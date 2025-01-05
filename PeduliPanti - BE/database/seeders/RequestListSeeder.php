<?php

namespace Database\Seeders;

use App\Models\RequestList;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RequestListSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();


        DB::table('request_list')->insert([
            'pantiID' => rand(1, 5), // Assuming you have 5 panti
            'productID' => rand(1, 25), // Assuming you have 20 products
            'requested_qty' => $faker->numberBetween(10, 100),
            'donated_qty' => $faker->numberBetween(0, 100),
            'status_approval' => 'approved',
        ]);
        DB::table('request_list')->insert([
            'pantiID' => rand(1, 5), // Assuming you have 5 panti
            'productID' => rand(1, 25), // Assuming you have 20 products
            'requested_qty' => $faker->numberBetween(10, 100),
            'donated_qty' => 0,
            'status_approval' => 'rejected',
        ]);
        DB::table('request_list')->insert([
            'pantiID' => rand(1, 5), // Assuming you have 5 panti
            'productID' => rand(1, 25), // Assuming you have 20 products
            'requested_qty' => $faker->numberBetween(10, 100),
            'donated_qty' => 0,
            'status_approval' => 'pending',
        ]);

    }
}

