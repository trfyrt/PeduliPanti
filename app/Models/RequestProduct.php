<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestProduct extends Model
{
    use HasFactory;

    protected $table = 'request_product';
    public $timestamps = false;

    protected $fillable = [
        'requestID',
        'productID',
        'requested_qty',
        'donated_qty',
        'status_approval',
    ];
}
