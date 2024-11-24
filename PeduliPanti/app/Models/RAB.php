<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RAB extends Model
{
    use HasFactory;

    protected $table = 'RAB';
    protected $primaryKey = 'RABID';
    public $timestamps = false;

    protected $fillable = [
        'pantiID',
        'pdf',
        'status',
    ];

    public function panti()
    {
        return $this->belongsTo(PantiDetail::class, 'pantiID', 'pantiID');
    }
}
