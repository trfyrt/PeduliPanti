import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class SuccesPay extends StatelessWidget {
  const SuccesPay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const SuccesPayPage(),
    );
  }
}

class SuccesPayPage extends StatefulWidget {
  const SuccesPayPage({super.key});

  @override
  State<SuccesPayPage> createState() => _SuccesPayPageState();
}

class _SuccesPayPageState extends State<SuccesPayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                          const HomeDonaturApp(),
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
                'Status Pesanan',
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
            child: Align(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Lottie.asset('assets/animation/succes-pay.json',
                          width: 240, height: 240),
                    ),
                    Container(
                      child: Text(
                        'Pembayaran Berhasil',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 30),
                      child: Text(
                        'Terima kasih! Donasi Anda telah berhasil dan akan membawa senyuman serta harapan bagi anak-anak panti asuhan. Bersama, kita bisa terus menyebarkan kebaikan!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 147, 181, 255),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Tambahkan logika pembayaran di sini
                        // Navigator.pop(context); // Tutup modal
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text("Pembayaran berhasil!"),
                        //     backgroundColor: Colors.green,
                        //   ),
                        // );

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const SuccesPayPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return child; // Tidak ada animasi
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "Lihat Pesanan",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
