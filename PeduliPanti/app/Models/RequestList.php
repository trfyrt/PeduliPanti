<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestList extends Model
{
    use HasFactory;

    protected $table = 'request_list';
    protected $primaryKey = 'requestID';
    public $timestamps = false;

    protected $fillable = [
        'pantiID',
        'productID',
        'requested_qty',
        'donated_qty',
        'status_approval',
    ];

    public function panti()
    {
        return $this->belongsTo(PantiDetail::class, 'pantiID', 'pantiID');
    }

    public function products()
    {
        return $this->belongsTo(Product::class, 'requestID', 'productID');
    }
    
}
