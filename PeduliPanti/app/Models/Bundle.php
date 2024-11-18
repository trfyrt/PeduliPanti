<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

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
}
