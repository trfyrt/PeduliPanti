<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BundleDetail extends Model
{
    use HasFactory;

    protected $table = 'bundle_detail';
    public $timestamps = false;

    protected $fillable = [
        'bundleID',
        'productID',
    ];
}
