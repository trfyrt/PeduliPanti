import 'package:donatur_peduli_panti/Models/Bundle.dart';
import 'package:donatur_peduli_panti/Services/api_service.dart';
import 'package:donatur_peduli_panti/donasi.dart';
// import 'package:donatur_peduli_panti/keranjang.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'Models/Panti.dart';
import 'Models/Product.dart';
import 'Models/RequestList.dart';

class Market extends StatefulWidget {
  Market({Key? key, required this.pantiDetail}) : super(key: key);

  Panti? pantiDetail;

  @override
  State<Market> createState() => _MarketAppState();
}

class _MarketAppState extends State<Market> {
  Panti? pantiDetail;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: MarketPage(
        title: 'Peduli Panti',
        pantiDetail: widget.pantiDetail,
      ),
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
  const MarketPage({super.key, required this.title, required this.pantiDetail});

  final Panti? pantiDetail;
  final String title;

  @override
  State<MarketPage> createState() => _MarketPage();
}

class _MarketPage extends State<MarketPage> {
  List<Product> _products = []; // Menyimpan data produk
  List<Bundle> _bundles = []; // Menyimpan data bundle
  List<int> _quantities = [];

  List<int> _currentQuantities =
      []; // Menyimpan jumlah yang ditampilkan di tengah tombol

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchBundles();
    _quantities = List.filled(_products.length, 0);
    _pageController1.addListener(() {
      // Mendengarkan perubahan halaman dan memperbarui state
      setState(() {
        _currentPage = _pageController1.page?.round() ?? 0;
      });
    });
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ApiService.fetchProducts();
      setState(() {
        _products = products;
        // Inisialisasi quantity baru setelah _products dimuat
        _quantities = List.filled(_products.length, 0);
      });
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  Future<void> _fetchBundles() async {
    try {
      final bundles = await ApiService.fetchBundles();
      setState(() {
        _bundles = bundles;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching bundles: $error');
    }
  }

  Product? _getProductById(int productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize currentQuantities dengan nilai awal 0
    _currentQuantities =
        widget.pantiDetail?.requestLists.map((e) => 0).toList() ?? [];
  }

  final PageController _pageController1 = PageController();

  int _currentPage = 0; // Menyimpan indeks halaman saat ini

  void _incrementRequestQty(int index) {
    setState(() {
      // Tambahkan 1 pada angka di tengah
      if (_currentQuantities[index] <
          widget.pantiDetail!.requestLists[index].requestedQty) {
        _currentQuantities[index]++;

        // Update donatedQty sesuai dengan angka di tengah
        final updatedRequest = widget.pantiDetail!.requestLists[index].copyWith(
          donatedQty: widget.pantiDetail!.requestLists[index].donatedQty + 1,
        );
        widget.pantiDetail!.requestLists[index] = updatedRequest;
      }
    });
  }

  void _decrementRequestQty(int index) {
    setState(() {
      if (_currentQuantities[index] > 0) {
        // Kurangi 1 pada angka di tengah
        _currentQuantities[index]--;

        // Update donatedQty sesuai dengan angka di tengah
        final updatedRequest = widget.pantiDetail!.requestLists[index].copyWith(
          donatedQty: widget.pantiDetail!.requestLists[index].donatedQty - 1,
        );
        widget.pantiDetail!.requestLists[index] = updatedRequest;
      }
    });
  }

  void _incrementBundle(int index) {
    setState(() {
      _currentQuantities[index] += 1; // Menambah kuantitas bundle
    });
  }

  void _decrementBundle(int index) {
    setState(() {
      if (_currentQuantities[index] > 0) {
        _currentQuantities[index] -= 1; // Mengurangi kuantitas bundle
      }
    });
  }

  void _incrementBarangDonasi(int index) {
    setState(() {
      // Pastikan kita hanya mengubah quantity jika index valid
      if (index >= 0 && index < _quantities.length) {
        _quantities[index]++; // Increment quantity produk
      }
    });
  }

  void _decrementBarangDonasi(int index) {
    setState(() {
      // Pastikan kita tidak mengurangi di bawah 0
      if (index >= 0 && index < _quantities.length && _quantities[index] > 0) {
        _quantities[index]--; // Decrement quantity produk
      }
    });
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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
                  Center(
                    child: Text(
                      'Panti ${widget.pantiDetail?.name ?? 'Asuhan'}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 5, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kami Membutuhkan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.pantiDetail?.requestLists.isNotEmpty ??
                            false)
                          ...widget.pantiDetail!.requestLists
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final request = entry.value;
                            final product = _getProductById(request.productID);
                            return Stack(
                              children: [
                                // Kartu utama
                                Container(
                                  width: double.infinity,
                                  height: 93,
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 20),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color.fromARGB(255, 193, 211, 254),
                                        Color.fromARGB(255, 255, 255, 255),
                                      ],
                                      stops: [0.2, 0.7],
                                    ),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 95),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25),
                                    child: Row(
                                      children: [
                                        // Informasi produk
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product?.name ?? 'Loading...',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              product != null
                                                  ? 'Rp. ${NumberFormat("#,###", "id_ID").format(product.price)}'
                                                  : 'Fetching price...',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        // Increment dan decrement
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  _decrementRequestQty(index),
                                              icon: const Icon(Icons.remove,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${_currentQuantities[index]}', // Menampilkan angka di tengah tombol
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _incrementRequestQty(index),
                                              icon: const Icon(Icons.add,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Lingkaran dan teks donatedQty/requestedQty
                                Positioned(
                                  top: 29,
                                  left: 20,
                                  child: Container(
                                    padding: const EdgeInsets.all(28),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 244, 244, 244),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: request.donatedQty > 9 ? 46 : 44,
                                  left: (request.donatedQty > 9 &&
                                          request.requestedQty > 9)
                                      ? 26
                                      : (request.donatedQty < 9 &&
                                              request.requestedQty < 9)
                                          ? 32
                                          : 30,
                                  child: Text(
                                    '${request.donatedQty}/${request.requestedQty}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: request.donatedQty > 9
                                          ? 15
                                          : 18, // Kondisi untuk memperkecil ukuran font jika donatedQty > 9
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        if (widget.pantiDetail?.requestLists.isEmpty ?? true)
                          const Text('Tidak ada permintaan saat ini.'),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
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
                        // Carousel untuk Bundle
                        SizedBox(
                          height: 250,
                          child: _bundles.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Belum ada paket donasi tersedia.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : PageView.builder(
                                  itemCount: _bundles.length,
                                  itemBuilder: (context, index) {
                                    final bundle = _bundles[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Stack untuk membuat kolase gambar
                                          SizedBox(
                                            height: 150,
                                            child: Stack(
                                              children: [
                                                // Gambar 1 (kiri besar)
                                                Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: Image.network(
                                                      bundle.products.isNotEmpty
                                                          ? bundle.products[0]
                                                                  .image ??
                                                              'https://via.placeholder.com/150'
                                                          : 'https://via.placeholder.com/150',
                                                      fit: BoxFit.cover,
                                                      width:
                                                          200, // Lebar gambar besar
                                                      height:
                                                          150, // Tinggi gambar besar
                                                    ),
                                                  ),
                                                ),
                                                // Gambar 2 (kanan atas)
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: Image.network(
                                                      bundle.products.length > 1
                                                          ? bundle.products[1]
                                                                  .image ??
                                                              'https://via.placeholder.com/150'
                                                          : 'https://via.placeholder.com/150',
                                                      fit: BoxFit.cover,
                                                      width:
                                                          100, // Lebar gambar kecil
                                                      height:
                                                          75, // Tinggi gambar kecil
                                                    ),
                                                  ),
                                                ),
                                                // Gambar 3 (kanan bawah)
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: Image.network(
                                                      bundle.products.length > 2
                                                          ? bundle.products[2]
                                                                  .image ??
                                                              'https://via.placeholder.com/150'
                                                          : 'https://via.placeholder.com/150',
                                                      fit: BoxFit.cover,
                                                      width:
                                                          100, // Lebar gambar kecil
                                                      height:
                                                          75, // Tinggi gambar kecil
                                                    ),
                                                  ),
                                                ),
                                                // Overlay gradient (opsional, jika diperlukan)
                                                Positioned.fill(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        begin: Alignment
                                                            .bottomCenter,
                                                        end:
                                                            Alignment.topCenter,
                                                        colors: [
                                                          Color.fromARGB(
                                                              98, 0, 0, 0),
                                                          Color.fromARGB(
                                                              0, 255, 255, 255),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // Nama bundle
                                          Text(
                                            bundle.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Harga bundle
                                          Text(
                                            'Rp. ${NumberFormat("#,###", "id_ID").format(bundle.price)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
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
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Barang Donasi',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Pengecekan jika produk kosong atau belum dimuat
                        _products.isEmpty
                            ? Center(
                                child:
                                    CircularProgressIndicator()) // Menampilkan loading saat data kosong
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                  itemCount: _products
                                      .length, // Menggunakan _products yang sudah di-fetch
                                  itemBuilder: (context, index) {
                                    final product = _products[
                                        index]; // Mendapatkan produk dari daftar _products
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Gambar Barang
                                          Container(
                                            height:
                                                120, // Sesuaikan tinggi gambar agar proporsional
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: product.image != null
                                                  ? Image.network(
                                                      product.image ??
                                                          'https://via.placeholder.com/150',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        // Widget pengganti saat gambar gagal dimuat
                                                        return Container(
                                                          color: Colors.grey[
                                                              200], // Latar belakang pengganti
                                                          child: Icon(
                                                            Icons
                                                                .image_not_supported_sharp,
                                                            color: Colors.grey,
                                                            size: 50,
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : const Icon(Icons
                                                      .image_not_supported),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // Nama Barang
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize:
                                                  14, // Kurangi ukuran teks
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          // Harga Barang
                                          Text(
                                            'Rp. ${NumberFormat("#,###", "id_ID").format(product.price)}',
                                            style: TextStyle(
                                              fontSize:
                                                  13, // Kurangi ukuran teks
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
                                                    _decrementBarangDonasi(
                                                        index), // Decrement quantity
                                                icon: const Icon(Icons.remove,
                                                    color: Colors.black),
                                                iconSize:
                                                    20, // Sesuaikan ukuran ikon
                                              ),
                                              Flexible(
                                                child: Text(
                                                  '${_quantities[index]}', // Menampilkan quantity yang disimpan
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    _incrementBarangDonasi(
                                                        index), // Increment quantity
                                                icon: const Icon(Icons.add,
                                                    color: Colors.black),
                                                iconSize:
                                                    20, // Sesuaikan ukuran ikon
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
            child: Container(
              width: 80, // Lebar tombol keranjang
              height: 70, // Tinggi tombol keranjang
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 147, 181, 255), // Warna tombol
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Icon(
                Icons.add_shopping_cart_rounded,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 80, // Mulai dari kanan tombol keranjang
            right: 0,
            child: Container(
              height: 70, // Tinggi sama dengan tombol keranjang
              padding: const EdgeInsets.symmetric(
                  horizontal: 20), // Hanya padding horizontal
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                ),
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
                  'Beli Sekarang',
                  style: TextStyle(
                    color: Color.fromARGB(255, 147, 181, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
