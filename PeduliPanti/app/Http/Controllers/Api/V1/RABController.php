<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\RABResource;
use App\Models\RAB;
use Illuminate\Http\Request;

class RABController extends Controller
{
    public function index()
    {
        $rabs = RAB::with('panti')->get();
        return RABResource::collection($rabs);
    }

    public function show($id)
    {
        $rab = RAB::with('panti')->findOrFail($id);
        return new RABResource($rab);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'pantiID' => 'required|integer',
            'pdf' => 'nullable|file',
            'status' => 'required|string',
        ]);
        $rab = RAB::create($validated);
        return new RABResource($rab);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'pantiID' => 'required|integer',
            'pdf' => 'nullable|file',
            'status' => 'required|string',
        ]);
        $rab = RAB::findOrFail($id);
        $rab->update($validated);
        return new RABResource($rab);
    }

    public function destroy($id)
    {
        $rab = RAB::findOrFail($id);
        $rab->delete();
        return response()->json(['message' => 'RAB deleted successfully'], 200);
    }
}