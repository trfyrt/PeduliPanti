<?php

namespace App\Http\Controllers\Api\V1;

use Exception;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Models\Order;
use Midtrans\CoreApi;
use Midtrans\Notification;
use App\Http\Controllers\Controller;

class OrderController extends Controller
{
    public function __construct()
    {
        // Set Midtrans configuration
        \Midtrans\Config::$serverKey = config('services.midtrans.serverkey');
        \Midtrans\Config::$isProduction = (bool) config('services.midtrans.isProduction', false);
        \Midtrans\Config::$isSanitized = (bool) config('services.midtrans.isSanitized', true);
        \Midtrans\Config::$is3ds = (bool) config('services.midtrans.is3ds', true);
    }

    public function payment(Request $request)
    {
        // Validate incoming request
        $validated = $request->validate([
            'name' => 'required|string',
            'payment_method' => 'required|string|in:ovo,gopay,dana',
            'amount' => 'required|integer|min:1',
        ]);

        // Create a new transaction
        $no_transaction = 'Trx-' . Str::upper(mt_rand(100000, 999999));
        $order = new Order();
        $order->no_transaction = $no_transaction;
        $order->name = $validated['name'];
        $order->payment_method = $validated['payment_method'];
        $order->amount = $validated['amount'];

        // Prepare transaction data for Midtrans Core API
        $transaction_data = [
            'payment_type' => $validated['payment_method'],
            'transaction_details' => [
                'order_id' => $order->no_transaction,
                'gross_amount' => $order->amount,
            ],
            'item_details' => [
                [
                    'id' => $order->no_transaction,
                    'price' => $order->amount,
                    'quantity' => 1,
                    'name' => "Top up {$validated['payment_method']}",
                ],
            ],
            'customer_details' => [
                'first_name' => $order->name,
            ],
        ];

        try {
            // Call Midtrans Core API to create the transaction
            $response = CoreApi::charge($transaction_data);

            // Save transaction details to the database
            $order->transaction_id = $response->transaction_id;
            $order->save();

            // Get the deeplink URL
            $deeplinkUrl = '';
            foreach ($response->actions as $action) {
                if ($action->name === 'deeplink-redirect') {
                    $deeplinkUrl = $action->url;
                    break;
                }
            }

            // Return response with deeplink URL
            return response()->json([
                'status' => 'success',
                'payment_method' => $validated['payment_method'],
                'transaction_id' => $response->transaction_id,
                'deeplink_url' => $deeplinkUrl,
            ]);

        } catch (Exception $e) {
            \Log::error('Payment error: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Payment could not be processed. Please try again.',
            ], 500);
        }
    }

    public function notificationHandler(Request $request)
    {
        $notif = new Notification();
        
        $order = Order::where('no_transaction', $notif->order_id)->first();
        
        if (!$order) {
            return response()->json(['error' => 'Order not found'], 404);
        }

        switch ($notif->transaction_status) {
            case 'settlement':
                $order->status = 'paid';
                break;
            case 'pending':
                $order->status = 'pending';
                break;
            case 'expire':
            case 'cancel':
            case 'deny':
                $order->status = 'failed';
                break;
            default:
                return response()->json(['error' => 'Unknown transaction status'], 400);
        }

        $order->save();
        return response()->json(['status' => 'success'], 200);
    }
}