<?php

namespace Database\Seeders;

use App\Models\Cart;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class CartSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 10) as $index) {
            Cart::create([
                'cartID' => $index,
                'userID' => $index, // Assuming you have 10 users
            ]);
        }
    }
}
