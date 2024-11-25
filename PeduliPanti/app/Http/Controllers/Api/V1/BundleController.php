<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\BundleResource;
use App\Models\Bundle;
use Illuminate\Http\Request;

class BundleController extends Controller
{
    public function index()
    {
        // Eager load relasi 'products'
        $bundles = Bundle::with('products')->get();

        // Mengembalikan koleksi data BundleResource
        return BundleResource::collection($bundles);
    }

    public function show($id)
    {
        // Eager load relasi 'products'
        $bundle = Bundle::with('products')->findOrFail($id);

        // Mengembalikan data BundleResource
        return new BundleResource($bundle);
    }

    public function store(Request $request)
    {
        // Validasi input request
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric',
            'product_ids' => 'required|array',
        ]);

        // Membuat Bundle baru
        $bundle = Bundle::create($validated);

        // Attach produk terkait
        $bundle->products()->attach($request->product_ids);

        // Mengembalikan response dengan resource Bundle
        return new BundleResource($bundle);
    }

    public function update(Request $request, $id)
    {
        // Validasi input request
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric',
            'product_ids' => 'nullable|array',
        ]);

        // Menemukan Bundle yang akan diperbarui
        $bundle = Bundle::findOrFail($id);

        // Memperbarui informasi Bundle
        $bundle->update($validated);

        // Jika ada perubahan pada produk, update produk yang terhubung
        if ($request->has('product_ids')) {
            // Sync produk baru dengan Bundle
            $bundle->products()->sync($request->product_ids);
        }

        // Mengembalikan response dengan resource Bundle
        return new BundleResource($bundle);
    }

    public function destroy($id)
    {
        // Menemukan Bundle yang akan dihapus
        $bundle = Bundle::findOrFail($id);
    
        // Menghapus data terkait di junction table (bundle_product)
        $bundle->products()->detach();
    
        // Menghapus Bundle
        $bundle->delete();
    
        // Mengembalikan response sukses
        return response()->json(['message' => 'Bundle deleted successfully'], 200);
    }
}