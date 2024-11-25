<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\CartResource;
use App\Models\Bundle;
use App\Models\Cart;
use App\Models\Product;
use App\Models\RequestList;
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
        $validated = $request->validate([
            'userID' => 'required|integer',
            'products' => 'array',
            'products.*.productID' => 'required|integer',
            'products.*.quantity' => 'required|integer|min:1',
            'products.*.pantiID' => 'required|integer',

            'bundles' => 'array',
            'bundles.*.bundleID' => 'required|integer',
            'bundles.*.quantity' => 'required|integer|min:1',
            'bundles.*.pantiID' => 'required|integer',

            'requestLists' => 'array',
            'requestLists.*.requestID' => 'required|integer',
            'requestLists.*.quantity' => 'required|integer|min:1',
        ]);

        // Create Cart
        $cart = Cart::create(['userID' => $validated['userID']]);

        // Attach Products
        if (isset($validated['products'])) {
            foreach ($validated['products'] as $productData) {
                $product = Product::findOrFail($productData['productID']);
                $totalPrice = $product->price * $productData['quantity'];
                $cart->products()->attach($product->productID, [
                    'quantity' => $productData['quantity'],
                    'total_price' => $totalPrice,
                    'pantiID' => $productData['pantiID'],
                ]);
            }
        }

        // Attach Bundles
        if (isset($validated['bundles'])) {
            foreach ($validated['bundles'] as $bundleData) {
                $bundle = Bundle::findOrFail($bundleData['bundleID']);
                $totalPrice = $bundle->price * $bundleData['quantity'];
                $cart->bundles()->attach($bundle->bundleID, [
                    'quantity' => $bundleData['quantity'],
                    'total_price' => $totalPrice,
                    'pantiID' => $bundleData['pantiID'],
                ]);
            }
        }

        // Attach Request Lists
        if (isset($validated['requestLists'])) {
            foreach ($validated['requestLists'] as $requestData) {
                $requestList = RequestList::findOrFail($requestData['requestID']);
                $pantiID = $requestList->pantiID; 
                $cart->requestLists()->attach($requestList->requestID, [
                    'quantity' => $requestData['quantity'],
                    'total_price' => 0, // Total price could be calculated dynamically based on other logic
                    'pantiID' => $pantiID,
                ]);
            }
        }

        return new CartResource($cart->load(['products', 'bundles', 'requestLists']));
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'userID' => 'required|integer',
            'products' => 'array',
            'products.*.productID' => 'required|integer',
            'products.*.quantity' => 'required|integer|min:1',
            'products.*.pantiID' => 'required|integer',

            'bundles' => 'array',
            'bundles.*.bundleID' => 'required|integer',
            'bundles.*.quantity' => 'required|integer|min:1',
            'bundles.*.pantiID' => 'required|integer',

            'requestLists' => 'array',
            'requestLists.*.requestID' => 'required|integer',
            'requestLists.*.quantity' => 'required|integer|min:1',
        ]);

        // Find the Cart to update
        $cart = Cart::findOrFail($id);

        // Update Cart details (if needed)
        $cart->update(['userID' => $validated['userID']]);

        // Detach existing relationships to remove old items
        $cart->products()->detach();
        $cart->bundles()->detach();
        $cart->requestLists()->detach();

        // Attach new Products
        if (isset($validated['products'])) {
            foreach ($validated['products'] as $productData) {
                $product = Product::findOrFail($productData['productID']);
                $totalPrice = $product->price * $productData['quantity'];
                $cart->products()->attach($product->productID, [
                    'quantity' => $productData['quantity'],
                    'total_price' => $totalPrice,
                    'pantiID' => $productData['pantiID'],
                ]);
            }
        }

        // Attach new Bundles
        if (isset($validated['bundles'])) {
            foreach ($validated['bundles'] as $bundleData) {
                $bundle = Bundle::findOrFail($bundleData['bundleID']);
                $totalPrice = $bundle->price * $bundleData['quantity'];
                $cart->bundles()->attach($bundle->bundleID, [
                    'quantity' => $bundleData['quantity'],
                    'total_price' => $totalPrice,
                    'pantiID' => $bundleData['pantiID'],
                ]);
            }
        }

        // Attach new Request Lists
        if (isset($validated['requestLists'])) {
            foreach ($validated['requestLists'] as $requestData) {
                $requestList = RequestList::findOrFail($requestData['requestID']);
                $pantiID = $requestList->pantiID; 
                $cart->requestLists()->attach($requestList->requestID, [
                    'quantity' => $requestData['quantity'],
                    'total_price' => 0, // Total price could be calculated dynamically based on other logic
                    'pantiID' => $pantiID,
                ]);
            }
        }

        // Return updated cart resource
        return new CartResource($cart->load(['products', 'bundles', 'requestLists']));
    }

    public function destroy($id)
    {
        // Find the Cart by ID
        $cart = Cart::findOrFail($id);

        // Detach related products, bundles, and request lists from the cart
        $cart->products()->detach();
        $cart->bundles()->detach();
        $cart->requestLists()->detach();

        // Delete the Cart
        $cart->delete();

        // Return success response
        return response()->json(['message' => 'Cart deleted successfully'], 200);
    }

}