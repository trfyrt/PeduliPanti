<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;


class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // Memanggil seeder untuk masing-masing tabel
        $this->call([
            UserSeeder::class, //don
            CategorySeeder::class, //don
            ProductSeeder::class, //don
            BundleSeeder::class, //don
            CartSeeder::class, //don
            PantiDetailSeeder::class, //don
            RequestListSeeder::class, //don
            // TransactionOrderSeeder::class,
            // HistorySeeder::class,
            RABSeeder::class,
        ]);
    }
}
