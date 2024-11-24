<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\RequestListResource;
use App\Models\RequestList;
use Illuminate\Http\Request;

class RequestListController extends Controller
{
    public function index()
    {
        $requestLists = RequestList::with('panti', 'products')->get();
        return RequestListResource::collection($requestLists);
    }

    public function show($id)
    {
        $requestList = RequestList::with('panti', 'products')->findOrFail($id);
        return new RequestListResource($requestList);
    }

    public function store(Request $request)
    {
        $validated = $request->validate(['pantiID' => 'required|integer']);
        $requestList = RequestList::create($validated);
        return new RequestListResource($requestList);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate(['pantiID' => 'required|integer']);
        $requestList = RequestList::findOrFail($id);
        $requestList->update($validated);
        return new RequestListResource($requestList);
    }

    public function destroy($id)
    {
        $requestList = RequestList::findOrFail($id);
        $requestList->delete();
        return response()->json(['message' => 'RequestList deleted successfully'], 200);
    }
}