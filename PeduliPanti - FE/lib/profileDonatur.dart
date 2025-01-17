import 'package:donatur_peduli_panti/donasi.dart';
import 'package:donatur_peduli_panti/keranjang.dart';
import 'package:donatur_peduli_panti/notifikasi.dart';
import 'package:donatur_peduli_panti/regist.dart';
import 'package:donatur_peduli_panti/statusBayar.dart';
import 'package:donatur_peduli_panti/statusKemas.dart';
import 'package:donatur_peduli_panti/statusKirim.dart';
import 'package:donatur_peduli_panti/statusSelesai.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:donatur_peduli_panti/editProfilDonatur.dart';
import 'package:donatur_peduli_panti/Services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profiledonatur extends StatefulWidget {
  const Profiledonatur({super.key});

  @override
  State<Profiledonatur> createState() => _Profiledonatur();
}

class _Profiledonatur extends State<Profiledonatur> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
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
  int _currentIndex = 4;

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
                  tooltip: 'Donasi',
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
                            const Donasi(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child; // Tidak ada animasi
                        },
                      ),
                    ); // Halaman utama
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              "Donasi",
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
              setState(() {
                _currentIndex = index; // Update item aktif
              });
              // Navigasi berdasarkan index item yang dipilih
              if (index == 0) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const HomeDonaturApp(),
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
                        const Notifikasi(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ), // Halaman profil
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const StatusBayar(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ), // Halaman profil
                );
              } else if (index == 4) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Profiledonatur(),
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
                label: 'Notifikasi',
                icon: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(FontAwesomeIcons.solidBell),
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                label: 'Histori',
                icon: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(FontAwesomeIcons.clockRotateLeft),
                ),
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
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Stack untuk konten lainnya
              FutureBuilder<Map<String, dynamic>?>(
                future: AuthService.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Tampilkan indikator loading
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Center(
                        child: Text(
                            'Failed to load user data')); // Tampilkan pesan error
                  } else {
                    final user = snapshot.data!;
                    final imageUrl = user['image'] as String? ?? '';
                    final proxyUrl = '$imageUrl';
                    final isValidUrl =
                        Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false;

                    if (!isValidUrl) {
                      print('URL gambar tidak valid: $imageUrl');
                    }
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Container(
                        height: 270,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 147, 181, 255),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 138, 138, 138),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: proxyUrl,
                                          width: 90,
                                          height: 90,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          // errorWidget: (context, url, error) {
                                          //   print('Error: $error');
                                          //   return const Icon(
                                          //       Icons.broken_image,
                                          //       size: 50);
                                          // },
                                          fit: BoxFit.cover,
                                        ))
                                    // Default ikon jika image kosong
                                    ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                user['name'] ??
                                    'No Name', // Tampilkan nama pengguna
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                user['email'] ??
                                    'No Email', // Tampilkan email pengguna
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Pembelian',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 104, 157),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 174, 174, 174),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildStatusIcon(
                              context,
                              icon: FontAwesomeIcons.wallet,
                              label: 'Bayar',
                              targetPage: StatusBayar(),
                            ),
                            _buildStatusIcon(
                              context,
                              icon: FontAwesomeIcons.boxesPacking,
                              label: 'Dikemas',
                              targetPage: StatusKemas(),
                            ),
                            _buildStatusIcon(
                              context,
                              icon: FontAwesomeIcons.truck,
                              label: 'Dikirim',
                              targetPage: StatusKirim(),
                            ),
                            _buildStatusIcon(
                              context,
                              icon: FontAwesomeIcons.box,
                              label: 'Selesai',
                              targetPage: StatusSelesai(),
                            ),
                          ],
                        ),
                        _buildListItem(
                          context,
                          icon: FontAwesomeIcons.userPen,
                          label: 'Edit Profil',
                          targetPage: const EditProfil(),
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 174, 174, 174),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Konfirmasi Keluar"),
                                  content: const Text(
                                      "Apakah Anda yakin ingin keluar dari akun Anda?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Batal",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 82, 104, 157)),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                RegistApp(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return child;
                                            },
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Keluar",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 82, 104, 157)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: _buildListItem(
                            context,
                            icon: FontAwesomeIcons.arrowRightFromBracket,
                            label: 'Keluar',
                          ),
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 174, 174, 174),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          right: 15,
          child: GestureDetector(
            onTap: () {
              // Navigasi ke halaman lain
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Keranjang(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child; // Tidak ada animasi
                  },
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 250, 250),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                margin: const EdgeInsets.only(right: 1),
                child: const Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildStatusIcon(BuildContext context,
      {required IconData icon,
      required String label,
      required Widget targetPage}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => targetPage,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Icon(icon, color: const Color.fromARGB(255, 82, 104, 157)),
            ),
            Text(
              label,
              style: const TextStyle(color: Color.fromARGB(255, 82, 104, 157)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context,
      {required IconData icon, required String label, Widget? targetPage}) {
    return GestureDetector(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  targetPage,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                icon,
                size: 20,
                color: const Color.fromARGB(255, 82, 104, 157),
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 82, 104, 157),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
