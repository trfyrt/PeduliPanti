<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TransactionDetail extends Model
{
    use HasFactory;

    protected $table = 'transaction_detail';
    protected $primaryKey = 'transactionID';
    public $timestamps = false;

    protected $fillable = [
        'userID',
        'productID',
        'bundleID',
        'date',
        'price_total',
        'method',
        'time',
    ];
}
