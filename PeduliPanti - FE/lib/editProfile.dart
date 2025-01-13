import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Corrected import statement


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController childrenCountController = TextEditingController();
  File? profileImage; // To store the selected profile image

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrphanageDetails(
      id: 1,
      onDataFetchSuccess: (data) {
        nameController.text = data['name'];
        descriptionController.text = data['description'];
        addressController.text = data['address'];
        childrenCountController.text = data['childrenCount'].toString();
      },
      onError: (error) {
        print("Error fetching orphanage details: $error");
      },
    );
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


  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Function to fetch orphanage details
  static Future<void> fetchOrphanageDetails({
    required int id,
    required Function(dynamic data) onDataFetchSuccess, // Callback for successful data fetch
    required Function(String error) onError, // Callback for handling errors
  }) async {
    final url = Uri.parse('$_baseUrl/panti_detail/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);
        final orphanageData = data['data'];

        // Trigger callback with fetched data
        onDataFetchSuccess(orphanageData);
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? "Unknown error occurred";
        print("Failed to fetch orphanage details: $errorMessage");
        onError("Failed to fetch orphanage details. Please try again.");
      }
    } catch (e) {
      print("An error occurred during fetching orphanage details: ${e.toString()}");
      onError("An unexpected error occurred. Please try again.");
    }
  }

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
                // Save the changes
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
                          _getProfileImageUrl(), // Function to get the image URL from SharedPreferences
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Icon(Icons.error));
                        } else if (snapshot.hasData && snapshot.data != null) {
                          // Display the profile image from the retrieved URL
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black
                                        .withOpacity(0.5), // Darken the image
                                    BlendMode.darken,
                                  ),
                                  child: Image.network(
                                    snapshot
                                        .data!, // Profile image URL retrieved from SharedPreferences
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Edit icon on top of the image
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
                              child: Icon(FontAwesomeIcons.solidPenToSquare)); // If there is no URL
                        }
                      },
                    ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int? maxLines,
    TextInputType? keyboardType,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16), // Increased label font size
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: const Color.fromARGB(255, 181, 208, 255), width: 2),
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
