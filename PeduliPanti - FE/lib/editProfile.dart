import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile.dart'; // Import the profile page

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController childrenCountController = TextEditingController();
  File? pickedFile;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Define _formKey

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

  static const String _baseUrl = 'http://192.168.5.112:8000/api/v1';

  // Login Function
  static Future<void> login({
    required String email,
    required String password,
    required Function(String role)
        onLoginSuccess, // Callback for role-based navigation
    required Function(String error) onError, // Callback for handling errors
  }) async {
    final url = Uri.parse('$_baseUrl/login');
    final body = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];
        final role = user['role'];

        // Store the token securely
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString(
            'user', jsonEncode(user)); // Store user info for reuse

        print("Login successful. Token stored: $token");

        // Trigger role-based navigation
        onLoginSuccess(role);
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? "Unknown error occurred";
        print("Login failed: $errorMessage");
        onError(errorMessage);
      }
    } catch (e) {
      print("An error occurred during login: ${e.toString()}");
      onError("An unexpected error occurred. Please try again.");
    }
  }

  // Fungsi untuk mendapatkan token yang disimpan
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = jsonDecode(userJson);
        print("User ID: ${user['id']}");
        return user['id'];
      } else {
        print("User data not found in SharedPreferences.");
      }
    } catch (e) {
      print("Error retrieving user ID: $e");
    }
    return null;
  }

  // Fungsi untuk mengambil data user dari server
  Future<void> _fetchUserData() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        print("User ID is null. Ensure _getUserId() returns a valid ID.");
        return;
      }

      final url = Uri.parse('$_baseUrl/user/$userId');
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer ${await getToken()}"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Fetched data: $data");

        // Validasi struktur JSON
        if (data != null &&
            data['data'] != null &&
            data['data']['pantiDetails'] != null) {
          final pantiDetails = data['data']['pantiDetails'];

          // Update controller values dengan data yang diambil
          setState(() {
            descriptionController.text =
                pantiDetails['description'] ?? "No description";
            addressController.text = pantiDetails['address'] ?? "No address";
            childrenCountController.text =
                pantiDetails['childNumber']?.toString() ?? "0";
          });

          print("User data fetched and updated successfully.");
        } else {
          print("Invalid JSON structure: $data");
        }
      } else {
        print("Failed to fetch user data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: const Color.fromARGB(255, 196, 218, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Jika form valid, perbarui data pengguna
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Use the defined _formKey
          child: SingleChildScrollView(
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
                SizedBox(height: 30),
                _buildTextField(
                  label: "Deskripsi",
                  controller: descriptionController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Alamat",
                  controller: addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Jumlah Anak",
                  controller: childrenCountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah Anak tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method untuk membangun text field dengan validasi
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int? maxLines,
    TextInputType? keyboardType,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal
      child: TextFormField(
        controller: controller, // Gunakan controller langsung
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16), // Menambah ukuran font label
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                color: const Color.fromARGB(255, 181, 208, 255), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
