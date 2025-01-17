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
        $carts = Cart::with('user', 'products', 'bundles', 'requestLists')->get();
        return CartResource::collection($carts);
    }

    /**
     * Show by user Id.
     */
    public function show($id)
    {
        $cart = Cart::with(['products', 'bundles', 'requestLists'])
                    ->where('userID', $id)
                    ->firstOrFail();
        return new CartResource($cart);
    }

    /**
     * Store or update cart.
     */
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
    
        // Cek apakah user sudah memiliki cart
        $cart = Cart::where('userID', $validated['userID'])->first();
    
        if (!$cart) {
            // Jika belum ada cart, buat cart baru
            $cart = Cart::create(['userID' => $validated['userID']]);
        } else {
            // Jika sudah ada cart, hapus semua item yang terhubung untuk update data
            $cart->products()->detach();
            $cart->bundles()->detach();
            $cart->requestLists()->detach();
        }
    
        // Tambahkan Produk
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
    
        // Tambahkan Bundles
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
    
        // Tambahkan Request Lists
        if (isset($validated['requestLists'])) {
            foreach ($validated['requestLists'] as $requestData) {
                $requestList = RequestList::findOrFail($requestData['requestID']);
                $pantiID = $requestList->pantiID;
                $cart->requestLists()->attach($requestList->requestID, [
                    'quantity' => $requestData['quantity'],
                    'total_price' => 0, // Total price can be calculated based on logic
                    'pantiID' => $pantiID,
                ]);
            }
        }
    
        // Kembalikan cart dengan data relasi terbaru
        return new CartResource($cart->load(['products', 'bundles', 'requestLists']));
    }

    // public function update(Request $request, $id)
    // {
    //     // Validasi input request
    //     $validated = $request->validate([
    //         'products' => 'array',
    //         'products.*.productID' => 'required|integer',
    //         'products.*.quantity' => 'required|integer|min:1',
    //         'products.*.pantiID' => 'required|integer',
    
    //         'bundles' => 'array',
    //         'bundles.*.bundleID' => 'required|integer',
    //         'bundles.*.quantity' => 'required|integer|min:1',
    //         'bundles.*.pantiID' => 'required|integer',
    
    //         'requestLists' => 'array',
    //         'requestLists.*.requestID' => 'required|integer',
    //         'requestLists.*.quantity' => 'required|integer|min:1',
    //     ]);
    
    //     // Temukan keranjang berdasarkan ID
    //     $cart = Cart::findOrFail($id);
    
    //     // Simpan nilai userID agar tidak berubah
    //     $userID = $cart->userID;
    
    //     // Hapus hubungan lama untuk memperbarui barang di keranjang
    //     $cart->products()->detach();
    //     $cart->bundles()->detach();
    //     $cart->requestLists()->detach();
    
    //     // Tambahkan produk baru ke keranjang
    //     if (isset($validated['products'])) {
    //         foreach ($validated['products'] as $productData) {
    //             $product = Product::findOrFail($productData['productID']);
    //             $totalPrice = $product->price * $productData['quantity'];
    //             $cart->products()->attach($product->productID, [
    //                 'quantity' => $productData['quantity'],
    //                 'total_price' => $totalPrice,
    //                 'pantiID' => $productData['pantiID'],
    //             ]);
    //         }
    //     }
    
    //     // Tambahkan bundle baru ke keranjang
    //     if (isset($validated['bundles'])) {
    //         foreach ($validated['bundles'] as $bundleData) {
    //             $bundle = Bundle::findOrFail($bundleData['bundleID']);
    //             $totalPrice = $bundle->price * $bundleData['quantity'];
    //             $cart->bundles()->attach($bundle->bundleID, [
    //                 'quantity' => $bundleData['quantity'],
    //                 'total_price' => $totalPrice,
    //                 'pantiID' => $bundleData['pantiID'],
    //             ]);
    //         }
    //     }
    
    //     // Tambahkan request list baru ke keranjang
    //     if (isset($validated['requestLists'])) {
    //         foreach ($validated['requestLists'] as $requestData) {
    //             $requestList = RequestList::findOrFail($requestData['requestID']);
    //             $pantiID = $requestList->pantiID; 
    //             $cart->requestLists()->attach($requestList->requestID, [
    //                 'quantity' => $requestData['quantity'],
    //                 'total_price' => 0, // Harga total bisa dihitung sesuai logika lain
    //                 'pantiID' => $pantiID,
    //             ]);
    //         }
    //     }
    
    //     // Pastikan userID tetap tidak berubah
    //     $cart->userID = $userID;
    
    //     // Kembalikan resource keranjang yang diperbarui
    //     return new CartResource($cart->load(['products', 'bundles', 'requestLists']));
    // }
    
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