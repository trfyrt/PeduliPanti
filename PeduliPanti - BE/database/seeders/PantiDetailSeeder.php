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

        foreach (range(1, 10) as $index) {
            PantiDetail::create([
                'pantiID' => $index,
                'name' => $faker->word,
                'organizer' => ($index + 10),
                'address' => $faker->address,
                'child_number' => rand(10, 100),
                'founding_date' => $faker->date,
                'donation_total' => rand(100000, 100000000),
                'priority_value' => 0,
                'description' => $faker->paragraph,
                'origin' => json_encode([
                    'lat' => $faker->latitude(-5.3, -5.05), // Batas latitude untuk Makassar
                    'lng' => $faker->longitude(119.38, 119.50), // Batas longitude untuk Makassar
                ]),
            ]);
        }
    }
}


