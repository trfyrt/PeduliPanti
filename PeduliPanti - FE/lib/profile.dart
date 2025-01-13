import 'package:donatur_peduli_panti/notifikasiPAN.dart';
import 'package:flutter/material.dart';
import 'editProfile.dart';
import 'login.dart'; // Import the login page
import 'homePanti.dart'; // Changed import to homePanti.dart
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String description =
      "Panti asuhan ini memberikan perlindungan dan pendidikan kepada anak-anak yang membutuhkan. Kami berkomitmen untuk menciptakan lingkungan yang aman dan mendukung bagi mereka.";
  String address =
      "Jl. Contoh Alamat No. 123, Kota, Provinsi"; // New address variable

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 35),
            child: Stack(
              alignment: Alignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 147, 181, 255),
                  tooltip: 'CekRab',
                  shape: const CircleBorder(),
                  child: const Icon(
                    FontAwesomeIcons.handHoldingHeart,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const HomePage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ), // Halaman profil
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              "Cek RAB",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(75, 0, 0, 0),
              spreadRadius: 8,
              blurRadius: 30,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)), // Radius sudut untuk isi
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor: Colors.black.withOpacity(0.6),
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              // Navigasi berdasarkan index item yang dipilih
              if (index == 0) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const HomePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child; // Tidak ada animasi
                    },
                  ), // Halaman utama
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const HomePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child; // Tidak ada animasi
                    },
                  ), // Halaman utama
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ProfilePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ), // Halaman profil
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                label: 'Utama',
                icon: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(FontAwesomeIcons.house),
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                label: 'Profil',
                icon: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(FontAwesomeIcons.solidUser),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 251, 251),
      body: SingleChildScrollView(
        // Changed to SingleChildScrollView for overall scrolling
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.blue[50], // Background color
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16.0)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            // backgroundImage: AssetImage(
                            //     'assets/pedulipanti.png'), // Updated asset path
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Nama Pengurus: John Doe",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.child_care),
                              SizedBox(width: 8),
                              Text("Jumlah Anak: 25"),
                            ],
                          ),
                          const SizedBox(
                              height: 8), // Add space before the button
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to EditProfilePage when pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ),
                              );
                            },
                            child: const Text("Edit Profile"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding:
                        EdgeInsets.only(left: 16.0), // Add padding to the left
                    child: Text(
                      "List Kebutuhan:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Removed Expanded and ListView to allow overall scrolling
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // Add horizontal padding to cards
                    child: Card(
                      color: const Color.fromARGB(
                          255, 230, 247, 255), // Set card color to light blue
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              title: Row(
                                children: [
                                  // Image.asset(
                                  //     'assets/pedulipanti.png', // Updated asset path
                                  //     width: 60,
                                  //     height: 60,
                                  //     alignment: Alignment.center),
                                  const SizedBox(width: 8),
                                  const Column(
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
                            margin: const EdgeInsets.only(right: 8.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // Add horizontal padding to cards
                    child: Card(
                      color: const Color.fromARGB(
                          255, 230, 247, 255), // Set card color to light blue
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              title: Row(
                                children: [
                                  // Image.asset(
                                  //     'assets/pedulipanti.png', // Updated asset path
                                  //     width: 60,
                                  //     height: 60,
                                  //     alignment: Alignment.center),
                                  const SizedBox(width: 8),
                                  const Column(
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
                            margin: const EdgeInsets.only(right: 8.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // Add horizontal padding to cards
                    child: Card(
                      color: const Color.fromARGB(
                          255, 230, 247, 255), // Set card color to light blue
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              title: Row(
                                children: [
                                  // Image.asset(
                                  //     'assets/pedulipanti.png', // Updated asset path
                                  //     width: 60,
                                  //     height: 60,
                                  //     alignment: Alignment.center),
                                  const SizedBox(width: 8),
                                  const Column(
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
                          const Padding(
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
                  const SizedBox(height: 8),
                  // New Card for Description at the bottom
                  // Card untuk Deskripsi Panti Asuhan
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // Tambahkan padding horizontal
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100, // Minimum height for description card
                      ),
                      width:
                          double.infinity, // Use double.infinity for full width
                      child: Card(
                        color: const Color.fromARGB(
                            255, 230, 247, 255), // Set card color to light blue
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Deskripsi Panti Asuhan",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                description,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8), // Jarak sebelum card alamat
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // Tambahkan padding horizontal
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100, // Minimum height for address card
                      ),
                      width:
                          double.infinity, // Use double.infinity for full width
                      child: Card(
                        color: const Color.fromARGB(
                            255, 230, 247, 255), // Set card color to light blue
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Alamat Panti Asuhan",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                address,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 25), // Added space after the address card
                ],
              ),
            ),
            Positioned(
              left: 16, // Position the logout icon to the left
              top: 16,
              child: IconButton(
                icon: const Icon(Icons.logout,
                    color: Colors.black), // Changed color to black
                onPressed: () {
                  // Navigate to LoginPage when pressed
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginApp(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications,
                        color: Colors.black), // Changed color to black
                    onPressed: () {
                      // Navigate to NotificationPage when pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Center(
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
    );
  }
}
