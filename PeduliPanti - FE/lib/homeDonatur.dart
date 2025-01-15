import 'package:donatur_peduli_panti/Services/api_service.dart';
import 'package:donatur_peduli_panti/donasi.dart';
// import 'package:donatur_peduli_panti/keranjang.dart';
import 'package:donatur_peduli_panti/notifikasi.dart';
import 'package:donatur_peduli_panti/statusBayar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:donatur_peduli_panti/detailPanti_donatur.dart';
import 'package:donatur_peduli_panti/profileDonatur.dart';
import 'package:donatur_peduli_panti/Services/auth_service.dart';
import 'package:donatur_peduli_panti/Models/Panti.dart';

class HomeDonaturApp extends StatefulWidget {
  const HomeDonaturApp({super.key});

  @override
  State<HomeDonaturApp> createState() => _HomeDonaturAppState();
}

class _HomeDonaturAppState extends State<HomeDonaturApp> {
  Map<String, dynamic>? user; // Variabel untuk menyimpan data user

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService.getUser(); // Ambil data user
    if (userData != null) {
      setState(() {
        user = userData; // Perbarui state dengan data user
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: MyHomePage(
        title: 'Peduli Panti',
        // user: user, // Pass user data ke MyHomePage
      ),
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
  int _currentIndex = 0;
  Map<String, dynamic>? user;
  List<Panti> pantis = [];
  bool isLoading = true;

  // @override
  // final List<Map<String, dynamic>> data = [
  //   {"nama": "Panti Asuhan 1", "jumlah": 50, "progress": 0.5},
  //   {"nama": "Panti Asuhan 2", "jumlah": 30, "progress": 0.3},
  //   {"nama": "Panti Asuhan 3", "jumlah": 70, "progress": 0.7},
  //   {"nama": "Panti Asuhan 4", "jumlah": 90, "progress": 0.9},
  // ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPantis();
  }

  Future<void> _fetchPantis() async {
    try {
      final data = await ApiService.fetchPantiDetails();
      setState(() {
        // Mengurutkan berdasarkan priorityValue (descending)
        pantis = data
          ..sort((a, b) => b.priorityValue.compareTo(a.priorityValue));
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pantis: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService.getUser(); // Ambil data user
    if (userData != null) {
      setState(() {
        user = userData; // Perbarui state dengan data user
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
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
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Stack untuk konten lainnya
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: Container(
                  height: 325,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 147, 181, 255),
                  ),
                  child: Stack(
                    children: [
                      // Konten di dalam Container
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Image.asset(
                                                'assets/img/logo-home.png',
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),
                                            Container(
                                              child: const Text(
                                                'Peduli Panti',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Halo,',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${user?['name'] ?? 'Pengguna'} 👋🏻!',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Ayo berdonasi untuk membantu teman-teman',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ),
                                          ),
                                          Text(
                                            'kita di panti asuhan',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   margin: const EdgeInsets.only(top: 10),
                                //   child: const Column(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         'Ayo berdonasi untuk membantu teman-teman',
                                //         style: TextStyle(
                                //           fontSize: 12,
                                //           color:
                                //               Color.fromRGBO(255, 255, 255, 1),
                                //         ),
                                //       ),
                                //       Text(
                                //         'kita di panti asuhan',
                                //         style: TextStyle(
                                //           fontSize: 12,
                                //           color: Color.fromARGB(
                                //               255, 255, 255, 255),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 250, 250, 250),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(Icons.search),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    Container(
                      width: 360,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: const AssetImage('assets/img/ajakan1.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            const Color.fromARGB(255, 8, 0, 255)
                                .withOpacity(0.3),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Mari Mengulurkan Tangan Kita',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.6),
                                offset: const Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 25, bottom: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              'Panti Asuhan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: pantis.map((panti) {
                          // Perhitungan progress
                          final double progress = panti.donationTotal /
                              (686000 * panti.childNumber);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPantiApp(
                                      pantiId:
                                          panti.id), // Mengirimkan ID panti
                                ),
                              );
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
                                            panti.name,
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
                                          const Icon(Icons.star,
                                              size: 18,
                                              color: Color.fromARGB(
                                                  255, 107, 125, 167)),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              '${panti.priorityValue}', // Jumlah diatur ke 0 untuk sekarang
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
                                            child: SizedBox(
                                              height: 15,
                                              child: LinearProgressIndicator(
                                                value: progress.clamp(0.0,
                                                    1.0), // Pastikan 0 <= progress <= 1
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
                                            '${(progress * 100).toInt()}%', // Progress dalam persen
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
              )
            ],
          ),
        ),
        Positioned(
          top: 40,
          right: 15,
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (context, animation, secondaryAnimation) =>
              //         const Keranjang(),
              //     transitionsBuilder:
              //         (context, animation, secondaryAnimation, child) {
              //       return child;
              //     },
              //   ), // Halaman profil
              // );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 250, 250),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                margin: const EdgeInsets.only(right: 1),
                child: const Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
