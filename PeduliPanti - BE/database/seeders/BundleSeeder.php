<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

use App\Models\Bundle;
use Faker\Factory as Faker;

class BundleSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 5) as $index) {
            Bundle::create([
                'bundleID' => $index,
                'name' => $faker->word,
                'description' => $faker->sentence,
                'price' => rand(100, 1000),
            ]);
        }
    }
}

