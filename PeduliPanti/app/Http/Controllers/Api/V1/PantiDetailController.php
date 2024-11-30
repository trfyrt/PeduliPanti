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
            'origin' => 'required|array', // Validasi sebagai array
        ]);
    
        // Encode `origin` menjadi JSON
        $validated['origin'] = json_encode($validated['origin']);
    
        // Simpan data ke database
        $pantiDetail = PantiDetail::create($validated);
        
        return new PantiDetailResource($pantiDetail);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'organizer' => 'required|integer',
            'name' => 'required|string',
            'address' => 'required|string',
            'origin' => 'required|array', // Validasi sebagai array
        ]);
    
        // Encode `origin` menjadi JSON
        $validated['origin'] = json_encode($validated['origin']);

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

    public function calculatePriorities(Request $request, $id)
    {
        // KONSTANTA
        $w1 = 0.3; // Bobot lokasi
        $w2 = 0.4; // Bobot donasi
        $w3 = 0.3; // Bobot kesejahteraan
        $eachNeeds = 686000; // Kebutuhan per kepala (tiap anak)

        $pantiDetail = PantiDetail::findOrFail($id);
    
        // Validasi input skor kesejahteraan
        $validated = $request->validate([
            'welfare_score' => 'required|numeric|min:0|max:100', // Skor kesejahteraan 0 - 100
        ]);
    
        // Asumsi koordinat pusat kota Makassar -> Pettarani (Taman pakui)
        $center = [-5.151495219992562, 119.43695762429633];
    
        // Ambil koordinat origin dari panti asuhan
        $origin = json_decode($pantiDetail->origin, true);

        if (!isset($origin['lat']) || !isset($origin['lng'])) {
            return response()->json([
                'message' => 'Origin data is incomplete',
            ], 400);
        }
    
        // Hitung skor lokasi menggunakan Haversine
        $locationDistance = $this->haversineDistance([$origin['lat'], $origin['lng']], $center);
    
        // Skor lokasi: semakin jauh jaraknya, semakin tinggi skornya
        $locationScore = $this->calculateLocationScore($locationDistance);

        // Hitung breakpoint berdasarkan jumlah anak
        $breakpoint = $pantiDetail->child_number * $eachNeeds;
    
        // Skor donasi: semakin dekat dengan breakpoint, semakin rendah skornya
        $donationScore = $this->calculateDonationScore($pantiDetail->donation_total, $breakpoint);
    
        // Ambil skor kesejahteraan dari request
        $welfareScore = $validated['welfare_score'];
    
        // Rumus IPD (Index Prioritas Donasi/Priority Value)
        $ipd = ($w1 * $locationScore) + ($w2 * $donationScore) + ($w3 * (100 - $welfareScore));

        $pantiDetail->priority_value = $ipd;
        $pantiDetail->save();

        return response()->json([
            'panti' => $pantiDetail->name,
            'location_score' => $locationScore,
            'donation_score' => $donationScore,
            'welfare_score' => $welfareScore,
            'priority_value' => $ipd,
        ]);
    }
    
    private function haversineDistance($origin, $destination)
    {
        $radius = 6378; // Radius bumi dalam kilometer
    
        list($lat1, $lon1) = $origin;
        list($lat2, $lon2) = $destination;
    
        $dlat = deg2rad($lat2 - $lat1);
        $dlon = deg2rad($lon2 - $lon1);
    
        $a = sin($dlat / 2) * sin($dlat / 2) +
             cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
             sin($dlon / 2) * sin($dlon / 2);
    
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    
        return $radius * $c; // Hasil dalam kilometer
    }
    
    private function calculateLocationScore($distance)
    {
        // Konversi jarak ke skor (semakin jauh, semakin besar skornya)
        // Misalnya: jarak > 50 km dapat skor 100, jarak <= 5 km dapat skor 0
        if ($distance > 50) {
            return 100;
        } elseif ($distance <= 5) {
            return 0;
        } else {
            return ($distance / 50) * 100;
        }
    }
    
    private function calculateDonationScore($donationTotal, $breakpoint)
    {
        // Semakin mendekati breakpoint, semakin rendah skornya
        if ($donationTotal >= $breakpoint) {
            return 0;
        } else {
            $difference = $breakpoint - $donationTotal;
            return ($difference / $breakpoint) * 100;
        }
    }
}