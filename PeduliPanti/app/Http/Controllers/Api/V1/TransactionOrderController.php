<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionOrderResource;
use App\Models\TransactionOrder;
use Illuminate\Http\Request;

class TransactionOrderController extends Controller
{
    public function index()
    {
        $transactions = TransactionOrder::with('user', 'cart', 'histories')->get();
        return TransactionOrderResource::collection($transactions);
    }

    public function show($id)
    {
        $transaction = TransactionOrder::with('user', 'cart', 'histories')->findOrFail($id);
        return new TransactionOrderResource($transaction);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'userID' => 'required|integer',
            'cartID' => 'required|integer',
            'method' => 'required|string',
            'order_status' => 'required|string',
        ]);
        $transaction = TransactionOrder::create($validated);
        return new TransactionOrderResource($transaction);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'userID' => 'required|integer',
            'cartID' => 'required|integer',
            'method' => 'required|string',
            'order_status' => 'required|string',
        ]);
        $transaction = TransactionOrder::findOrFail($id);
        $transaction->update($validated);
        return new TransactionOrderResource($transaction);
    }

    public function destroy($id)
    {
        $transaction = TransactionOrder::findOrFail($id);
        $transaction->delete();
        return response()->json(['message' => 'TransactionOrder deleted successfully'], 200);
    }

    public function showByUser($id)
    {
        $transactions = TransactionOrder::where('userID', $id)->get();

        if ($transactions->isEmpty()) {
            return response()->json([
                'message' => 'No transactions found for this user.'
            ], 404);
        }
        
        return TransactionOrderResource::collection($transactions);;
    }
}
