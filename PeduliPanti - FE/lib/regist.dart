import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';

class RegistApp extends StatelessWidget {
  const RegistApp({super.key});

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 181, 255),
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(21),
            bottomRight: Radius.circular(21),
          ),
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Image.asset('assets/img/logo.png')),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Registrasi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const Text(
                  'Silahkan lengkapi data yang diperlukan untuk melanjutkan proses registrasi',
                  style: TextStyle(
                      color: Color.fromARGB(255, 128, 128, 128))),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Nama',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(15),
                              child: FaIcon(
                                FontAwesomeIcons.solidUser,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Nama Pengguna',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(15),
                              child: FaIcon(
                                FontAwesomeIcons.solidAddressCard,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(15),
                              child: FaIcon(
                                FontAwesomeIcons.solidEnvelope,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Katasandi',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(15),
                              child: FaIcon(
                                FontAwesomeIcons.key,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Konfirmasi Katasandi',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(15),
                              child: FaIcon(
                                FontAwesomeIcons.lock,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(400, 50),
                            backgroundColor: const Color.fromARGB(255, 171, 196, 255),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            print("Tombol Daftar ditekan");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeDonaturApp(),
                              ),
                            );
                          },
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Sudah punya akun? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: "Masuk Disini",
                                style: const TextStyle(
                                  color: Colors.blue,
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
