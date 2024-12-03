import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String name = "John Doe";
  String description =
      "Panti asuhan ini memberikan perlindungan dan pendidikan kepada anak-anak yang membutuhkan.";
  String address = "Jl. Contoh Alamat No. 123, Kota, Provinsi";
  int childrenCount = 25;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.blueAccent,
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
                        : AssetImage('assets/pedulipanti.png')
                            as ImageProvider,
                    child: profileImage == null
                        ? Icon(Icons.camera_alt, color: Colors.white, size: 30)
                        : null,
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(
                  label: "Nama Pengurus",
                  initialValue: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Pengurus tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Deskripsi",
                  initialValue: description,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    description = value;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Alamat",
                  initialValue: address,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    address = value;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Jumlah Anak",
                  initialValue: childrenCount.toString(),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah Anak tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    childrenCount = int.tryParse(value) ?? 0;
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
    required String initialValue,
    int? maxLines,
    TextInputType? keyboardType,
    required String? Function(String?)? validator,
    required void Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16), // Increased label font size
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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
