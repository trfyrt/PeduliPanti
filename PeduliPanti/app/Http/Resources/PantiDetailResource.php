<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PantiDetailResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->pantiID,
            'name' => $this->name,
            'address' => $this->address,
            'childNumber' => $this->child_number,
            'foundingDate' => $this->founding_date,
            'donationTotal' => $this->donation_total,
            'priorityValue' => $this->priority_value,
            'description' => $this->description,
            'requestLists' => RequestListResource::collection($this->whenLoaded('requestLists')), // Relasi requestLists
            'rabs' => RABResource::collection($this->whenLoaded('RABs')), // Relasi RABs
            'histories' => HistoryResource::collection($this->whenLoaded('histories')), // Relasi histories
        ];
    }
}
