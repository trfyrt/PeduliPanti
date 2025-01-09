<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->productID,
            'name' => $this->name,
            'price' => $this->price,
            'description' => $this->description,
            'requestable' => $this->requestable,
            'image' => $this->image ? asset('storage/' . $this->image) : null,
            'category' => new CategoryResource($this->whenLoaded('category')), // Relasi kategori
            'bundles' => BundleResource::collection($this->whenLoaded('bundles')), // Relasi bundle
            'requests' => RequestListResource::collection($this->whenLoaded('requests')), // Relasi request
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