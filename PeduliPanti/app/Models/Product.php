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
}