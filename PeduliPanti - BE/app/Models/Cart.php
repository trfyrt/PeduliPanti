<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cart extends Model
{
    use HasFactory;

    protected $table = 'cart';
    protected $primaryKey = 'cartID';
    public $timestamps = false;

    protected $fillable = [
        'userID',
    ];

    public function user()
    {
        return $this->hasOne(User::class, 'userID', 'userID');
    }    

    public function products()
    {
        return $this->belongsToMany(Product::class, 'cart_product_bundle', 'cartID', 'productID')
            ->withPivot('quantity', 'total_price', 'pantiID');
    }
    
    public function bundles()
    {
        return $this->belongsToMany(Bundle::class, 'cart_product_bundle', 'cartID', 'bundleID')
            ->withPivot('quantity', 'total_price', 'pantiID');
    }
    
    public function requestLists()
    {
        return $this->belongsToMany(RequestList::class, 'cart_product_bundle', 'cartID', 'requestID')
            ->withPivot('quantity', 'total_price', 'pantiID');
    }        
}
