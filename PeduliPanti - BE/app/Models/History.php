<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class History extends Model
{
    use HasFactory;

    protected $table = 'history';
    public $timestamps = false;

    protected $fillable = [
        'transactionID',
        'pantiID',
        'userID',
    ];

    public function transaction()
    {
        return $this->belongsTo(TransactionOrder::class, 'transactionID', 'transactionID');
    }

    public function panti()
    {
        return $this->belongsTo(PantiDetail::class, 'pantiID', 'pantiID');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'userID', 'userID');
    }
}
