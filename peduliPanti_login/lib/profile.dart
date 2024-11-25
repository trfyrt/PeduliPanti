import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String description =
      "Panti asuhan ini memberikan perlindungan dan pendidikan kepada anak-anak yang membutuhkan. Kami berkomitmen untuk menciptakan lingkungan yang aman dan mendukung bagi mereka.";
  String address =
      "Jl. Contoh Alamat No. 123, Kota, Provinsi"; // New address variable

  void _editDescription() {
    TextEditingController controller = TextEditingController(text: description);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Deskripsi"),
          content: Container(
            width: 400, // Set a fixed width for the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: null, // Allow the TextField to expand vertically
                  maxLength: 100, // Limit the number of characters to 100
                  decoration: InputDecoration(
                    hintText: "Masukkan deskripsi baru",
                    counterText:
                        '${controller.text.length}/100', // Show character count
                  ),
                ),
                SizedBox(height: 8),
                Text("Maksimal 100 karakter"), // Inform about character limit
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.length <= 100) {
                  // Check length before saving
                  setState(() {
                    description = controller.text; // Update the description
                  });
                  Navigator.of(context).pop();
                } else {
                  // Optionally show a message if the limit is exceeded
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Deskripsi tidak boleh lebih dari 100 karakter")),
                  );
                }
              },
              child: Text("Simpan"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
          ],
        );
      },
    );
  }

  void _editAddress() {
    TextEditingController controller = TextEditingController(text: address);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Alamat"),
          content: Container(
            width: 400, // Set a fixed width for the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: null, // Allow the TextField to expand vertically
                  maxLength: 100, // Limit the number of characters to 100
                  decoration: InputDecoration(
                    hintText: "Masukkan alamat baru",
                    counterText:
                        '${controller.text.length}/100', // Show character count
                  ),
                ),
                SizedBox(height: 8),
                Text("Maksimal 100 karakter"), // Inform about character limit
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.length <= 100) {
                  // Check length before saving
                  setState(() {
                    address = controller.text; // Update the address
                  });
                  Navigator.of(context).pop();
                } else {
                  // Optionally show a message if the limit is exceeded
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Alamat tidak boleh lebih dari 100 karakter")),
                  );
                }
              },
              child: Text("Simpan"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Changed to SingleChildScrollView for overall scrolling
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(16.0)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('pedulipanti.png'),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Nama Pengurus: John Doe",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.child_care),
                              SizedBox(width: 8),
                              Text("Jumlah Anak: 25"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0), // Add padding to the left
                    child: Text(
                      "List Kebutuhan:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Removed Expanded and ListView to allow overall scrolling
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Add horizontal padding to cards
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              title: Row(
                                children: [
                                  Image.asset('pedulipanti.png',
                                      width: 60,
                                      height: 60,
                                      alignment: Alignment.center),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Minyak"),
                                      SizedBox(height: 4),
                                      Text("Jumlah: 5",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 8.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Add horizontal padding to cards
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              title: Row(
                                children: [
                                  Image.asset('pedulipanti.png',
                                      width: 60,
                                      height: 60,
                                      alignment: Alignment.center),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Beras"),
                                      SizedBox(height: 4),
                                      Text("Jumlah: 5",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 0, 0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 8.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Add horizontal padding to cards
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              title: Row(
                                children: [
                                  Image.asset('pedulipanti.png',
                                      width: 60,
                                      height: 60,
                                      alignment: Alignment.center),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Iphone"),
                                      SizedBox(height: 4),
                                      Text("Jumlah: 5",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.access_time,
                              size: 35,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // New Card for Description at the bottom
                  // Card untuk Deskripsi Panti Asuhan
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Tambahkan padding horizontal
                    child: Container(
                      height: 200, // Tentukan tinggi tetap untuk card deskripsi
                      width: 500,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deskripsi Panti Asuhan",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                description,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _editDescription,
                                child: Text("Edit"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8), // Jarak sebelum card alamat
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Tambahkan padding horizontal
                    child: Container(
                      height: 150, // Tentukan tinggi tetap untuk card alamat
                      width: 500,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Alamat Panti Asuhan",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                address,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _editAddress,
                                child: Text("Edit"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25), // Added space after the address card
                ],
              ),
            ),
            Positioned(
              left: 16, // Position the logout icon to the left
              top: 16,
              child: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  // Handle logout action here
                  print("Logout pressed");
                },
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      print("Notifikasi ditekan");
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color.fromARGB(255, 232, 243, 255),
        activeColor: const Color.fromARGB(255, 202, 222, 243),
        color: Colors.black54,
        items: [
          TabItem(icon: Icons.home, title: 'Utama'),
          TabItem(icon: Icons.file_copy, title: 'Cek RAB'),
          TabItem(icon: Icons.person, title: 'Profil'),
        ],
        style: TabStyle.fixedCircle,
        initialActiveIndex: 2,
        onTap: (int i) {
          if (i == 0) {
            Navigator.pop(context);
          } else if (i == 1) {
            print("Tab Cek RAB ditekan");
          }
        },
      ),
    );
  }
}
