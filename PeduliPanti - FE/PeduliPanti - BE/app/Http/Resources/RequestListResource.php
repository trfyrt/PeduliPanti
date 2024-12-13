<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RequestListResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->requestID,
            'pantiID' => $this->pantiID,
            'panti' => new PantiDetailResource($this->whenLoaded('panti')),
            'productID' => $this->productID,
            'product' => new ProductResource($this->whenLoaded('products')),
            'requested_qty' => $this->requested_qty,
            'donated_qty' => $this->donated_qty,
            'status_approval' => $this->status_approval,
            'pivot' => $this->whenPivotLoaded('cart_product_bundle', function () {
                return [
                    'quantity' => $this->pivot->quantity,
                    'total_price' => $this->pivot->total_price,
                    'pantiID' => $this->pivot->pantiID,
                ];
            }),
        ];
    }
}