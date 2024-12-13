import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/gestures.dart';
import 'onboarding1.dart';
import 'onboarding3.dart';

class Onboarding2App extends StatelessWidget {
  const Onboarding2App({super.key});

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
          crossAxisAlignment:
              CrossAxisAlignment.start, // Pastikan semua elemen rata kiri
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20), // Reduced vertical margin
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri untuk teks di dalam Column
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Berdonasi ke panti asuhan manapun',
                          style: TextStyle(
                            color: Colors.black, // Warna untuk "Top-Up Game"
                            fontSize: 18, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Mudah',
                          style: TextStyle(
                            color: Colors.blue, // Warna untuk "Mudah"
                            fontSize: 18, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' dan ',
                          style: TextStyle(
                            color: Colors.black, // Warna untuk "dan"
                            fontSize: 18, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Cepat, ',
                          style: TextStyle(
                            color: Colors.blue, // Warna untuk "Cepat"
                            fontSize: 18, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' nikmati pengalaman berdonasi tanpa hambatan',
                          style: TextStyle(
                            color: Colors.black, // Warna untuk "Cepat"
                            fontSize: 18, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menambahkan margin di bagian bawah untuk memberi jarak antara TopUp Game dan teks berikutnya
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10), // Menambahkan jarak atas untuk animasi
                    child: Center( // Centering the Lottie animation
                      child: GestureDetector(
                        onTap: () {
                          // Action to expand the image
                        },
                        child: Lottie.asset(
                          'assets/donate.json',
                          fit: BoxFit.contain,
                          height: 350, // Increased height for Lottie animation
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10), // Menambahkan jarak atas di sini
                    child: Text(
                      'menghubungkan mereka yang memberi dengan penuh kasih dan mereka yang menerima dengan penuh harapan. Bersama, kita menciptakan jembatan kebaikan yang mengubah bantuan menjadi senyuman, dan kepedulian menjadi peluang untuk masa depan yang lebih cerah.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14), // Reduced font size
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20), // Margin top untuk seluruh group tombol
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menyusun tombol ke ujung kiri dan kanan
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Warna bayangan
                                offset: Offset(0, 0), // Posisi bayangan (horizontal, vertical)
                                blurRadius: 5, // Reduced blur radius
                                spreadRadius: 1, // Sebaran bayangan
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10), // Sesuaikan dengan tombol
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Onboarding1App()),
                              );
                            },
                            child: Text('Kembali'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Reduced padding
                              textStyle: TextStyle(fontSize: 14), // Reduced font size
                              backgroundColor: Colors.white, // Warna latar belakang tombol
                              foregroundColor: Colors.blue, // Warna teks tombol
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Onboarding3App()),
                              );
                            },
                            child: Text('Lanjut'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Reduced padding
                              textStyle: TextStyle(fontSize: 14), // Reduced font size
                              backgroundColor: Colors.blue, // Warna latar belakang tombol
                              foregroundColor: Colors.white, // Warna teks tombol
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
