<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    // Allow mass assignment for all fields
    protected $guarded = [];

    // Define constants for order statuses
    const STATUS_PENDING = 'pending';
    const STATUS_PAID = 'paid';
    const STATUS_FAILED = 'failed';

    /**
     * Accessor for formatted price (optional, for display purposes)
     */
    public function getFormattedPriceAttribute()
    {
        return 'Rp ' . number_format($this->price, 0, ',', '.');
    }

    /**
     * Accessor for formatted grand total (optional, for display purposes)
     */
    public function getFormattedGrandTotalAttribute()
    {
        return 'Rp ' . number_format($this->grand_total, 0, ',', '.');
    }

    /**
     * Scope for filtering orders by status
     */
    public function scopeByStatus($query, $status)
    {
        return $query->where('statis', $status);
    }

    /**
     * Method to check if the order is paid
     */
    public function isPaid()
    {
        return $this->statis === self::STATUS_PAID;
    }
}
