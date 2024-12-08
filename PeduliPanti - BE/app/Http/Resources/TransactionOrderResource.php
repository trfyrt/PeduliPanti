<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TransactionOrderResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->transactionID,
            'user_id' => $this->userID,
            'cart_id' => $this->cartID,
            'method' => $this->method,
            'order_status' => $this->order_status,
            'user' => new UserResource($this->whenLoaded('user')), // Relasi user
            'cart' => new CartResource($this->whenLoaded('cart')), // Relasi cart
            'histories' => HistoryResource::collection($this->whenLoaded('histories')), // Relasi histories
        ];
    }
}
