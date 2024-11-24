<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CartResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->cartID,
            'user' => new UserResource($this->whenLoaded('user')), // Relasi ke User
            'products' => ProductResource::collection($this->whenLoaded('products')), // Produk singular
            'bundles' => BundleResource::collection($this->whenLoaded('bundles')), // Bundles
            'requestLists' => RequestListResource::collection($this->whenLoaded('requestLists')), // Request lists
        ];
    }
}