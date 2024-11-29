<?php
namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable, HasFactory;

    protected $table = 'user';
    protected $primaryKey = 'userID';
    public $timestamps = false;

    protected $fillable = [
        'name', 'email', 'password', 'role', 'image', 'status'
    ];

    protected $hidden = ['password'];

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

    public function roleRequests()
    {
        return $this->hasMany(RoleRequest::class, 'user_id', 'userID');
    }
}
