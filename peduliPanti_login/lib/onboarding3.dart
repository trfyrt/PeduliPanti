import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peduliPanti/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Onboarding3App extends StatelessWidget {
  const Onboarding3App({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Added SingleChildScrollView to prevent overflow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, // Pastikan semua elemen rata kiri
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 30), // Reduced vertical margin
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri untuk teks di dalam Column
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Aplikasi ini memberikan',
                          style: TextStyle(
                            color: Colors.black, // Warna untuk "Top-Up Game"
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' pengalaman donasi',
                          style: TextStyle(
                            color: Colors.blue, // Warna untuk "Mudah"
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' yang blablalblablalb',
                          style: TextStyle(
                            color: Colors.black, // Warna untuk "dan"
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20), // Menambahkan jarak atas untuk animasi
                    child: Lottie.asset(
                      'assets/asset3.json',
                      fit: BoxFit.contain,
                      height: 450, // Set a specific height for the animation
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10), // Menambahkan jarak atas di sini
                    child: Text(
                      'Mulai sekarang, jadilah bagian dari perjalanan kebaikan bersama, di mana setiap langkah kecil yang Anda ambil menjadi bagian dari perubahan besar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginApp()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(400, 50), // Panjang 400, Tinggi 50
                        backgroundColor: Colors.blue, // Warna latar belakang tombol
                        foregroundColor: Colors.white, // Warna teks tombol
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding dalam tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Radius sudut tombol
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, // Atur posisi teks dan ikon
                        children: [
                          Text("Memulai", style: TextStyle(fontSize: 16)),
                          Container(
                            margin: EdgeInsets.only(left: 8, top: 2), // Spasi di kiri ikon
                            child: FaIcon(
                              FontAwesomeIcons.chevronRight, // Ikon FontAwesome
                              color: Colors.white, // Warna ikon
                              size: 17, // Ukuran ikon
                            ),
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
      ),
    );
  }
}
