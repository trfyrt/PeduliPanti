<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\CategoryResource;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Category::with('products')->get();
        return CategoryResource::collection($categories);
    }

    public function show($id)
    {
        $category = Category::with('products')->findOrFail($id);
        return new CategoryResource($category);
    }

    public function store(Request $request)
    {
        $validated = $request->validate(['category_name' => 'required|string']);
        $category = Category::create($validated);
        return new CategoryResource($category);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate(['category_name' => 'required|string']);
        $category = Category::findOrFail($id);
        $category->update($validated);
        return new CategoryResource($category);
    }

    public function destroy($id)
    {
        $category = Category::findOrFail($id);
        $category->delete();
        return response()->json(['message' => 'Category deleted successfully'], 200);
    }
}
