<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->userID,
            'name' => $this->name,
            'email' => $this->email,
            'role' => $this->role,
            'image' => $this->image ? asset('storage/' . $this->image) : null,
            'cart' => new CartResource($this->whenLoaded('cart')), // Relasi cart
            'pantiDetails' => new PantiDetailResource($this->whenLoaded('pantiDetails')), // Relasi pantiDetails
            'transactions' => TransactionOrderResource::collection($this->whenLoaded('transactions')), // Relasi transactions
            'histories' => HistoryResource::collection($this->whenLoaded('histories')), // Relasi histories
        ];
    }
}
