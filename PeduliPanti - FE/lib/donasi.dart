import 'package:donatur_peduli_panti/detailPanti_donatur.dart';
import 'package:donatur_peduli_panti/market.dart';
import 'package:donatur_peduli_panti/notifikasi.dart';
import 'package:donatur_peduli_panti/profileDonatur.dart';
import 'package:donatur_peduli_panti/statusBayar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';

class Donasi extends StatelessWidget {
  const Donasi({super.key});

  // This widget is the root of your application.
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
  // Daftar data panti asuhan
  final List<Map<String, dynamic>> data = [
    {"nama": "Panti Asuhan 1", "jumlah": 50, "progress": 0.5},
    {"nama": "Panti Asuhan 2", "jumlah": 30, "progress": 0.3},
    {"nama": "Panti Asuhan 3", "jumlah": 70, "progress": 0.7},
    {"nama": "Panti Asuhan 4", "jumlah": 90, "progress": 0.9},
    {"nama": "Panti Asuhan 5", "jumlah": 40, "progress": 0.4},
    {"nama": "Panti Asuhan 6", "jumlah": 80, "progress": 0.8},
    {"nama": "Panti Asuhan 7", "jumlah": 60, "progress": 0.6},
  ];

  final List<Map<String, dynamic>> data1 = [
    {"nama": "Panti Asuhan 1", "jumlah": 50, "progress": 0.5},
    {"nama": "Panti Asuhan 2", "jumlah": 30, "progress": 0.3},
    {"nama": "Panti Asuhan 3", "jumlah": 70, "progress": 0.7},
    {"nama": "Panti Asuhan 4", "jumlah": 90, "progress": 0.9},
    {"nama": "Panti Asuhan 5", "jumlah": 40, "progress": 0.4},
    {"nama": "Panti Asuhan 6", "jumlah": 80, "progress": 0.8},
    {"nama": "Panti Asuhan 7", "jumlah": 60, "progress": 0.6},
    {"nama": "Panti Asuhan 8", "jumlah": 20, "progress": 0.1},
    {"nama": "Panti Asuhan 9", "jumlah": 30, "progress": 0.2},
  ];

  int _currentPage = 0;
  int _currentIndex = 2;

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
            'Donasi',
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
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(15),
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 215, 227, 252)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      'Rekomendasi Panti Asuhan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  // Membuat PageView untuk menampilkan data
                  Container(
                    height: 400,
                    child: PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: (data.length / 3)
                          .ceil(), // Menghitung jumlah halaman berdasarkan data
                      itemBuilder: (context, pageIndex) {
                        int startIndex = pageIndex * 3;
                        int endIndex = (startIndex + 3 > data.length)
                            ? data.length
                            : startIndex + 3;
                        List<Map<String, dynamic>> currentItems =
                            data.sublist(startIndex, endIndex);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: currentItems.map((item) {
                            return GestureDetector(
                              onTap: () {
                                // Misalnya, ketika item diklik, Anda bisa menampilkan snackbar atau melanjutkan ke halaman lain
                                print('Item ${item['nama']} tapped');
                                // Anda bisa menambahkan aksi lain di sini, seperti navigasi atau perubahan status
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder: (context, animation,
                                //             secondaryAnimation) =>
                                //         const DetailPantiApp(),
                                //     transitionsBuilder: (context, animation,
                                //         secondaryAnimation, child) {
                                //       return child;
                                //     },
                                //   ),
                                // );
                              },
                              child: Container(
                                height: 110,
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item['nama'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Color.fromARGB(
                                                    255, 107, 125, 167),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8),
                                              child: const Icon(
                                                Icons.verified,
                                                color: Color.fromARGB(
                                                    255, 107, 125, 167),
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              size: 18,
                                              color: Color.fromARGB(
                                                  255, 107, 125, 167),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                '${item['jumlah']}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 107, 125, 167),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 25),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                height: 15,
                                                child: LinearProgressIndicator(
                                                  value: item['progress'],
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 229, 229, 229),
                                                  color: const Color.fromARGB(
                                                      255, 107, 125, 167),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              '${(item['progress'] * 100).toInt()}%',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 107, 125, 167),
                                                fontSize: 16,
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
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  // Indikator halaman untuk PageView
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        (data.length / 3).ceil(),
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.blue
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 4, bottom: 5),
                    child: Text(
                      'Panti Asuhan',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: data1.map((item) {
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder:
                            //         (context, animation, secondaryAnimation) =>
                            //             const DetailPantiApp(),
                            //     transitionsBuilder: (context, animation,
                            //         secondaryAnimation, child) {
                            //       return child;
                            //     },
                            //   ),
                            // );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 129, 129, 129)
                                          .withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item['nama'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 107, 125, 167),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          child: const Icon(Icons.verified,
                                              color: Color.fromARGB(
                                                  255, 107, 125, 167),
                                              size: 18),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.person,
                                            size: 18,
                                            color: Color.fromARGB(
                                                255, 107, 125, 167)),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            '${item['jumlah']}',
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 107, 125, 167),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 25),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            height: 15,
                                            child: LinearProgressIndicator(
                                              value: item['progress'],
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 229, 229, 229),
                                              color: const Color.fromARGB(
                                                  255, 107, 125, 167),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          '${(item['progress'] * 100).toInt()}%',
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 107, 125, 167),
                                            fontSize: 16,
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
                      }).toList(),
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
