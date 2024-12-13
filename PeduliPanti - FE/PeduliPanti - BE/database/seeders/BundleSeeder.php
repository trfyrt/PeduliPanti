<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Bundle;
use App\Models\Product;

class BundleSeeder extends Seeder
{
    public function run()
    {
        $bundles = [
            [
                'bundleID' => 1,
                'name' => 'Paket Pakaian Kasual',
                'description' => 'Pakaian kasual untuk sehari-hari.',
                'price' => 285000,
                'product_ids' => [11, 12, 13, 14, 15] // ID produk dari kategori pakaian
            ],
            [
                'bundleID' => 2,
                'name' => 'Paket Mainan Anak',
                'description' => 'Mainan edukatif untuk anak panti.',
                'price' => 122000,
                'product_ids' => [16, 17, 18, 19, 20] // ID produk dari kategori mainan
            ],
            [
                'bundleID' => 3,
                'name' => 'Paket Pendidikan Anak',
                'description' => 'Alat pendukung pendidikan anak panti.',
                'price' => 190000,
                'product_ids' => [26, 27, 28, 29, 30] // ID produk dari kategori pendidikan
            ],
        ];

        foreach ($bundles as $bundleData) {
            $bundle = Bundle::create([
                'bundleID' => $bundleData['bundleID'],
                'name' => $bundleData['name'],
                'description' => $bundleData['description'],
                'price' => $bundleData['price'],
            ]);

            // Attach products to the bundle
            $bundle->products()->attach($bundleData['product_ids']);
        }
    }
}
