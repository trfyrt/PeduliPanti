<?php

use App\Http\Controllers\Api\V1\BundleController;
use App\Http\Controllers\Api\V1\BundleProductController;
use App\Http\Controllers\Api\V1\CartController;
use App\Http\Controllers\Api\V1\CartProductBundleController;
use App\Http\Controllers\Api\V1\CategoryController;
use App\Http\Controllers\Api\V1\HistoryController;
use App\Http\Controllers\Api\V1\PantiDetailController;
use App\Http\Controllers\Api\V1\ProductController;
use App\Http\Controllers\Api\V1\RABController;
use App\Http\Controllers\Api\V1\RequestListController;
use App\Http\Controllers\Api\V1\RequestProductController;
use App\Http\Controllers\Api\V1\TransactionOrderController;
use App\Http\Controllers\Api\V1\UserController;
use App\Models\TransactionDetail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// api/v1
Route::group(['prefix' => 'v1', 'namespace' => 'App\Http\Controllers\Api\V1'], function(){
    Route::apiResource('bundle', BundleController::class);
    Route::apiResource('cart', CartController::class);
    Route::apiResource('category', CategoryController::class);
    Route::apiResource('panti_detail', PantiDetailController::class);
    Route::apiResource('product', ProductController::class);
    Route::apiResource('rab', RABController::class);
    Route::apiResource('request_list', RequestListController::class);
    Route::apiResource('transaction_order', TransactionOrderController::class);
    Route::apiResource('user', UserController::class);

    Route::patch('request_list/{id}/status', [RequestListController::class, 'updateStatus']);

    
    // Route::apiResource('bundle_product', BundleProductController::class);
    // Route::apiResource('cart_product_bundle', CartProductBundleController::class);
    // Route::apiResource('history', HistoryController::class);
    // Route::apiResource('request_product', RequestProductController::class);
});