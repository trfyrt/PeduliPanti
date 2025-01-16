import 'package:donatur_peduli_panti/donasi.dart';
import 'package:donatur_peduli_panti/keranjang.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketAppState();
}

class _MarketAppState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const MarketPage(title: 'Peduli Panti'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Package {
  final String imagePath;
  final String name;
  final String price;

  Package({
    required this.imagePath,
    required this.name,
    required this.price,
  });
}

class MarketPage extends StatefulWidget {
  const MarketPage({super.key, required this.title});

  final String title;

  @override
  State<MarketPage> createState() => _MarketPage();
}

class _MarketPage extends State<MarketPage> {
  final List<Map<String, dynamic>> _packages1 = [
    {
      'imagePath': 'assets/img/MinyakGoreng.png',
      'name': 'Minyak Goreng 1 L',
      'price': 'Rp.20.000',
      'quantity': 0,
    },
    {
      'imagePath': 'assets/img/BotolAqua.png',
      'name': 'Botol Aqua Besar 1 krt',
      'price': 'Rp.50.000',
      'quantity': 0,
    },
    {
      'imagePath': 'assets/img/Beras.png',
      'name': 'Beras Sania 5 kg',
      'price': 'Rp.100.000',
      'quantity': 0,
    },
  ];

  final PageController _pageController1 = PageController();
  final List<Map<String, dynamic>> _packages = [
    {
      'imagePath': 'assets/img/Mainan.png',
      'name': 'Mainan',
      'price': 'Rp.20.000',
      'quantity': 0,
    },
    {
      'imagePath': 'assets/img/Pakaian.png',
      'name': 'Pakaian',
      'price': 'Rp.50.000',
      'quantity': 0,
    },
    {
      'imagePath': 'assets/img/Pendidikan.png',
      'name': 'Pendidikan',
      'price': 'Rp.100.000',
      'quantity': 0,
    },
  ];

  int _currentPage = 0; // Menyimpan indeks halaman saat ini

  @override
  void initState() {
    super.initState();
    _pageController1.addListener(() {
      // Mendengarkan perubahan halaman dan memperbarui state
      setState(() {
        _currentPage = _pageController1.page?.round() ?? 0;
      });
    });
  }

  final List<Map<String, dynamic>> _items = [
    {'name': 'Minyak Goreng 1L', 'price': 'Rp. 17.500', 'quantity': 0},
    {'name': 'Gula Pasir 1kg', 'price': 'Rp. 13.000', 'quantity': 0},
    {'name': 'Tepung Terigu 1kg', 'price': 'Rp. 10.000', 'quantity': 0},
  ];

  void _incrementQuantity(int index) {
    setState(() {
      _items[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_items[index]['quantity'] > 0) {
        _items[index]['quantity']--;
      }
    });
  }

  void _incrementPackage(int index) {
    setState(() {
      _packages[index]['quantity']++;
    });
  }

  void _decrementPackage(int index) {
    setState(() {
      if (_packages[index]['quantity'] > 0) {
        _packages[index]['quantity']--;
      }
    });
  }

  void _incrementBarangDonasi(int index) {
    setState(() {
      _packages1[index]['quantity']++;
    });
  }

  void _decrementBarangDonasi(int index) {
    setState(() {
      if (_packages1[index]['quantity'] > 0) {
        _packages1[index]['quantity']--;
      }
    });
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 48, bottom: 80),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Panti Asuhan 1',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 5, left: 20),
                    child: Text(
                      'Kami Membutuhkan',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._items.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> item = entry.value;
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 93,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 4),
                              )
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 193, 211, 254),
                                  Color.fromARGB(255, 255, 255, 255)
                                ],
                                stops: [
                                  0.2,
                                  0.7
                                ]),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 95),
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(item['price']),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _decrementQuantity(index),
                                      icon: const Icon(Icons.remove,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      '${item['quantity']}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _incrementQuantity(index),
                                      icon: const Icon(Icons.add,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 29,
                          left: 40,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 244, 244, 244),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 45,
                          left: 48,
                          child: Text(
                            '1/10',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 8),
                          child: const Text(
                            'Paket Donasi',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 250, // Tinggi carousel
                          child: PageView.builder(
                            controller: _pageController1,
                            itemCount: _packages.length,
                            itemBuilder: (context, index) {
                              final package = _packages[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.asset(
                                            package['imagePath'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 150,
                                          ),
                                        ),
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Color.fromARGB(98, 0, 0, 0),
                                                Color.fromARGB(
                                                    0, 255, 255, 255),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                package['name'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                package['price'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 147, 181, 255),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  _decrementPackage(index),
                                              icon: const Icon(Icons.remove,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${package['quantity']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _incrementPackage(index),
                                              icon: const Icon(Icons.add,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Text(
                            'Barang Donasi',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio:
                                  0.65, // Kurangi rasio aspek untuk ruang lebih besar
                            ),
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // Nonaktifkan scroll pada GridView
                            itemCount: _packages1.length,
                            itemBuilder: (context, index) {
                              final package1 = _packages1[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Gambar Barang
                                    Container(
                                      height:
                                          120, // Sesuaikan tinggi gambar agar proporsional
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          package1['imagePath'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Nama Barang
                                    Text(
                                      package1['name'],
                                      style: const TextStyle(
                                        fontSize: 14, // Kurangi ukuran teks
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    // Harga Barang
                                    Text(
                                      package1['price'],
                                      style: TextStyle(
                                        fontSize: 13, // Kurangi ukuran teks
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Spacer(),
                                    // Tombol Increment dan Decrement
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              _decrementBarangDonasi(index),
                                          icon: const Icon(Icons.remove,
                                              color: Colors.black),
                                          iconSize: 20, // Sesuaikan ukuran ikon
                                        ),
                                        Flexible(
                                          child: Text(
                                            '${package1['quantity']}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              _incrementBarangDonasi(index),
                                          icon: const Icon(Icons.add,
                                              color: Colors.black),
                                          iconSize: 20, // Sesuaikan ukuran ikon
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Keranjang(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ), // Halaman profil
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 147, 181, 255),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Donasi(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ), // Halaman profil
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 147, 181, 255),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  FontAwesomeIcons.angleLeft,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '10 Barang',
                  style: TextStyle(
                      color: Color.fromARGB(255, 147, 181, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
