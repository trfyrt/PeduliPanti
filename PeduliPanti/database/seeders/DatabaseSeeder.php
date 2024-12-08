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
            UserSeeder::class,
            CategorySeeder::class,
            ProductSeeder::class,
            BundleSeeder::class,
            CartSeeder::class,
            // PantiDetailSeeder::class,
            RequestListSeeder::class,
            TransactionOrderSeeder::class,
            // HistorySeeder::class,
            RABSeeder::class,
        ]);
    }
}
