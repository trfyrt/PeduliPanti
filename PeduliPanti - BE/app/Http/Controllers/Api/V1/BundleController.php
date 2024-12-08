<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\BundleResource;
use App\Models\Bundle;
use App\Models\Product;
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
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'product_ids' => 'required|array',
        ]);
    
        // Menjumlah harga dari setiap product
        $products = Product::whereIn('productID', $validated['product_ids'])->get();
        $totalPrice = $products->sum('price');
        $bundleData = array_merge($validated, ['price' => $totalPrice]);
    
        $bundle = Bundle::create($bundleData);
    
        $bundle->products()->attach($validated['product_ids']);
    
        return new BundleResource($bundle);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'product_ids' => 'nullable|array',
        ]);
    
        $bundle = Bundle::findOrFail($id);
    
        if ($request->has('product_ids')) {
            $products = Product::whereIn('productID', $validated['product_ids'])->get();
    
            $totalPrice = $products->sum('price');
    
            $bundle->products()->sync($validated['product_ids']);
        } else {
            $totalPrice = $bundle->price;
        }
    
        $bundle->update(array_merge($validated, ['price' => $totalPrice]));
    
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