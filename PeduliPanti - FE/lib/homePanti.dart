import 'package:donatur_peduli_panti/notifikasiPAN.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profile.dart';
import 'detailPanti.dart'; // Import the detailPanti.dart file
import 'reqBarang.dart'; // Import the reqBarang.dart file
import 'cekRab.dart'; // Import the cekRab.dart file
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  // List of orphanages as a list of maps
  final List<Map<String, dynamic>> orphanages = [
    {
      "name": "Nama Panti Asuhan 1",
      "targetDonation": 100000,
      "collectedDonation": 15000,
    },
    {
      "name": "Nama Panti Asuhan 2",
      "targetDonation": 100000,
      "collectedDonation": 30000,
    },
    {
      "name": "Nama Panti Asuhan 3",
      "targetDonation": 100000,
      "collectedDonation": 60000,
    },
    {
      "name": "Nama Panti Asuhan 4",
      "targetDonation": 100000,
      "collectedDonation": 80000,
    },
    {
      "name": "Nama Panti Asuhan 5",
      "targetDonation": 100000,
      "collectedDonation": 90000,
    },
  ];

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
                            const CekRabPage(),
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
                color: Colors.blue[50], // Background color
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
                                fontSize: 18,
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
                              border: Border.all(color: Colors.black),
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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Presentase Donasi Bulan Ini",
                                  style: TextStyle(color: Colors.black)),
                              Text("80%",
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          LinearProgressIndicator(
                            value: 0.8,
                            backgroundColor: Colors.grey[300],
                            color: const Color.fromARGB(255, 164, 196, 253),
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0), // Added horizontal padding
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
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 30.0), // Added horizontal padding
              child: Text(
                "Panti Asuhan",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 5),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orphanages.length,
              itemBuilder: (context, index) {
                final orphanage = orphanages[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const DetailPanti()), // Navigate to DetailPanti
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0), // Added horizontal padding
                    child: DonationCard(
                      name: orphanage["name"],
                      targetDonation: orphanage["targetDonation"],
                      collectedDonation: orphanage["collectedDonation"],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
                height:
                    80), // Added space below to prevent navbar from covering cards
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
      margin: const EdgeInsets.symmetric(vertical: 8),
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
