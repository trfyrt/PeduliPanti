import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController childrenCountController = TextEditingController();
  File? profileImage; // Untuk menyimpan gambar profil yang dipilih

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker(); // Instance ImagePicker

  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1';

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
            nameController.text = data['data']['name'] ?? "Unknown";
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

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
      print(
          "Image selected: ${pickedFile.path}"); // Debugging: Menampilkan path gambar yang dipilih
    } else {
      print("No image selected"); // Debugging: Tidak ada gambar yang dipilih
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
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage, // Memilih gambar saat ditekan
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImage != null
                        ? FileImage(
                            profileImage!) // Jika ada gambar, tampilkan gambar
                        : AssetImage('assets/pedulipanti.png')
                            as ImageProvider, // Gambar default jika belum ada gambar yang dipilih
                    child: profileImage == null
                        ? Icon(Icons.camera_alt, color: Colors.white, size: 30)
                        : null, // Menampilkan ikon kamera jika gambar belum dipilih
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(
                  label: "Nama Pengurus",
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Pengurus tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
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
