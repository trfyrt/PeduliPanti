<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\CartResource;
use App\Models\Cart;
use Illuminate\Http\Request;

class CartController extends Controller
{
    public function index()
    {
        $carts = Cart::with('products', 'bundles', 'requestLists')->get();
        return CartResource::collection($carts);
    }

    public function show($id)
    {
        $cart = Cart::with('products', 'bundles', 'requestLists')->findOrFail($id);
        return new CartResource($cart);
    }

    public function store(Request $request)
    {
        $validated = $request->validate(['userID' => 'required|integer']);
        $cart = Cart::create($validated);
        return new CartResource($cart);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate(['userID' => 'required|integer']);
        $cart = Cart::findOrFail($id);
        $cart->update($validated);
        return new CartResource($cart);
    }

    public function destroy($id)
    {
        $cart = Cart::findOrFail($id);
        $cart->delete();
        return response()->json(['message' => 'Cart deleted successfully'], 200);
    }
}