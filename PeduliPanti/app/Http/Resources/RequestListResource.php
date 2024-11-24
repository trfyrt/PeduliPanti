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
            'panti' => new PantiDetailResource($this->whenLoaded('panti')), // Relasi panti
            'products' => ProductResource::collection($this->whenLoaded('products')), // Relasi products
        ];
    }
}
