<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class BundleProduct extends Model
{
    use HasFactory;

    protected $table = 'bundle_product';
    public $timestamps = false;

    protected $fillable = [
        'bundleID',
        'productID',
    ];
}
