<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class RoleRequest extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'requested_role', 'documents', 'status'
    ];

    /**
     * Define a relationship to the User model.
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'userID');
    }

    /**
     * Scope to filter by status.
     */
    public function scopeByStatus($query, $status)
    {
        return $query->where('status', $status);
    }

    /**
     * Scope to filter by requested role.
     */
    public function scopeByRole($query, $role)
    {
        return $query->where('requested_role', $role);
    }
}
