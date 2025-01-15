<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class RABResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->RABID,
            'pantiID' => $this->pantiID,
            'pdf' => $this->pdf ? base64_encode($this->pdf) : null,
            'status' => $this->status,
            'date' => $this->date,
            'panti' => new PantiDetailResource($this->whenLoaded('panti')), // Relasi panti
        ];
    }
}
