import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:donatur_peduli_panti/succesPay.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Pesanan extends StatelessWidget {
  final List<SelectedItem> selectedItems;

  const Pesanan({
    super.key,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: PesananPage(selectedItems: selectedItems),
    );
  }
}

// selected_items.dart
class SelectedItem {
  final String pantiName;
  final String itemName;
  final int quantity;
  final int price;
  final int totalPrice;

  SelectedItem({
    required this.pantiName,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });
}

class PaymentMethod {
  final String id;
  final String name;
  final String imageUrl;
  final double balance;
  final String userId; // Tambah field userId

  PaymentMethod({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.balance,
    required this.userId,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      balance: json['balance'].toDouble(),
      userId: json['user_id'],
    );
  }
}

class PesananPage extends StatefulWidget {
  final List<SelectedItem> selectedItems;

  const PesananPage({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);
  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  // String _selectedMethod = "Gopay";
  String _selectedAmount = "Jumlah Isi Saldo (Rupiah)";
  String _selectedMethod = 'Pilih Metode Pembayaran';
  final String baseUrl = 'http://172.20.10.4:8000/api/v1';

  Widget _buildPaymentMethod(
      String method, String icon, String amount, double totalPembayaran) {
    // Convert amount string to double for comparison
    double balance = double.parse(amount.replaceAll('.', ''));
    bool isSufficient = balance >= totalPembayaran;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        enabled: isSufficient, // Disable if balance insufficient
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Image.asset(
          icon,
          width: 40,
          height: 40,
        ),
        title: Text(
          method,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSufficient ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rp $amount',
              style: TextStyle(
                color: isSufficient ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!isSufficient)
              Text(
                'Saldo tidak mencukupi',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 18, color: isSufficient ? Colors.black : Colors.grey),
        onTap: isSufficient
            ? () => _updatePaymentMethod(method, 'Rp $amount')
            : null,
      ),
    );
  }

  void _initiatePayment(String method, String amount) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      final response = await http.post(
        Uri.parse('$baseUrl/orders/payment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': 'User Name', // Get this from user data
          'payment_method': method.toLowerCase(),
          'amount': int.parse(amount.replaceAll('.', '')),
        }),
      );

      // Hide loading indicator
      Navigator.pop(context);

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success' &&
          responseData['deeplink_url'] != null) {
        final Uri url = Uri.parse(responseData['deeplink_url']);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch payment app';
        }
      } else {
        throw 'Invalid response from server';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memproses pembayaran. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
    Navigator.pop(context);
  }

  Map<String, List<Map<String, String>>> getDataBarangByPanti() {
    Map<String, List<Map<String, String>>> groupedData = {};

    for (var item in widget.selectedItems) {
      if (!groupedData.containsKey(item.pantiName)) {
        groupedData[item.pantiName] = [];
      }

      groupedData[item.pantiName]!.add({
        "namaBarang": item.itemName,
        "jumlah": item.quantity.toString(),
        "harga": "Rp.${NumberFormat("#,###", "id_ID").format(item.price)}",
        "jumlahHarga":
            "Rp.${NumberFormat("#,###", "id_ID").format(item.totalPrice)}"
      });
    }

    return groupedData;
  }

  // Calculate total price for all items
  int calculateTotalPrice() {
    return widget.selectedItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  void initState() {
    super.initState();
    // Set default payment method based on total payment
    double totalPayment =
        calculateTotalPrice() + (calculateTotalPrice() * 0.05);

    // Check each payment method's balance
    Map<String, double> balances = {
      'OVO': 1000000,
      'Gopay': 1000000,
      'Dana': 1000000,
    };

    // Find first payment method with sufficient balance
    String? defaultMethod = balances.entries
        .where((entry) => entry.value >= totalPayment)
        .map((entry) => entry.key)
        .firstOrNull;

    if (defaultMethod != null) {
      setState(() {
        _selectedMethod = defaultMethod;
        _selectedAmount =
            'Rp.${NumberFormat("#,###", "id_ID").format(balances[defaultMethod])}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = getDataBarangByPanti();
    final totalPrice = calculateTotalPrice();
    final feeTransaksi = (totalPrice * 0.05).round();
    final totalPembayaran = totalPrice + feeTransaksi;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                      'Metode Pembayaran',
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
                                  _buildPaymentMethod(
                                    'OVO',
                                    'assets/img/ovo.png',
                                    '1000000',
                                    totalPembayaran.toDouble(),
                                  ),
                                  _buildPaymentMethod(
                                    'Gopay',
                                    'assets/img/gopay.png',
                                    '1000000',
                                    totalPembayaran.toDouble(),
                                  ),
                                  _buildPaymentMethod(
                                    'Dana',
                                    'assets/img/dana.png',
                                    '1000000',
                                    totalPembayaran.toDouble(),
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
                                      'assets/img/ovo.png',
                                  width: 40,
                                  height: 40,
                                ),
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
                        ...groupedData.entries.map((entry) {
                          double totalPembayaran =
                              entry.value.fold(0.0, (sum, item) {
                            double itemTotal =
                                double.tryParse(item["jumlahHarga"] ?? "0") ??
                                    0.0;
                            return sum + itemTotal;
                          });
                          return Container(
                            margin: EdgeInsets.only(bottom: 20),
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
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key, // Nama Panti
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 15),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Table(
                                    border: TableBorder(
                                      horizontalInside: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                      top: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade300),
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
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Nama Barang',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Jumlah',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Harga',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Total',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ...entry.value
                                          .map((item) => TableRow(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        item["namaBarang"]!),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      item["jumlah"]!,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      item["harga"]!,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      item["jumlahHarga"]!,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text('Fee Transaksi (5%)'),
                              ),
                              Container(
                                child: Text(
                                    'Rp.${NumberFormat("#,###", "id_ID").format(feeTransaksi)}'),
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
                                  'Rp.${NumberFormat("#,###", "id_ID").format(totalPembayaran)}',
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
                                      vertical: 15, horizontal: 70),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    // Siapkan data pembayaran
                                    final paymentData = {
                                      'name': 'User Name',
                                      'qty': widget.selectedItems.length,
                                      'price': totalPrice,
                                      'grand_total': totalPembayaran * 1,
                                    };

                                    // Debug: Cetak data pembayaran untuk memverifikasi
                                    print('Sending Payment Data: $paymentData');

                                    // Kirim data ke API
                                    final response = await http.post(
                                      Uri.parse(
                                          'http://172.20.10.4:8000/api/v1/orders/payment'),
                                      headers: {
                                        'Content-Type': 'application/json',
                                        'Accept': 'application/json',
                                      },
                                      body: jsonEncode(paymentData),
                                    );

                                    // Debug: Cetak respons untuk memverifikasi
                                    print(
                                        'Response Status Code: ${response.statusCode}');
                                    print('Response Body: ${response.body}');

                                    // Parsing data dari respons API
                                    final responseData =
                                        json.decode(response.body);

                                    // Jika respons sukses
                                    if (response.statusCode == 200 &&
                                        responseData['status'] == 'success') {
                                      // Navigasi ke halaman sukses tanpa dialog loading
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SuccesPayPage(),
                                        ),
                                      );
                                    } else {
                                      // Tampilkan error jika status tidak success
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Payment Error: ${responseData['message'] ?? 'Unknown error occurred'}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    // Tangani error jika terjadi kesalahan
                                    print('Error: $e');

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error: ${e.toString()}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
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
              'Rp.${NumberFormat("#,###", "id_ID").format(totalPembayaran)}',
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
