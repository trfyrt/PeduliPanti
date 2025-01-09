<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Models\RoleRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;

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
            'role' => ['required', 'string', Rule::in(['admin', 'donatur', 'panti_asuhan', 'yayasan'])]
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'role' => $validated['role'],
        ]);

        return new UserResource($user);
    }

    public function update(Request $request, $id)
    {
        // Validasi input
        $validated = $request->validate([
            'name' => 'nullable|string|max:255',
            'image' => 'nullable|image|max:2048', // Pastikan image memiliki validasi sebagai file gambar
            'email' => 'nullable|email',
            'password' => 'nullable|string|min:6',
        ]);
    
        // Temukan user berdasarkan ID
        $user = User::findOrFail($id);
    
        // Jika password diisi, lakukan hashing dan masukkan ke dalam updateData
        if (!empty($validated['password'])) {
            $updateData['password'] = Hash::make($validated['password']);
        }

        if (!empty($validated['name'])) {
            $updateData['name'] = $validated['name'];
        }

        if (!empty($validated['email'])) {
            $updateData['email'] = $validated['email'];
        }
    
        // Cek apakah ada file gambar baru yang diunggah
        if ($request->hasFile('image')) {
            // Hapus gambar lama jika ada
            if ($user->image) {
                Storage::disk('public')->delete($user->image);
            }
    
            // Simpan gambar baru ke storage
            $path = $request->file('image')->store('profile', 'public');
    
            // Tambahkan path gambar baru ke dalam updateData
            $updateData['image'] = $path;
        }
    
        // Perbarui data user
        $user->update($updateData);
    
        // Kembalikan response
        return new UserResource($user);
    }

    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->delete();
        return response()->json(['message' => 'User deleted successfully'], 200);
    }
}
