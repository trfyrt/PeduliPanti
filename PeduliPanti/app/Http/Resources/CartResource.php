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
            'user' => UserResource::collection($this->whenLoaded('user')),
            'products' => ProductResource::collection($this->whenLoaded('products')),
            'bundles' => BundleResource::collection($this->whenLoaded('bundles')),
            'requestLists' => RequestListResource::collection($this->whenLoaded('requestLists')),
        ];
    }
}