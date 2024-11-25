<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BundleResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->bundleID,
            'name' => $this->name,
            'description' => $this->description,
            'price' => $this->price,
            'products' => ProductResource::collection($this->whenLoaded('products')), // Relasi ke products
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