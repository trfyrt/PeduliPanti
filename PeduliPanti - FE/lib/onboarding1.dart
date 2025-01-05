import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/gestures.dart';
import 'onboarding2.dart';
import 'login.dart';

class Onboarding1App extends StatelessWidget {
  const Onboarding1App({super.key});

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
      body: SingleChildScrollView(
        // Added SingleChildScrollView to prevent overflow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Pastikan semua elemen rata kiri
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20), // Reduced vertical margin to move content up
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Rata kiri untuk teks di dalam Column
                children: [
                  const Text(
                    'Selamat datang di',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18, // Reduced font size
                      fontWeight: FontWeight.bold, // Membuat teks menjadi bold
                    ),
                  ),
                  Text(
                    'Peduli Panti',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(0xff2979ff),
                          fontWeight: FontWeight.bold, // Warna biru untuk teks
                        ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8), // Reduced margin
                    child: const Text(
                      'tempat bertemunya kepedulian dan harapan, di mana setiap uluran tangan menciptakan senyuman, dan setiap harapan membangun masa depan yang lebih cerah.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14), // Reduced font size
                    ),
                  ),
                  Center(
                    // Centering the Lottie animation
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 10), // Adjusted margin
                      child: Lottie.asset(
                        'assets/box.json', // Ensure the correct path to the asset
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Center(
                    // Centering the buttons
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8), // Reduced margin
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Onboarding2App()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(350, 45), // Reduced size
                              backgroundColor:
                                  Colors.blue, // Warna latar belakang tombol
                              foregroundColor:
                                  Colors.white, // Warna teks tombol
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10), // Reduced padding
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Reduced radius
                              ),
                            ),
                            child: const Text("Berikutnya"),
                          ),
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1, // Ketebalan garis
                                color: Colors.grey, // Warna garis
                                endIndent: 8, // Reduced end indent
                              ),
                            ),
                            Text(
                              "Atau",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey, // Warna teks
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1, // Ketebalan garis
                                color: Colors.grey, // Warna garis
                                indent: 8, // Reduced indent
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 8), // Reduced margin
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Warna bayangan
                                offset: const Offset(0,
                                    0), // Posisi bayangan (horizontal, vertical)
                                blurRadius: 5, // Reduced blur radius
                                spreadRadius: 1, // Sebaran bayangan
                              ),
                            ],
                            borderRadius:
                                BorderRadius.circular(8), // Reduced radius
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(350, 45), // Reduced size
                              backgroundColor:
                                  Colors.white, // Warna latar belakang tombol
                              foregroundColor: Colors.blue, // Warna teks tombol
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10), // Reduced padding
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Reduced radius
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginApp()),
                              );
                            },
                            child: const Text("Login"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Pusatkan secara vertikal
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Pusatkan secara horizontal
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(top: 15), // Reduced margin
                          child: RichText(
                            textAlign: TextAlign
                                .center, // Pastikan teks dalam RichText diratakan ke tengah
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text:
                                      "Belum punya akun? ", // Teks biasa dengan warna 1
                                  style: TextStyle(
                                    color: Colors.black, // Warna 1
                                    fontSize: 14, // Reduced font size
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Daftar", // Teks dengan warna 2 yang dapat diklik
                                  style: const TextStyle(
                                    color: Colors.blue, // Warna 2
                                    fontSize: 14, // Reduced font size
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Aksi navigasi
                                    },
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
          ],
        ),
      ),
    );
  }
}
