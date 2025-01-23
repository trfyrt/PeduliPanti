import 'package:donatur_peduli_panti/RABAI.dart';
import 'package:donatur_peduli_panti/notifikasiPAN.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profile.dart';
import 'detailPanti.dart';
import 'reqBarang.dart';
import 'cekRab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> orphanages = [];
  TextEditingController persentaseDonasiController = TextEditingController();

  String _getPercentageText(double donationTotal, double targetDonation) {
    double percentage = _getPercentageValue(donationTotal, targetDonation);
    return "${(percentage).toStringAsFixed(0)}%";
  }

  // Fungsi untuk menghitung persentase donasi
  double _getPercentageValue(double donationTotal, double targetDonation) {
    if (targetDonation == 0) return 0.0; // Menghindari pembagian dengan nol
    return (donationTotal / targetDonation) * 100;
  }

  int? pantiID;

  @override
  void initState() {
    super.initState();
    fetchListOrphanage();
    _fetchUserData();
  }

  static const String _baseUrl = 'http://192.168.177.165:8000/api/v1';

  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = jsonDecode(userJson);
        print("User ID: ${user['id']}");
        return user['id'];
      } else {
        print("User data not found in SharedPreferences.");
      }
    } catch (e) {
      print("Error retrieving user ID: $e");
    }
    return null;
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        print("User ID is null. Ensure _getUserId() returns a valid ID.");
        return;
      }

      final url = Uri.parse('$_baseUrl/user/$userId');
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer ${await getToken()}"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Fetched data: $data");

        // Validasi struktur JSON
        if (data != null &&
            data['data'] != null &&
            data['data']['pantiDetails'] != null) {
          final pantiDetails = data['data']['pantiDetails'];

          // Update controller values dengan data yang diambil
          setState(() {
            // Ensure donationTotal is a String
            persentaseDonasiController.text =
                pantiDetails['donationTotal'].toString();
          });

          print("User data fetched and updated successfully.");
        } else {
          print("Invalid JSON structure: $data");
        }
      } else {
        print("Failed to fetch user data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Function to get the stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> getPantiId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = jsonDecode(userJson);
        print("Panti ID: ${user['id']}");
        return user['id'];
      } else {
        print("Panti data not found in SharedPreferences.");
      }
    } catch (e) {
      print("Error retrieving panti ID: $e");
    }
    return null;
  }

  static Future<int?> fetchDonationTotalByPanti() async {
    try {
      final pantiId = await getPantiId();
      if (pantiId == null) {
        throw Exception("Panti ID not found");
      }

      final url = Uri.parse('$_baseUrl/panti/$pantiId');
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer ${await getToken()}"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Akses data['data']['donationTotal'] sesuai dengan struktur API
        return data['data']
            ['donationTotal']; // Pastikan sesuai dengan struktur API
      } else {
        throw Exception("Failed to fetch donation total: ${response.body}");
      }
    } catch (e) {
      print("Error fetching donation total: $e");
      return null;
    }
  }

  static Future<void> fetchOrphanageDetails({
    required int id,
    required Function(dynamic data)
        onDataFetchSuccess, // Callback for successful data fetch
    required Function(String error) onError, // Callback for handling errors
  }) async {
    final url = Uri.parse('$_baseUrl/panti_detail/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);
        final orphanageData = data['data'];

        // Trigger callback with fetched data
        onDataFetchSuccess(orphanageData);
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? "Unknown error occurred";
        print("Failed to fetch orphanage details: $errorMessage");
        onError("Failed to fetch orphanage details. Please try again.");
      }
    } catch (e) {
      print(
          "An error occurred during fetching orphanage details: ${e.toString()}");
      onError("An unexpected error occurred. Please try again.");
    }
  }

  Future<void> fetchListOrphanage() async {
    try {
      final url = Uri.parse('$_baseUrl/panti_detail');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final apiData = data['data'];

        // Memperbarui data orphanages
        setState(() {
          orphanages = apiData.map<Map<String, dynamic>>((orphanage) {
            return {
              'id': orphanage['id'], // Added id for each orphanage
              'name': orphanage['name'],
              'targetDonation':
                  100000000, // Bisa disesuaikan sesuai API atau target lainnya
              'collectedDonation': orphanage['donationTotal'],
            };
          }).toList();
          // Sort the orphanages list by the smallest percentage
          orphanages.sort((a, b) =>
              (a["collectedDonation"] / a["targetDonation"])
                  .compareTo(b["collectedDonation"] / b["targetDonation"]));
        });
      } else {
        print('Gagal mengambil data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int _currentIndex = 0;

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
                  tooltip: 'CekRab',
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
                            PdfEvaluatorScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child; // Tidak ada animasi
                        },
                      ), // Halaman CekRab
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              "Cek RAB",
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
                        const HomePage(),
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
                        const CekRabPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child; // Tidak ada animasi
                    },
                  ), // Halaman utama
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ProfilePage(),
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
                label: '',
                icon: SizedBox.shrink(),
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
      backgroundColor: const Color.fromARGB(255, 255, 251, 251),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Added missing children list
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 147, 181, 255), // Background color
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(16.0), // Padding inside the container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                        height:
                            16), // Added padding above search and notification
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(height: 1),
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.1),
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationPage()), // Navigate to NotificationPage
                                );
                              },
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: const Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Added horizontal padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Grafik Donasi Tiap Bulan",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: BarChart(
                              BarChartData(
                                borderData: FlBorderData(
                                  border: const Border(
                                    left: BorderSide(color: Colors.black),
                                    bottom: BorderSide(color: Colors.black),
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 28,
                                      getTitlesWidget: (value, _) => Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, _) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return const Text("Jan",
                                                style: TextStyle(
                                                    color: Colors.black));
                                          case 1:
                                            return const Text("Feb",
                                                style: TextStyle(
                                                    color: Colors.black));
                                          case 2:
                                            return const Text("Mar",
                                                style: TextStyle(
                                                    color: Colors.black));
                                          case 3:
                                            return const Text("Apr",
                                                style: TextStyle(
                                                    color: Colors.black));
                                          default:
                                            return const Text("");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                barGroups: [
                                  BarChartGroupData(x: 0, barRods: [
                                    BarChartRodData(
                                      toY: 10,
                                      color: const Color.fromARGB(
                                          255, 164, 196, 253),
                                      width: 24,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ]),
                                  BarChartGroupData(x: 1, barRods: [
                                    BarChartRodData(
                                      toY: 30000 / 100000 * 100,
                                      color: const Color.fromARGB(
                                          255, 164, 196, 253),
                                      width: 24,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ]),
                                  BarChartGroupData(x: 2, barRods: [
                                    BarChartRodData(
                                      toY: 60000 / 100000 * 100,
                                      color: const Color.fromARGB(
                                          255, 164, 196, 253),
                                      width: 24,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ]),
                                  BarChartGroupData(x: 3, barRods: [
                                    BarChartRodData(
                                      toY: 80000 / 100000 * 100,
                                      color: const Color.fromARGB(
                                          255, 164, 196, 253),
                                      width: 24,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ]),
                                ],
                                gridData: const FlGridData(show: false),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Presentase Donasi Bulan Ini",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      // Menggunakan fungsi untuk memeriksa apakah input valid
                                      _getPercentageText(
                                          double.tryParse(
                                                  persentaseDonasiController
                                                      .text) ??
                                              0.0,
                                          100000000.0), // Assuming 100000 is the target donation
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                LinearProgressIndicator(
                                  // Menggunakan fungsi untuk memeriksa apakah input valid sebelum menghitung
                                  value: _getPercentageValue(
                                          double.tryParse(
                                                  persentaseDonasiController
                                                      .text) ??
                                              0.0,
                                          100000000.0) /
                                      100.0, // Dividing by 100 to show the correct progress
                                  backgroundColor: Colors.grey[300],
                                  color:
                                      const Color.fromARGB(255, 164, 196, 253),
                                  minHeight: 12,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
                height: 10), // Reduced space between the title and cards
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 5.0), // Added horizontal padding
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RequestPage()), // Navigate to RequestPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  "Request Barang",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  top: 5.0), // Reduced vertical padding
              child: Text(
                "Panti Asuhan",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orphanages.length,
              itemBuilder: (context, index) {
                final orphanage = orphanages[index];
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke DetailPanti dan mengirimkan id
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPanti(
                            id: orphanage['id']), // Mengirimkan id panti
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15,
                        right: 15.0,
                        bottom: 4.0), // Added horizontal padding
                    child: DonationCard(
                      name: orphanage["name"],
                      targetDonation: orphanage["targetDonation"],
                      collectedDonation: orphanage["collectedDonation"],
                    ),
                  ),
                );
              },
            ), // Added space below to prevent navbar from covering cards
          ],
        ),
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final String name;
  final int targetDonation;
  final int collectedDonation;

  const DonationCard({
    super.key,
    required this.name,
    required this.targetDonation,
    required this.collectedDonation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 251, 251, 251),
              Color.fromARGB(255, 227, 245, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Changed to black
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rp.$collectedDonation/Rp.$targetDonation",
                  style: const TextStyle(
                    color: Colors.black, // Changed to black
                  ),
                ),
                Text(
                  "${(collectedDonation / targetDonation * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.black, // Changed to black
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: collectedDonation / targetDonation,
              backgroundColor: Colors.grey[300],
              color: const Color.fromARGB(255, 164, 196, 253),
              minHeight: 12,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ],
        ),
      ),
    );
  }
}
