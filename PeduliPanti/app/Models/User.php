<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    use HasFactory;

    protected $table = 'user';
    protected $primaryKey = 'userID';
    public $timestamps = false;

    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        'image',
    ];

    public function cart()
    {
        return $this->hasOne(Cart::class, 'userID', 'userID');
    }

    public function pantiDetails()
    {
        return $this->hasOne(PantiDetail::class, 'organizer', 'userID');
    }

    public function transactions()
    {
        return $this->hasMany(TransactionOrder::class, 'userID', 'userID');
    }

    public function histories()
    {
        return $this->hasMany(History::class, 'userID', 'userID');
    }
    
}
