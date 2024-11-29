<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;

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
        ]);
        $product = Product::create($validated);
        return new ProductResource($product);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'categoryID' => 'required|integer',
            'name' => 'required|string',
            'price' => 'required|numeric',
            'description' => 'nullable|string',
        ]);
        $product = Product::findOrFail($id);
        $product->update($validated);
        return new ProductResource($product);
    }

    public function destroy($id)
    {
        $product = Product::findOrFail($id);
        $product->delete();
        return response()->json(['message' => 'Product deleted successfully'], 200);
    }
}