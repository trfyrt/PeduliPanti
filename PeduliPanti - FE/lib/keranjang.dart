import 'package:donatur_peduli_panti/donasi.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:donatur_peduli_panti/market.dart';
import 'package:donatur_peduli_panti/pesanan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Keranjang extends StatelessWidget {
  const Keranjang({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const KeranjangPage(),
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

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final List<Panti> daftarPanti = [
    Panti(
      nama: "Panti Asuhan A",
      barangList: [
        Barang(
          nama: "Buku Tulis",
          harga: 18000,
          gambar: "assets/img/buku_tulis.png", // Path gambar
        ),
        Barang(
          nama: "Pensil",
          harga: 5000,
          gambar: "assets/img/pensil.png", // Path gambar
        ),
      ],
    ),
    Panti(
      nama: "Panti Asuhan B",
      barangList: [
        Barang(
          nama: "Beras 5kg",
          harga: 50000,
          gambar: "assets/img/Beras.png",
        ),
        Barang(
          nama: "Minyak Goreng",
          harga: 25000,
          gambar: "assets/img/MinyakGoreng.png",
        ),
      ],
    ),
  ];

  // Fungsi hapus Panti
  void hapusPanti(int index) {
    setState(() {
      daftarPanti.removeAt(index);
    });
  }

  // Fungsi hapus Barang dari Panti tertentu
  void hapusBarang(int pantiIndex, int barangIndex) {
    setState(() {
      daftarPanti[pantiIndex].barangList.removeAt(barangIndex);
    });
  }

  int getTotalSelectedBarang() {
    int total = 0;

    for (var panti in daftarPanti) {
      if (panti.isSelected) {
        for (var barang in panti.barangList) {
          total += barang
              .jumlah; // Menambahkan jumlah barang dari panti yang dipilih
        }
      }
    }

    return total;
  }

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
                          const Market(),
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
                'Keranjang',
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
            child: Column(
              children: List.generate(daftarPanti.length, (pantiIndex) {
                final panti = daftarPanti[pantiIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: panti.isSelected,
                                      activeColor:
                                          Color.fromARGB(255, 147, 181, 255),
                                      onChanged: (value) {
                                        setState(() {
                                          panti.isSelected = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      panti.nama,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                // Tombol Hapus Panti
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    hapusPanti(pantiIndex);
                                  },
                                ),
                              ],
                            ),
                          ),
                          // List Barang di bawah Header Panti
                          ...List.generate(panti.barangList.length,
                              (barangIndex) {
                            final barang = panti.barangList[barangIndex];
                            return Container(
                              child: ListTile(
                                leading: Image.asset(
                                  barang.gambar,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  barang.nama,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text("Rp. ${barang.harga}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Tombol Kurang
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (barang.jumlah > 0)
                                            barang.jumlah--;
                                        });
                                      },
                                    ),
                                    Text(
                                      '${barang.jumlah}',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    // Tombol Tambah
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          barang.jumlah++;
                                        });
                                      },
                                    ),
                                    // Tombol Hapus Barang
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        hapusBarang(pantiIndex, barangIndex);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const Divider(),
                        ],
                      ),
                    ),
                    // Header Panti dengan Checkbox dan Hapus Icon
                  ],
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
        width: double.infinity,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Menyebarkan ruang antara elemen
          children: [
            // Teks "Jumlah Barang" di kiri, menggunakan Expanded agar memanfaatkan sisa ruang
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 55, vertical: 25),
              child: Text(
                "${getTotalSelectedBarang()} Barang", // Menampilkan jumlah barang
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.left, // Teks di kiri
              ),
            ),
            // Tombol "Buat Pesanan" di kanan
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 147, 181, 255),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Pesanan(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child; // Tidak ada animasi
                    },
                  ),
                );
              },
              child: const Text(
                "Buat Pesanan",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
