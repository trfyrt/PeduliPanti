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
        'origin',
    ];

    protected $casts = [
        'origin' => 'array'
    ];

    public function organizer()
    {
        return $this->belongsTo(User::class, 'organizer', 'userID');
    }

    public function requestLists()
    {
        return $this->hasMany(RequestList::class, 'pantiID', 'pantiID');
    }

    public function RABs()
    {
        return $this->hasMany(RAB::class, 'pantiID', 'pantiID');
    }

    public function histories()
    {
        return $this->hasMany(History::class, 'pantiID', 'pantiID');
    }
    
}
