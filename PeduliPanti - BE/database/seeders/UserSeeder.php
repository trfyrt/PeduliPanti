<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Faker\Factory as Faker;

class UserSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        foreach (range(1, 10) as $index) {
            User::create([
                'name' => $faker->name,
                'email' => $faker->unique()->safeEmail,
                'password' => bcrypt('password'), // Default password
                'role' => 'donatur',
                'image' => null, // You can add a default image if needed
            ]);
        }
        foreach (range(1, 5) as $index) {
            User::create([
                'name' => $faker->name,
                'email' => $faker->unique()->safeEmail,
                'password' => bcrypt('password'), // Default password
                'role' => 'panti_asuhan',
                'image' => null, // You can add a default image if needed
            ]);
        }
        User::create([ //userID admin 16
            'name' => 'admin',
            'email' => 'admin@gmail.com',
            'password' => bcrypt('password'), // Default password
            'role' => 'admin',
            'image' => null, // You can add a default image if needed
        ]);
        User::create([ //userID yayasan 17
            'name' => 'yayasan',
            'email' => 'yayasan@gmail.com',
            'password' => bcrypt('password'), // Default password
            'role' => 'yayasan',
            'image' => null, // You can add a default image if needed
        ]);
    }
}
