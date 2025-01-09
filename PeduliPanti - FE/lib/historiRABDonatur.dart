import 'package:donatur_peduli_panti/detailPanti_donatur.dart';
import 'package:donatur_peduli_panti/donasi.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoriRAB extends StatelessWidget {
  const HistoriRAB({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const HistoriRABPage(),
    );
  }
}

class HistoriRABPage extends StatefulWidget {
  const HistoriRABPage({super.key});

  @override
  State<HistoriRABPage> createState() => _HistoriRABPageState();
}

class _HistoriRABPageState extends State<HistoriRABPage> {
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
        title: Stack(
          children: [
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const DetailPantiApp(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
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
                'Laporan Keuangan',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromARGB(255, 254, 254, 254),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Januari',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const Text(
                              'Rabu, 2 September 2024',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, bottom: 8),
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 211, 211, 211)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Color.fromARGB(
                                        255, 129, 156, 214), // Warna border
                                    width: 2, // Ketebalan border
                                    style: BorderStyle.solid, // Gaya border
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder: (context, animation, secondaryAnimation) => const Pesanan(),
                                //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                //       return child; // Tidak ada animasi
                                //     },
                                //   ),
                                // );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.fileArrowDown,
                                    color: Color.fromARGB(255, 129, 156, 214),
                                  ),
                                  Text(
                                    " Download File",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 129, 156, 214),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
