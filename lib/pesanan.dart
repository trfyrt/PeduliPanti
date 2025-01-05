import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:donatur_peduli_panti/succesPay.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class Pesanan extends StatelessWidget {
  const Pesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const PesananPage(),
    );
  }
}

class Panti {
  String nama;
  bool isSelected;
  List<Barang> barangList;

  Panti(
      {required this.nama, this.isSelected = false, required this.barangList});
}

class Barang {
  String nama;
  int harga;
  int jumlah;
  String gambar;

  Barang({
    required this.nama,
    required this.harga,
    this.jumlah = 0,
    required this.gambar,
  });
}

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  String _selectedMethod = "Gopay";
  String _selectedAmount = "Rp.100.000";

  final Map<String, String> paymentIcons = {
    "Gopay": 'assets/img/gopay.png',
    "OVO": 'assets/img/ovo.png',
    "Dana": 'assets/img/dana.png',
  };

  void _updatePaymentMethod(String method, String amount) {
    setState(() {
      _selectedMethod = method;
      _selectedAmount = amount;
    });
    Navigator.pop(context); // Menutup modal setelah memilih metode
  }

  final List<Map<String, String>> dataBarang = [
    {
      "namaBarang": "Minyak Goreng 1L",
      "jumlah": "2",
      "harga": "Rp.18.000",
      "jumlahHarga": "Rp.36.000"
    },
    {
      "namaBarang": "Gula Pasir 1kg",
      "jumlah": "1",
      "harga": "Rp.12.000",
      "jumlahHarga": "Rp.12.000"
    },
    {
      "namaBarang": "Beras 5kg",
      "jumlah": "1",
      "harga": "Rp.60.000",
      "jumlahHarga": "Rp.60.000"
    },
  ];

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
                'Pesanan',
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
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Panti Asuhan A',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 193, 211, 254),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: Text(
                                      'Pilih Metode Pembayaran',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading:
                                        _buildImageIcon('assets/img/ovo.png'),
                                    title:
                                        _buildPaymentInfo('OVO', 'Rp.200.000'),
                                    onTap: () => _updatePaymentMethod(
                                        'OVO', 'Rp.200.000'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    width: double.infinity,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 176, 176, 176)),
                                  ),
                                  ListTile(
                                    leading:
                                        _buildImageIcon('assets/img/gopay.png'),
                                    title: _buildPaymentInfo(
                                        'Gopay', 'Rp.100.000'),
                                    onTap: () => _updatePaymentMethod(
                                        'Gopay', 'Rp.100.000'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    width: double.infinity,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 176, 176, 176)),
                                  ),
                                  ListTile(
                                    leading:
                                        _buildImageIcon('assets/img/dana.png'),
                                    title:
                                        _buildPaymentInfo('Dana', 'Rp.50.000'),
                                    onTap: () => _updatePaymentMethod(
                                        'Dana', 'Rp.50.000'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                    paymentIcons[_selectedMethod] ??
                                        'assets/img/default.png'),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedMethod,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(_selectedAmount),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(FontAwesomeIcons.angleRight),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child:
                                          Icon(FontAwesomeIcons.clipboardList),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Daftar Barang Belanjaan',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Image.asset(
                                  'assets/img/logo.png',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal, // Aktifkan scroll horizontal
                            child: Table(
                              border: TableBorder(
                                top: BorderSide(width: 1),
                                left: BorderSide.none,
                                right: BorderSide.none,
                                bottom: BorderSide(width: 1),
                              ),
                              columnWidths: const {
                                0: FixedColumnWidth(120),
                                1: FixedColumnWidth(100),
                                2: FixedColumnWidth(100),
                                3: FixedColumnWidth(100),
                              },
                              children: [
                                TableRow(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      child: Text(
                                        'Nama Barang',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                        'Jumlah',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                        'Harga',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                        'Jumlah Harga',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                ...dataBarang.map((barang) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          barang["namaBarang"]!,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          barang["jumlah"]!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          barang["harga"]!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          barang["jumlahHarga"]!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text('Fee Transaksi (10%)'),
                              ),
                              Container(
                                child: Text('Rp.20.000'),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  'Total Pembayaran',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Rp.100.000',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0, bottom: 25),
                  margin: EdgeInsets.only(right: 15),
                  child: Text(
                    "Total Harga",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                // Tombol "Bayar" di kanan
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 147, 181, 255),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 80),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Konfirmasi Pesanan',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child:
                                          Icon(Icons.close, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: Lottie.asset(
                                  'assets/animation/question-pay.json',
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "Pesanan Anda sudah sesuai? Lanjutkan pembayaran untuk menyelesaikan transaksi ini.",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 147, 181, 255),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 100),
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
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const SuccesPayPage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return child; // Tidak ada animasi
                                      },
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Lanjutkan Pembayaran",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Bayar",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Teks baru di bawah "Total Harga"
          Positioned(
            top: 37, // Posisi teks di bawah "Total Harga"
            right: 215, // Penyesuaian posisi horizontal sesuai kebutuhan
            child: Text(
              "Rp.100.000",
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 147, 181, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageIcon(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          assetPath,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Helper method untuk membangun informasi pembayaran
  Widget _buildPaymentInfo(String method, String amount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          method,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(amount),
      ],
    );
  }
}
