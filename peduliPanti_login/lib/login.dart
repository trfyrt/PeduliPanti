import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:peduliPanti/dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Pastikan semua elemen rata kiri
        children: <Widget>[
          // Logo Peduli Panti di atas tengah
          Container(
            margin: EdgeInsets.only(top: 50), // Margin atas untuk logo
            child: Center(
              child: Image.asset(
                'pedulipanti.png', // Ganti dengan path logo yang sesuai
                height: 100, // Tinggi logo
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Rata kiri untuk teks di dalam Column
              children: [
                Text(
                  'Login dan nikmati pengalaman donasi tanpa atas',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Color(0xff2979ff),
                        fontWeight: FontWeight.bold, // Warna biru untuk teks
                        fontSize: 24, 
                      ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Masukkan username dan password.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Color.fromARGB(255, 72, 78, 90),
                        fontSize: 14, // Warna biru untuk teks
                      ),
                  textAlign: TextAlign.left,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20), // Margin kiri-kanan dan atas-bawah
                  child: TextField(
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person), // Ikon untuk username
                      border: OutlineInputBorder(), // Border kotak
                    ),
                  ),
                ),

                // Password TextField dengan margin
                Container(
                  margin: const EdgeInsets.only(top: 20), // Margin kiri-kanan dan atas-bawah
                  child: TextField(
                    obscureText: true, // Menyembunyikan teks
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock), // Ikon untuk password
                      border: OutlineInputBorder(), // Border kotak
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardApp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(500, 50), // Panjang dikurangi menjadi 300, Tinggi 50
                      backgroundColor:
                          Colors.blue, // Warna latar belakang tombol
                      foregroundColor: Colors.white, // Warna teks tombol
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15), // Padding dalam tombol
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Radius sudut tombol
                      ),
                    ),
                    child: Text("Masuk"),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1, // Ketebalan garis
                        color: Colors.grey, // Warna garis
                        endIndent: 10, // Jarak ke teks
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
                        indent: 10, // Jarak dari teks
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Warna bayangan
                        offset: Offset(
                            0, 0), // Posisi bayangan (horizontal, vertical)
                        blurRadius: 7, // Tingkat blur bayangan
                        spreadRadius: 1, // Sebaran bayangan
                      ),
                    ],
                    borderRadius:
                        BorderRadius.circular(10), // Sesuaikan dengan tombol
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(400, 50), // Panjang 400, Tinggi 50
                      backgroundColor:
                          Colors.white, // Warna latar belakang tombol
                      foregroundColor: Colors.blue, // Warna teks tombol
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15), // Padding dalam tombol
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Radius sudut tombol
                      ),
                    ),
                    onPressed: () {
                      // Aksi ketika tombol ditekan
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Posisi teks dan ikon di tengah
                      children: [
                        FaIcon(
                          FontAwesomeIcons
                              .google, // Ikon Google dari FontAwesome
                          color: Colors.red, // Warna ikon Google (merah)
                          size: 20, // Ukuran ikon
                        ),
                        SizedBox(width: 10), // Jarak antara ikon dan teks
                        Text(
                          "Masuk dengan Google",
                          style: TextStyle(fontSize: 16), // Ukuran teks tombol
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Pusatkan secara vertikal
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Pusatkan secara horizontal
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: RichText(
                          textAlign: TextAlign
                              .center, // Pastikan teks dalam RichText diratakan ke tengah
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Belum punya akun? ", // Teks biasa dengan warna 1
                                style: TextStyle(
                                  color: Colors.black, // Warna 1
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Daftar", // Teks dengan warna 2 yang dapat diklik
                                style: TextStyle(
                                  color: Colors.blue, // Warna 2
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Aksi navigasi
                                    print("Navigasi ke halaman lain");
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
    );
  }
}
