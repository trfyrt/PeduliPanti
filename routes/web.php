<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// Route::get('/order', function() {
//     return view('order');
// });

Route::get('/', [\App\Http\Controllers\OrderController::class,'index'])->name('order');
Route::post('/payment',[\App\Http\Controllers\OrderController::class,'payment'])->name('payment');
