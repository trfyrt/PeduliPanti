import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:peduliPanti/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      print("Tab ke-$index ditekan");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 251, 251),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0,), // Adjusted padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16), // Added padding above search and notification
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(height: 1),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: Colors.transparent, width: 0.1),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications, color: Colors.black),
                        onPressed: () {
                          // Action for notification button
                        },
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
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
              SizedBox(height: 16),
              Text(
                "Grafik Donasi Tiap Bulan",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 16),
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
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            switch (value.toInt()) {
                              case 0:
                                return Text("Jan", style: TextStyle(color: Colors.black));
                              case 1:
                                return Text("Feb", style: TextStyle(color: Colors.black));
                              case 2:
                                return Text("Mar", style: TextStyle(color: Colors.black));
                              case 3:
                                return Text("Apr", style: TextStyle(color: Colors.black));
                              default:
                                return Text("");
                            }
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                          toY: 10,
                          color: const Color.fromARGB(255, 164, 196, 253),
                          width: 24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                          toY: 30000 / 100000 * 100,
                          color: const Color.fromARGB(255, 164, 196, 253),
                          width: 24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                          toY: 60000 / 100000 * 100,
                          color: const Color.fromARGB(255, 164, 196, 253),
                          width: 24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(
                          toY: 80000 / 100000 * 100,
                          color: const Color.fromARGB(255, 164, 196, 253),
                          width: 24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ]),
                    ],
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Presentase Donasi Bulan Ini", style: TextStyle(color: Colors.black)),
                  Text("80%", style: TextStyle(color: Colors.black)),
                ],
              ),
              LinearProgressIndicator(
                value: 0.8,
                backgroundColor: Colors.grey[300],
                color: const Color.fromARGB(255, 164, 196, 253),
                minHeight: 12,
                borderRadius: BorderRadius.circular(8.0),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  // Action for requesting items
                },
                child: Text(
                  "Request Barang",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 32),
              Text(
                "Panti Asuhan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 5),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  DonationCard(
                    name: "Nama Panti Asuhan 1",
                    targetDonation: 100000,
                    collectedDonation: 15000,
                  ),
                  DonationCard(
                    name: "Nama Panti Asuhan 2",
                    targetDonation: 100000,
                    collectedDonation: 30000,
                  ),
                  DonationCard(
                    name: "Nama Panti Asuhan 3",
                    targetDonation: 100000,
                    collectedDonation: 60000,
                  ),
                  DonationCard(
                    name: "Nama Panti Asuhan 4",
                    targetDonation: 100000,
                    collectedDonation: 80000,
                  ),
                  DonationCard(
                    name: "Nama Panti Asuhan 5",
                    targetDonation: 100000,
                    collectedDonation: 90000,
                  ),
                ],
              ),
              SizedBox(height: 80), // Added space below to prevent navbar from covering cards
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color.fromARGB(255, 232, 243, 255),
        activeColor: const Color.fromARGB(255, 202, 222, 243),
        color: Colors.black54,
        items: [
          TabItem(icon: Icons.home, title: 'Utama'),
          TabItem(icon: Icons.file_copy, title: 'Cek RAB'), 
          TabItem(icon: Icons.person, title: 'Profil'),
        ],
        style: TabStyle.fixedCircle,
        initialActiveIndex: _selectedIndex, // Set the active index
        onTap: _onItemTapped, // Use the method to handle tap
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final String name;
  final int targetDonation;
  final int collectedDonation;

  const DonationCard({
    required this.name,
    required this.targetDonation,
    required this.collectedDonation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 251, 251, 251),
              const Color.fromARGB(255, 227, 245, 255)
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Changed to black
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rp.${collectedDonation}/Rp.${targetDonation}",
                  style: TextStyle(
                    color: Colors.black, // Changed to black
                  ),
                ),
                Text(
                  "${(collectedDonation / targetDonation * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    color: Colors.black, // Changed to black
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
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
