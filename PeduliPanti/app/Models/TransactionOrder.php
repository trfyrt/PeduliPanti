<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TransactionOrder extends Model
{
    use HasFactory;

    protected $table = 'transaction_order';
    protected $primaryKey = 'transactionID';

    protected $fillable = [
        'userID',
        'cartID',
        'method',
        'order_status',
    ];
}
