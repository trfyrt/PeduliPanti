<?php

namespace App\Http\Controllers;

use Midtrans\Snap;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Models\Order;

class OrderController extends Controller
{
    //
    protected $request;

    public function __construct(Request $request)
    {
        $this->request = $request;
        \Midtrans\Config::$serverKey = config('services.midtrans.serverkey');
        \Midtrans\Config::$isProduction = config('services.midtrans.isProduction');
        \Midtrans\Config::$isSanitized = config('services.midtrans.isSanitized');
        \Midtrans\Config::$is3ds = config('services.midtrans.is3ds');


    }

    public function index()
    {
        return view('order',['orders' => Order::latest()->get()]);
    }

    public function payment(Request $request)
    {
        $no_transaction = 'Trx-' . Str::upper(mt_rand(100000, 999999));
        $order = new Order;
        $order->no_transaction = $no_transaction;
        $order->name = $request->input('name');
        $order->qty = $request->input('qty');
        $order->price = $request->input('price');
        $order->grand_total = $request->input('grand_total');

        $transaction_details = array(
            'order_id' => $order->no_transaction,
            'gross_amount' => $order->grand_total
        );

        $item_details = [
            array(
                'id' => $order->no_transaction,
                'price' => $order->price,
                'quantity' => $order->qty,
                'name' => 'Item -' . $order->name,
            )
            ];

            $customer_details = array(
                'first_name' => $order->name
            );

            $transaction_data = array(
                'transaction_details' => $transaction_details,
                'item_details' => $item_details,
                'customer_details' => $customer_details
            );

            try {
                $snap_token = Snap::getSnapToken($transaction_data);
                $order->snap_token = $snap_token;
            } catch (Exception $e) {
                return $e->getMessage();
            }

            $order->save();
            return to_route('order');

        }




}
