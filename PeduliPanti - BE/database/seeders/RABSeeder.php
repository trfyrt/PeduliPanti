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
                'pdf' => file_get_contents(storage_path('app/public/sample.pdf')),
                'status' => $faker->randomElement(['approved', 'pending', 'rejected']),
                'date' => $faker->date()
            ]);
        }

        RAB::create([
            'RABID' => 6,
            'pantiID' => 1,
            'pdf' => file_get_contents(storage_path('app/public/sample.pdf')),
            'status' => 'approved',
            'date' => $faker->date()
        ]);
    }
}

