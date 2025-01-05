import 'package:donatur_peduli_panti/profileDonatur.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';

class EditProfil extends StatelessWidget {
  const EditProfil({super.key});

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
                'Edit Profil',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 112, 112, 112),
                    borderRadius: BorderRadius.circular(100)),
                child: Stack(
                  children: [
                    Positioned(
                        bottom: 2,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 147, 181, 255),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 4),
                            child: Icon(
                              FontAwesomeIcons.solidPenToSquare,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
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
                                border:
                                    InputBorder.none, // Border untuk TextField
                                hintText: 'Masukkan username baru',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 20), // Placeholder
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
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
                                border:
                                    InputBorder.none, // Border untuk TextField
                                hintText: 'Masukkan email baru',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 20), // Placeholder
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
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
                                border:
                                    InputBorder.none, // Border untuk TextField
                                hintText: 'Masukkan password baru',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 20), // Placeholder
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(400, 30),
                          backgroundColor:
                              const Color.fromARGB(255, 171, 196, 255),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // print("Tombol Daftar ditekan");
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         const HomeDonaturApp(),
                          //   ),
                          // );
                        },
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
