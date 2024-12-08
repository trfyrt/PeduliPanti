<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RABResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->RABID,
            'pantiID' => $this->pantiID,
            'pdf' => $this->pdf,
            'status' => $this->status,
            'panti' => new PantiDetailResource($this->whenLoaded('panti')), // Relasi panti
        ];
    }
}
