<?php

namespace Database\Seeders;

use App\Models\Product;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 20) as $index) {
            Product::create([
                'categoryID' => rand(1, 5), // Assuming you have 5 categories
                'name' => $faker->word,
                'price' => rand(100, 500),
                'description' => $faker->paragraph,
                'requestable' => $faker->boolean,
                'image' => null, // You can add default image if needed
            ]);
        }
    }
}
