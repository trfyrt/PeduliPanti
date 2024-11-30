<?php

use App\Http\Controllers\Api\V1\UserController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthenticatedSessionController;


Route::middleware('auth:sanctum')->group(function () {
    Route::get('/users', [UserController::class, 'index']);
    Route::get('/users/{id}', [UserController::class, 'show']);
    Route::post('/users', [UserController::class, 'store']);
    Route::put('/users/{id}', [UserController::class, 'update']);
    Route::delete('/users/{id}', [UserController::class, 'destroy']);
    Route::post('/role-request', [UserController::class, 'requestRoleUpgrade']);
    Route::post('/process-role-request/{requestId}', [UserController::class, 'processRoleRequest']);
});

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
    
    Route::patch('request_list/{id}/status', [RequestListController::class, 'updateStatus']);

    Route::post('/register', [UserController::class, 'store']);
    Route::post('/login', [AuthenticatedSessionController::class, 'store']);
    Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->middleware('auth:sanctum');    
    
    
    // Route::apiResource('user', UserController::class);
    // Route::apiResource('bundle_product', BundleProductController::class);
    // Route::apiResource('cart_product_bundle', CartProductBundleController::class);
    // Route::apiResource('history', HistoryController::class);
    // Route::apiResource('request_product', RequestProductController::class);
});

