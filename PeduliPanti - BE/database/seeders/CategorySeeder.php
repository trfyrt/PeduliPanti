<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    public function run()
    {
        $categories = [
            ['categoryID' => 1, 'category_name' => 'Makanan'],
            ['categoryID' => 2, 'category_name' => 'Minuman'],
            ['categoryID' => 3, 'category_name' => 'Pakaian'],
            ['categoryID' => 4, 'category_name' => 'Mainan'],
            ['categoryID' => 5, 'category_name' => 'Kebersihan'],
            ['categoryID' => 6, 'category_name' => 'Pendidikan'],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
