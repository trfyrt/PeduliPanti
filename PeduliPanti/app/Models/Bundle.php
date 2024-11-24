<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Bundle extends Model
{
    use HasFactory;

    protected $table = 'bundle';
    protected $primaryKey = 'bundleID';
    public $timestamps = false;

    protected $fillable = [
        'name',
        'description',
        'price',
    ];

    public function products()
    {
        return $this->belongsToMany(Product::class, 'bundle_product', 'bundleID', 'productID');
    }
    

}
