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
                'organizer' => ($index + 10),
                'address' => $faker->address,
                'child_number' => rand(10, 50),
                'founding_date' => $faker->date,
                'donation_total' => rand(100000, 100000000),
                'priority_value' => 0,
                'description' => $faker->paragraph,
                'origin' => json_encode([
                    'lat' => $faker->latitude, // Generate random latitude
                    'lng' => $faker->longitude, // Generate random longitude
                ]),
            ]);
        }
    }
}


