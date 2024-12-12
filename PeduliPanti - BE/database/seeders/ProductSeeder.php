<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    public function run()
    {
        $products = [
            // Makanan
            ['categoryID' => 1, 'name' => 'Nasi Goreng Instan', 'price' => 15000, 'description' => 'Nasi goreng instan siap saji dengan rasa autentik.', 'requestable' => true, 'image' => null],
            ['categoryID' => 1, 'name' => 'Mie Ayam Frozen', 'price' => 20000, 'description' => 'Mie ayam beku yang mudah dipanaskan.', 'requestable' => true, 'image' => null],
            ['categoryID' => 1, 'name' => 'Keripik Singkong Pedas', 'price' => 5000, 'description' => 'Keripik singkong dengan rasa pedas gurih.', 'requestable' => true, 'image' => null],
            ['categoryID' => 1, 'name' => 'Biskuit Gandum', 'price' => 8000, 'description' => 'Biskuit sehat berbahan gandum utuh.', 'requestable' => true, 'image' => null],
            ['categoryID' => 1, 'name' => 'Kacang Almond Panggang', 'price' => 3000, 'description' => 'Kacang almond premium panggang.', 'requestable' => true, 'image' => null],

            // Minuman
            ['categoryID' => 2, 'name' => 'Teh Hijau Celup', 'price' => 40000, 'description' => 'Teh hijau celup kaya akan antioksidan.', 'requestable' => true, 'image' => null],
            ['categoryID' => 2, 'name' => 'Kopi Arabika Bubuk', 'price' => 12000, 'description' => 'Kopi arabika bubuk dengan aroma khas.', 'requestable' => true, 'image' => null],
            ['categoryID' => 2, 'name' => 'Susu Almond', 'price' => 25000, 'description' => 'Susu almond segar tanpa gula tambahan.', 'requestable' => true, 'image' => null],
            ['categoryID' => 2, 'name' => 'Jus Jeruk Botolan', 'price' => 6000, 'description' => 'Jus jeruk murni dalam kemasan botol.', 'requestable' => true, 'image' => null],
            ['categoryID' => 2, 'name' => 'Air Mineral 1 Liter', 'price' => 2000, 'description' => 'Air mineral berkualitas dalam botol 1 liter.', 'requestable' => true, 'image' => null],

            // Pakaian
            ['categoryID' => 3, 'name' => 'Kaos Polos Katun', 'price' => 10000, 'description' => 'Kaos polos berbahan katun nyaman.', 'requestable' => true, 'image' => null],
            ['categoryID' => 3, 'name' => 'Kemeja Flanel', 'price' => 75000, 'description' => 'Kemeja flanel dengan desain kasual.', 'requestable' => true, 'image' => null],
            ['categoryID' => 3, 'name' => 'Jaket Hoodie', 'price' => 70000, 'description' => 'Jaket hoodie hangat dan stylish.', 'requestable' => true, 'image' => null],
            ['categoryID' => 3, 'name' => 'Celana Jeans Slim Fit', 'price' => 80000, 'description' => 'Celana jeans slim fit dengan bahan berkualitas.', 'requestable' => true, 'image' => null],
            ['categoryID' => 3, 'name' => 'Rok Panjang Batik', 'price' => 50000, 'description' => 'Rok panjang dengan motif batik elegan.', 'requestable' => true, 'image' => null],

            // Mainan
            ['categoryID' => 4, 'name' => 'Puzzle Kayu Edukasi', 'price' => 15000, 'description' => 'Puzzle kayu edukatif untuk anak-anak.', 'requestable' => true, 'image' => null],
            ['categoryID' => 4, 'name' => 'Boneka Beruang Mini', 'price' => 12000, 'description' => 'Boneka beruang mini yang lembut.', 'requestable' => true, 'image' => null],
            ['categoryID' => 4, 'name' => 'Mobil-Mobilan Remote Control', 'price' => 50000, 'description' => 'Mobil remote control dengan baterai tahan lama.', 'requestable' => true, 'image' => null],
            ['categoryID' => 4, 'name' => 'Blok Bangunan Lego', 'price' => 40000, 'description' => 'Blok bangunan Lego untuk mengasah kreativitas.', 'requestable' => true, 'image' => null],
            ['categoryID' => 4, 'name' => 'Bola Plastik Anak', 'price' => 5000, 'description' => 'Bola plastik ringan untuk anak-anak.', 'requestable' => true, 'image' => null],

            // Kebersihan
            ['categoryID' => 5, 'name' => 'Sikat Gigi Bambu', 'price' => 6000, 'description' => 'Sikat gigi ramah lingkungan dari bambu.', 'requestable' => true, 'image' => null],
            ['categoryID' => 5, 'name' => 'Sabun Cuci Tangan Antibakteri', 'price' => 3000, 'description' => 'Sabun cuci tangan dengan formula antibakteri.', 'requestable' => true, 'image' => null],
            ['categoryID' => 5, 'name' => 'Cairan Pembersih Lantai Lemon', 'price' => 10000, 'description' => 'Cairan pembersih lantai dengan aroma lemon segar.', 'requestable' => true, 'image' => null],
            ['categoryID' => 5, 'name' => 'Tisu Basah Antiseptik', 'price' => 4000, 'description' => 'Tisu basah antiseptik untuk kebersihan ekstra.', 'requestable' => true, 'image' => null],
            ['categoryID' => 5, 'name' => 'Spons Cuci Piring Serbaguna', 'price' => 2000, 'description' => 'Spons serbaguna untuk membersihkan piring.', 'requestable' => true, 'image' => null],

            // Pendidikan
            ['categoryID' => 6, 'name' => 'Buku Matematika Dasar', 'price' => 50000, 'description' => 'Buku pelajaran matematika untuk siswa sekolah dasar.', 'requestable' => true, 'image' => null],
            ['categoryID' => 6, 'name' => 'Buku Bahasa Inggris Pemula', 'price' => 45000, 'description' => 'Buku panduan belajar Bahasa Inggris dasar untuk pemula.', 'requestable' => true, 'image' => null],
            ['categoryID' => 6, 'name' => 'Buku Catatan Bergaris', 'price' => 20000, 'description' => 'Buku catatan bergaris dengan sampul menarik untuk mencatat pelajaran.', 'requestable' => true, 'image' => null],
            ['categoryID' => 6, 'name' => 'Penggaris Multifungsi', 'price' => 15000, 'description' => 'Penggaris dengan berbagai fungsi, termasuk pengukur sudut.', 'requestable' => true, 'image' => null],
            ['categoryID' => 6, 'name' => 'Stabilo Neon (Paket 4 Warna)', 'price' => 30000, 'description' => 'Set stabilo berwarna neon untuk menyoroti teks penting.', 'requestable' => true, 'image' => null],            
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}
