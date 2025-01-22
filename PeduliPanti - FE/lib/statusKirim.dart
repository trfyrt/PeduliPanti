import 'package:donatur_peduli_panti/detailTransaksi.dart';
import 'package:donatur_peduli_panti/statusBayar.dart';
import 'package:donatur_peduli_panti/statusKemas.dart';
import 'package:donatur_peduli_panti/statusSelesai.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:donatur_peduli_panti/profileDonatur.dart';

class StatusKirim extends StatefulWidget {
  const StatusKirim({super.key});

  @override
  State<StatusKirim> createState() => _StatusKirimAppState();
}

class _StatusKirimAppState extends State<StatusKirim> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const StatusKirimPage(title: 'Peduli Panti'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StatusKirimPage extends StatefulWidget {
  const StatusKirimPage({super.key, required this.title});

  final String title;

  @override
  State<StatusKirimPage> createState() => _StatusKirimPageState();
}

class _StatusKirimPageState extends State<StatusKirimPage> {
  @override
  final List<Map<String, dynamic>> data = [
    {"nama": "Panti Asuhan 1", "jumlah": 50, "progress": 0.5},
    {"nama": "Panti Asuhan 2", "jumlah": 30, "progress": 0.3},
    {"nama": "Panti Asuhan 3", "jumlah": 70, "progress": 0.7},
    {"nama": "Panti Asuhan 4", "jumlah": 90, "progress": 0.9},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 181, 255),
        toolbarHeight: 140,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(21),
            bottomRight: Radius.circular(21),
          ),
        ),
        title: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Profiledonatur(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child; // Tidak ada animasi
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        FontAwesomeIcons.angleLeft,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Status Pembelian',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman lain
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  StatusBayar(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child; // Tidak ada animasi
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 18, top: 20, bottom: 0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Icon(
                              FontAwesomeIcons.wallet,
                              color: Color.fromARGB(255, 254, 254, 254),
                              size: 19,
                            ),
                          ),
                          Text(
                            'Bayar',
                            style: TextStyle(
                                color: Color.fromARGB(255, 254, 254, 254),
                                fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman lain
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  StatusKemas(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child; // Tidak ada animasi
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 18, left: 20, top: 20, bottom: 0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Icon(
                              FontAwesomeIcons.boxesPacking,
                              color: Color.fromARGB(255, 82, 104, 157),
                              size: 18,
                            ),
                          ),
                          Text(
                            'Dikemas',
                            style: TextStyle(
                                color: Color.fromARGB(255, 82, 104, 157),
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman lain
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  StatusKirim(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child; // Tidak ada animasi
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 18, left: 20, top: 20, bottom: 0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Icon(
                              FontAwesomeIcons.truck,
                              color: Color.fromARGB(255, 82, 104, 157),
                              size: 18,
                            ),
                          ),
                          Text(
                            'Dikirim',
                            style: TextStyle(
                                color: Color.fromARGB(255, 82, 104, 157),
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman lain
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  StatusSelesai(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child; // Tidak ada animasi
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 20, bottom: 0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Icon(
                              FontAwesomeIcons.box,
                              color: Color.fromARGB(255, 82, 104, 157),
                              size: 18,
                            ),
                          ),
                          Text(
                            'Selesai',
                            style: TextStyle(
                                color: Color.fromARGB(255, 82, 104, 157),
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: const Color.fromARGB(255, 254, 254, 254),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'Donasi Panti Asuhan B',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Text('Rabu, 2 September 2024'),
                          Container(
                            child: Text(
                              'Est. selesai Kamis, 15 Oktober 2024',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 11),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    'Total Harga : ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Rp.999.999',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 120, 145, 200)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            width: double.infinity,
                            height: 1,
                            decoration: BoxDecoration(
                                color:
                                    const Color.fromARGB(255, 211, 211, 211)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Color.fromARGB(
                                            255, 129, 156, 214), // Warna border
                                        width: 2, // Ketebalan border
                                        style: BorderStyle.solid, // Gaya border
                                      ),
                                    ),
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const DetailTransaksi(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return child; // Tidak ada animasi
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Detail Transaksi",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 129, 156, 214),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}
