import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart'; // Corrected import statement
import 'dart:convert';
import 'package:http/http.dart' as http; // Added for HTTP requests

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController descriptionController = TextEditingController(
      text:
          "Panti asuhan ini memberikan perlindungan dan pendidikan kepada anak-anak yang membutuhkan.");
  final TextEditingController addressController =
      TextEditingController(text: "Jl. Contoh Alamat No. 123, Kota, Provinsi");
  final TextEditingController childrenCountController =
      TextEditingController(text: "25");
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
    _fetchUserData(); // Call _fetchUserData during initialization to fetch user data
  }

  static Future<int?> _getUserId() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final userJson = prefs.getString('user');
        if (userJson != null) {
          final user = jsonDecode(userJson);
          print("User ID: ${user['userID']}");
          return user['userID'];
        } else {
          print("User data not found in SharedPreferences.");
        }
      } catch (e) {
        print("Error retrieving user ID: $e");
      }
      return null;
    }

  // Function to fetch user data from the API
  Future<void> _fetchUserData() async { // Removed static keyword
    final userId = await _getUserId();
    if (userId != null) {
      final url = Uri.parse('http://127.0.0.1:8000/api/v1/user/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['name'];
        final description = data['description'];
        final address = data['pantiDetails']['address'];
        final childrenCount = data['pantiDetails']['childNumber'].toString();

        // Update the text controllers with fetched data
        setState(() { // Added setState to update the UI
          nameController.text = name;
          descriptionController.text = description;
          addressController.text = address;
          childrenCountController.text = childrenCount;
        });

        print("User data fetched successfully.");
      } else {
        print("Failed to fetch user data.");
      }
    }
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
                // Save the changes
                Navigator.pop(context);
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
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : AssetImage('assets/pedulipanti.png') as ImageProvider,
                    child: profileImage == null
                        ? Icon(Icons.camera_alt, color: Colors.white, size: 30)
                        : null,
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(
                  label: "Nama Pengurus",
                  initialValue: nameController.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Pengurus tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    nameController.text = value;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Deskripsi",
                  initialValue: descriptionController.text,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    descriptionController.text = value;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Alamat",
                  initialValue: addressController.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    addressController.text = value;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Jumlah Anak",
                  initialValue: childrenCountController.text,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah Anak tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    childrenCountController.text = value;
                  },
                ),
                // Removed the FutureBuilder for displaying user ID
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build text fields with validation
  Widget _buildTextField({
    required String label,
    required String initialValue,
    int? maxLines,
    TextInputType? keyboardType,
    required String? Function(String?)? validator,
    required void Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Added horizontal padding
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16), // Increased label font size
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
        onChanged: onChanged,
      ),
    );
  }
}
