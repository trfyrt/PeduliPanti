<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\RequestListResource;
use App\Models\RequestList;
use Illuminate\Http\Request;

class RequestListController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $requestLists = RequestList::with(['panti', 'products'])->get();
        return RequestListResource::collection($requestLists);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'pantiID' => 'required|integer|exists:panti_detail,pantiID',
            'productID' => 'required|integer|exists:product,productID',
            'requested_qty' => 'required|integer|min:1',
            'donated_qty' => 'nullable|integer|min:0',
        ]);

        $requestList = RequestList::create($validated);

        return new RequestListResource($requestList->load(['panti', 'products']));
    }

    public function show($id)
    {
        $requestList = RequestList::with(['panti', 'products'])->findOrFail($id);
        return new RequestListResource($requestList);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'pantiID' => 'sometimes|required|integer|exists:panti_detail,pantiID',
            'productID' => 'sometimes|required|integer|exists:product,productID',
            'requested_qty' => 'sometimes|required|integer|min:1',
            'donated_qty' => 'nullable|integer|min:0',
            'status_approval' => 'required|string|max:45', // Validasi input
        ]);

        $requestList = RequestList::findOrFail($id);
        $requestList->update($validated);

        return new RequestListResource($requestList->load(['panti', 'products']));
    }

    public function updateStatus(Request $request, $id)
    {
    $validated = $request->validate([
        'status_approval' => 'required|string|max:45', // Validasi input
    ]);

    $requestList = RequestList::findOrFail($id);

    $requestList->status_approval = $validated['status_approval'];
    $requestList->save();

    return response()->json([
        'message' => 'Status updated successfully',
        'data' => $requestList,
    ], 200);
    }

    public function destroy($id)
        {
            $requestList = RequestList::findOrFail($id);
            $requestList->delete();

            return response()->json(['message' => 'Request List deleted successfully'], 200);
        }
    }