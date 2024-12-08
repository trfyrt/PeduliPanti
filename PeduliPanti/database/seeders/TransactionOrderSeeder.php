<?php

namespace Database\Seeders;

use App\Models\TransactionOrder;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class TransactionOrderSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 10) as $index) {
            TransactionOrder::create([
                'transactionID' => $faker->uuid,
                'userID' => rand(1, 10), // Assuming you have 10 users
                'cartID' => rand(1, 10),  // Assuming you have 10 carts
                'method' => $faker->randomElement(['credit_card', 'bank_transfer']),
                'order_status' => $faker->randomElement(['pending', 'completed', 'canceled']),
            ]);
        }
    }
}
