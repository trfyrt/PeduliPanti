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
    public function __construct(Request $request)
    {
        $this->request = $request;
        \Midtrans\Config::$serverKey = config('services.midtrans.serverkey');
        \Midtrans\Config::$isProduction = (bool) config('services.midtrans.isProduction', false);
        \Midtrans\Config::$isSanitized = (bool) config('services.midtrans.isSanitized', true);
        \Midtrans\Config::$is3ds = (bool) config('services.midtrans.is3ds', true);
    }

    public function index()
    {
        // Return all orders as a JSON response
        return response()->json(Order::latest()->get());
    }

    public function payment(Request $request)
    {
        // Validate incoming request
        $validated = $request->validate([
            'name' => 'required|string',
            'qty' => 'required|integer|min:1',
            'price' => 'required|integer|min:1',
            'grand_total' => 'required|integer|min:1',
        ]);

        // Create a new transaction
        $no_transaction = 'Trx-' . Str::upper(mt_rand(100000, 999999));
        $order = new Order();
        $order->no_transaction = $no_transaction;
        $order->name = $validated['name'];
        $order->qty = $validated['qty'];
        $order->price = $validated['price'];
        $order->grand_total = $validated['grand_total'];

        // Prepare transaction data for Midtrans Core API
        $transaction_details = [
            'order_id' => $order->no_transaction,
            'gross_amount' => $order->grand_total,
        ];

        $item_details = [
            [
                'id' => $order->no_transaction,
                'price' => $order->price,
                'quantity' => $order->qty,
                'name' => 'Item - ' . $order->name,
            ],
        ];

        $customer_details = [
            'first_name' => $order->name,
        ];

        $transaction_data = [
            'payment_type' => 'gopay', // Set payment type (e.g., gopay, qris, etc.)
            'transaction_details' => $transaction_details,
            'item_details' => $item_details,
            'customer_details' => $customer_details,
        ];

        try {
            // Call Midtrans Core API to create the transaction
            $response = CoreApi::charge($transaction_data);

            // Save transaction details to the database
            $order->transaction_id = $response->transaction_id;
            $order->save();

            // Return response for Flutter frontend
            return response()->json([
                'status' => 'success',
                'qr_code_url' => $response->actions[0]->url, // QR Code URL
                'deeplink_url' => $response->actions[1]->url, // Deeplink URL
            ]);
        } catch (Exception $e) {
            // Log the error and return a failure response
            \Log::error('Payment error: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Payment could not be processed. Please try again.',
            ], 500);
        }
    }

    public function notificationHandler(Request $request)
    {
        // Handle Midtrans webhook notifications
        $notif = new Notification();

        // Find the order in the database
        $order = Order::where('no_transaction', $notif->order_id)->first();

        if (!$order) {
            return response()->json(['error' => 'Order not found'], 404);
        }

        // Update order status based on transaction status
        switch ($notif->transaction_status) {
            case 'settlement':
                $order->statis = 'paid';
                break;
            case 'pending':
                $order->statis = 'pending';
                break;
            case 'expire':
            case 'cancel':
            case 'deny':
                $order->statis = 'failed';
                break;
            default:
                return response()->json(['error' => 'Unknown transaction status'], 400);
        }

        $order->save();

        // Return a success response for Midtrans
        return response()->json(['status' => 'success'], 200);
    }
}
