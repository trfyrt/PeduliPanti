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

        foreach (range(1, 10) as $index) {
            DB::table('request_list')->insert([
                'pantiID' => rand(1, 5), // Assuming you have 5 panti
                'productID' => rand(1, 20), // Assuming you have 20 products
                'requested_qty' => $faker->numberBetween(10, 100),
                'donated_qty' => $faker->numberBetween(0, 50),
                'status_approval' => $faker->randomElement(['approved', 'pending', 'rejected']),
            ]);
        }
    }
}

