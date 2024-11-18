<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestList extends Model
{
    use HasFactory;

    protected $table = 'request_list';
    public $timestamps = false;

    protected $fillable = [
        'pantiID',
        'productID',
    ];
}
