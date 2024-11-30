<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Models\RoleRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

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
            'email' => 'required|email|unique:user,email',
            'password' => 'required|string|min:6',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'role' => 'donatur',
            'status' => 'pending'
        ]);

        return new UserResource($user);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email',
            'password' => 'nullable|string|min:6',
        ]);

        $user = User::findOrFail($id);

        $updateData = [
            'name' => $validated['name'],
            'email' => $validated['email'],
        ];

        if ($request->has('password')) {
            $updateData['password'] = Hash::make($validated['password']);
        }

        $user->update($updateData);
        return new UserResource($user);
    }

    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->delete();
        return response()->json(['message' => 'User deleted successfully'], 200);
    }

    public function requestRoleUpgrade(Request $request)
    {
        $validated = $request->validate([
            'requested_role' => 'required|in:yayasan,panti_asuhan',
            'documents' => 'required|file|max:2048'
        ]);

        $documentPath = $request->file('documents')->store('role_requests');

        $roleRequest = RoleRequest::create([
            'user_id' => auth()->user()->userID,
            'requested_role' => $validated['requested_role'],
            'documents' => $documentPath,
            'status' => 'pending'
        ]);

        return response()->json(['message' => 'Role upgrade request submitted']);
    }

    public function processRoleRequest(Request $request, $requestId)
    {
        $validated = $request->validate([
            'status' => 'required|in:approved,rejected'
        ]);

        $roleRequest = RoleRequest::findOrFail($requestId);
        $roleRequest->status = $validated['status'];

        if ($validated['status'] == 'approved') {
            $user = $roleRequest->user;
            $user->role = $roleRequest->requested_role;
            $user->status = 'approved';
            $user->save();
        }

        $roleRequest->save();

        return response()->json(['message' => 'Role request processed']);
    }
}
