<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PantiDetail extends Model
{
    use HasFactory;

    protected $table = 'panti_detail';
    protected $primaryKey = 'pantiID';
    public $timestamps = false;

    protected $fillable = [
        'organizer',
        'name',
        'address',
        'child_number',
        'founding_date',
        'donation_total',
        'priority_value',
        'description',
    ];
}
