import 'dart:convert';
import 'dart:io';
import 'package:donatur_peduli_panti/profileDonatur.dart';
import 'package:donatur_peduli_panti/Services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan package untuk memilih gambar
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfil extends StatelessWidget {
  const EditProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254)),
      home: const MyHomePage(title: 'Peduli Panti'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? pickedFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        pickedFile = File(picked.path);
      });
    }
  }

  // Fungsi untuk mengambil URL gambar profil dari SharedPreferences
  Future<String?> _getProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      return user['image'] ??
          null; // Pastikan 'profile_image' adalah key yang tepat
    }
    return null;
  }

  void _editProfile() async {
    final fields = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    Map<String, http.MultipartFile>? files;
    if (pickedFile != null) {
      files = {
        "image": await http.MultipartFile.fromPath(
          'image',
          pickedFile!.path,
        ),
      };
    }

    // Call the API function from api_service.dart
    await ApiService.updateUserWithMultipart(
      fields: fields,
      files: files,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        // Navigator.pop(context); // Kembali ke halaman sebelumnya
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 181, 255),
        toolbarHeight: 65,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(21),
            bottomRight: Radius.circular(21),
          ),
        ),
        title: Stack(
          children: [
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const Profiledonatur(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child; // Tidak ada animasi
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(
                    FontAwesomeIcons.angleLeft,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                'Edit Profil',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 112, 112, 112),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: FutureBuilder<String?>(
                    future:
                        _getProfileImageUrl(), // Fungsi untuk mendapatkan URL gambar dari SharedPreferences
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Icon(Icons.error));
                      } else if (snapshot.hasData && snapshot.data != null) {
                        // Menampilkan gambar profil dari URL yang diambil
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black
                                      .withOpacity(0.5), // Menggelapkan gambar
                                  BlendMode.darken,
                                ),
                                child: Image.network(
                                  snapshot
                                      .data!, // URL gambar profil yang diambil dari SharedPreferences
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Ikon edit di atas gambar
                            Positioned(
                              bottom: 2,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 147, 181, 255),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.solidPenToSquare,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                            child: Icon(FontAwesomeIcons
                                .solidPenToSquare)); // Jika tidak ada URL
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: nameController,
                label: 'Username',
                hintText: 'Masukkan username baru',
              ),
              _buildTextField(
                controller: emailController,
                label: 'Email',
                hintText: 'Masukkan email baru',
              ),
              _buildTextField(
                controller: passwordController,
                label: 'Password',
                hintText: 'Masukkan password baru',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 30),
                  backgroundColor: const Color.fromARGB(255, 171, 196, 255),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _editProfile,
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
