<?php

namespace Database\Seeders;

use App\Models\History;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class HistorySeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 10) as $index) {
            History::create([
                'transactionID' => $faker->uuid,
                'pantiID' => rand(1, 5), // Assuming you have 5 panti
                'userID' => rand(1, 10), // Assuming you have 10 users
            ]);
        }
    }
}
