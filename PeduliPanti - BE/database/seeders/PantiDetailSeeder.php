<?php

namespace Database\Seeders;

use App\Models\PantiDetail;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class PantiDetailSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 5) as $index) {
            PantiDetail::create([
                'pantiID' => $index,
                'name' => $faker->word,
                'organizer' => rand(1, 10), // Assuming you have 10 users
                'address' => $faker->address,
                'child_number' => rand(10, 50),
                'founding_date' => $faker->date,
                'donation_total' => rand(1000, 10000),
                'priority_value' => rand(1, 10),
                'description' => $faker->paragraph,
            ]);
        }
    }
}


