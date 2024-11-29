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
    ];

    public function panti()
    {
        return $this->belongsTo(PantiDetail::class, 'pantiID', 'pantiID');
    }

    public function products()
    {
        return $this->belongsToMany(Product::class, 'request_product', 'requestID', 'productID')
                    ->withPivot('requested_qty', 'donated_qty', 'status_approval');
    }
    
}
