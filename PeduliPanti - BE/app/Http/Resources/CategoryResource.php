<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CategoryResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->categoryID,
            'name' => $this->category_name,
            'products' => ProductResource::collection($this->whenLoaded('products')), // Relasi ke products
        ];
    }
}
