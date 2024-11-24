<?php

namespace App\Http\Controllers\Api\V1;


use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function index()
    {
        $users = User::with('cart', 'pantiDetails', 'transactions')->get();
        return UserResource::collection($users);
    }

    public function show($id)
    {
        $user = User::with('cart', 'pantiDetails', 'transactions')->findOrFail($id);
        return new UserResource($user);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email',
            'password' => 'required|string|min:6',
            'role' => 'required|string',
        ]);
        $user = User::create($validated);
        return new UserResource($user);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email',
            'password' => 'nullable|string|min:6',
            'role' => 'required|string',
        ]);
        $user = User::findOrFail($id);
        $user->update($validated);
        return new UserResource($user);
    }

    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->delete();
        return response()->json(['message' => 'User deleted successfully'], 200);
    }
}
