import 'package:donatur_peduli_panti/donasi.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:donatur_peduli_panti/profileDonatur.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({super.key});

  @override
  State<Notifikasi> createState() => _NotifikasiAppState();
}

class _NotifikasiAppState extends State<Notifikasi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const NotifikasiPage(title: 'Peduli Panti'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key, required this.title});

  final String title;

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  int _currentIndex = 1;

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
        title: Center(
          child: Text(
            'Notifikasi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => NotificationPage()), // Halaman notifikasi
                // );
              } else if (index == 3) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HistoryPage()), // Halaman histori
                // );
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
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 93,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: const Color.fromARGB(255, 215, 227, 252),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 95),
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 235,
                                  child: Text(
                                    'Barang Panti Asuhan B sedang dikirim',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const Text('Rabu, 2 September 2024'),
                              ],
                            ),
                            const Icon(FontAwesomeIcons.angleRight),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 29,
                    left: 40,
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                  ),
                  const Positioned(
                      top: 43,
                      left: 55,
                      child: Icon(
                        FontAwesomeIcons.solidBell,
                        size: 26,
                      )),
                ],
              )),
        ),
      ]),
    );
  }
}
