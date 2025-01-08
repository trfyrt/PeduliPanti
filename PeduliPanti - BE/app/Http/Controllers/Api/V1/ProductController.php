<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::with('category', 'bundles', 'requests')->get();
        return ProductResource::collection($products);
    }

    public function show($id)
    {
        $product = Product::with('category', 'bundles', 'requests')->findOrFail($id);
        return new ProductResource($product);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'categoryID' => 'required|integer',
            'name' => 'required|string',
            'price' => 'required|numeric',
            'description' => 'nullable|string',
            'image' => 'nullable|image|max:2048', // Validasi untuk gambar (nullable dan maksimal 2MB)
            'requestable' => 'boolean'
        ]);
    
        // Jika ada file gambar, simpan ke storage dan tambahkan path ke data yang divalidasi
        if ($request->hasFile('image')) {
            $validated['image'] = $request->file('image')->store('products', 'public');
        }
    
        // Buat produk baru
        $product = Product::create($validated);
    
        // Kembalikan resource produk yang baru dibuat
        return new ProductResource($product);
    }
    
    public function update(Request $request, $id)
    {
        // Validasi input
        $validated = $request->validate([
            'categoryID' => 'required|integer',
            'name' => 'required|string',
            'price' => 'required|numeric',
            'description' => 'nullable|string',
            'image' => 'nullable|image|max:2048', // Validasi untuk gambar (nullable dan maksimal 2MB)
            'requestable' => 'boolean'
        ]);
    
        // Temukan produk berdasarkan ID
        $product = Product::findOrFail($id);
    
        // Jika ada file gambar baru yang diunggah
        if ($request->hasFile('image')) {
            // Hapus gambar lama jika ada
            if ($product->image) {
                Storage::disk('public')->delete($product->image);
            }
    
            // Simpan gambar baru ke storage
            $validated['image'] = $request->file('image')->store('products', 'public');
        }
    
        // Perbarui data produk
        $product->update($validated);
    
        // Kembalikan resource produk yang diperbarui
        return new ProductResource($product);
    }
    
    public function destroy($id)
    {
        $product = Product::findOrFail($id);
        $product->delete();
        return response()->json(['message' => 'Product deleted successfully'], 200);
    }
}