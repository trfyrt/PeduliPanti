<?php

namespace Database\Seeders;

use App\Models\RAB;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class RABSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 5) as $index) {
            RAB::create([
                'RABID' => $index,
                'pantiID' => rand(1, 5),
                'pdf' => 'null', // You can add a PDF file if needed
                'status' => $faker->randomElement(['approved', 'pending', 'rejected']),
            ]);
        }
    }
}

