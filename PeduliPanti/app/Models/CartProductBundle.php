<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CartProductBundle extends Model
{
    use HasFactory;

    protected $table = 'cart_product_bundle';
    public $timestamps = false;

    protected $fillable = [
        'cartID',
        'pantiID',
        'requestID',
        'productID',
        'bundleID',
        'quantity',
        'total_price'
    ];
}
