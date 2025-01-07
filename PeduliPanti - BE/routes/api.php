<?php

use App\Http\Controllers\Api\V1\UserController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthenticatedSessionController;
use App\Http\Controllers\Api\V1\BundleController;
use App\Http\Controllers\Api\V1\CartController;
use App\Http\Controllers\Api\V1\CategoryController;
use App\Http\Controllers\Api\V1\PantiDetailController;
use App\Http\Controllers\Api\V1\ProductController;
use App\Http\Controllers\Api\V1\RABController;
use App\Http\Controllers\Api\V1\RequestListController;
use App\Http\Controllers\Api\V1\TransactionOrderController;
use App\Http\Controllers\Api\V1\OrderController;

// api/v1
Route::group(['prefix' => 'v1', 'namespace' => 'App\Http\Controllers\Api\V1'], function(){
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/user', [UserController::class, 'index']);
        Route::get('/user/{id}', [UserController::class, 'show']);
        Route::post('/user', [UserController::class, 'store']);
        Route::put('/user/{id}', [UserController::class, 'update']);
        Route::delete('/user/{id}', [UserController::class, 'destroy']);
    });

    Route::apiResource('bundle', BundleController::class);
    Route::apiResource('cart', CartController::class);
    Route::apiResource('category', CategoryController::class);
    Route::apiResource('panti_detail', PantiDetailController::class);
    Route::apiResource('product', ProductController::class);
    Route::apiResource('rab', RABController::class);
    Route::apiResource('request_list', RequestListController::class);
    Route::apiResource('transaction_order', TransactionOrderController::class);

    Route::get('/history/{id}', [TransactionOrderController::class, 'showByUser']);

    Route::patch('panti_detail/{id}/calculate', [PantiDetailController::class, 'calculatePriorities']);

    Route::patch('request_list/{id}/status', [RequestListController::class, 'updateStatus']);

    Route::post('/register', [UserController::class, 'store']);
    Route::post('/login', [AuthenticatedSessionController::class, 'store']);
    Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->middleware('auth:sanctum');

    
    Route::get('/orders', [OrderController::class, 'index']);
    Route::post('/orders/payment', [OrderController::class, 'payment']);
    Route::post('/orders/notification', [OrderController::class, 'notificationHandler']);

    // Route::apiResource('user', UserController::class);
    // Route::apiResource('bundle_product', BundleProductController::class);
    // Route::apiResource('cart_product_bundle', CartProductBundleController::class);
    // Route::apiResource('history', HistoryController::class);
    // Route::apiResource('request_product', RequestProductController::class);
});

