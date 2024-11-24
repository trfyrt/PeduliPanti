<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $table = 'product';
    protected $primaryKey = 'productID';
    public $timestamps = false;

    protected $fillable = [
        'categoryID',
        'name',
        'price',
        'description',
        'requestable',
        'image'
    ];

    public function category()
    {
        return $this->belongsTo(Category::class, 'categoryID', 'categoryID');
    }

    public function bundles()
    {
        return $this->belongsToMany(Bundle::class, 'bundle_product', 'productID', 'bundleID');
    }

    public function requests()
    {
        return $this->belongsToMany(RequestList::class, 'request_product', 'productID', 'requestID')
                    ->withPivot('requested_qty', 'donated_qty', 'status_approval');
    }
    
}
