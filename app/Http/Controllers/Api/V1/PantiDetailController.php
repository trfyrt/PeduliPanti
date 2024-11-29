<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\PantiDetailResource;
use App\Models\PantiDetail;
use Illuminate\Http\Request;

class PantiDetailController extends Controller
{
    public function index()
    {
        $pantiDetails = PantiDetail::with('organizer', 'requestLists', 'RABs', 'histories')->get();
        return PantiDetailResource::collection($pantiDetails);
    }

    public function show($id)
    {
        $pantiDetail = PantiDetail::with('organizer', 'requestLists', 'RABs', 'histories')->findOrFail($id);
        return new PantiDetailResource($pantiDetail);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'organizer' => 'required|integer',
            'name' => 'required|string',
            'address' => 'required|string',
        ]);
        $pantiDetail = PantiDetail::create($validated);
        return new PantiDetailResource($pantiDetail);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'organizer' => 'required|integer',
            'name' => 'required|string',
            'address' => 'required|string',
        ]);
        $pantiDetail = PantiDetail::findOrFail($id);
        $pantiDetail->update($validated);
        return new PantiDetailResource($pantiDetail);
    }

    public function destroy($id)
    {
        $pantiDetail = PantiDetail::findOrFail($id);
        $pantiDetail->delete();
        return response()->json(['message' => 'PantiDetail deleted successfully'], 200);
    }
}