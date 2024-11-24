<?php

namespace Database\Seeders;

use App\Models\RequestList;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class RequestListSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 10) as $index) {
            RequestList::create([
                'requestID' => $index,
                'pantiID' => rand(1, 5), // Assuming you have 5 panti
            ]);
        }
    }
}

