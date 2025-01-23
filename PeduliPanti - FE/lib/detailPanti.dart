import 'package:donatur_peduli_panti/Models/Panti.dart';
import 'package:donatur_peduli_panti/Services/api_service.dart';
import 'package:donatur_peduli_panti/notifikasiPAN.dart';
import 'homePanti.dart';
import 'historiRABPanti.dart'; // Import the new page
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPanti extends StatelessWidget {
  const DetailPanti({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    checkPantiId(id); // Check if pantiId has been sent
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: MyHomePage(title: 'Peduli Panti', pantiId: id),
      debugShowCheckedModeBanner: false,
    );
  }

  void checkPantiId(int pantiId) {
    print('Panti ID: $pantiId'); // Print the pantiId
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.pantiId});
  final int pantiId;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location = new Location();

  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  late MapController mapController;
  Panti? pantiData;

  @override
  void initState() {
    super.initState();
    initLocation();
    mapController = MapController();
    fetchPantiDetails(); // Fetch panti data
  }

  initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    if (_locationData != null) {
      print(
          'Latitude: ${_locationData!.latitude}, Longitude: ${_locationData!.longitude}');
    }
  }

  fetchPantiDetails() async {
    try {
      final fetchedPanti = await ApiService.fetchPantiDetails(); // Panggil API
      final panti = fetchedPanti.firstWhere(
        (panti) => panti.id == widget.pantiId,
        orElse: () => throw Exception(
            'Panti dengan ID ${widget.pantiId} tidak ditemukan'),
      );

      setState(() {
        pantiData = panti;
      });
    } catch (e) {
      print("Error fetching panti details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 245, 240, 240),
                        spreadRadius: 4,
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/img/panti1.png', // Corrected path to assets folder
                      width: double.infinity, // Full width
                      fit: BoxFit.cover, // Cover the area
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, top: 20, bottom: 3),
                      child: Text(
                        pantiData != null ? pantiData!.name : 'Loading...',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, bottom: 5),
                      child: Text(
                        pantiData != null ? pantiData!.address : 'Loading...',
                        style: const TextStyle(
                          color: Color.fromARGB(60, 33, 33, 33),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromARGB(60, 33, 33, 33),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(right: 15, left: 15, bottom: 5),
                      height: 1,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 6, right: 15, left: 15, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  child: const Icon(
                                    FontAwesomeIcons.solidCircleCheck,
                                    size: 18,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 7),
                                  child: const Text('Legalitas Terverifikasi'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 245, 240, 240),
                        spreadRadius: 4,
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 7),
                            child: const Text(
                              'Donasi Terkumpul',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    pantiData != null
                                        ? 'Rp. ' +
                                            pantiData!.donationTotal.toString()
                                        : 'Loading...',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 107, 125, 167),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Text(
                                    'dari',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: const Text(
                                    'Rp.100000000',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 15,
                                      child: LinearProgressIndicator(
                                        value: pantiData != null
                                            ? (pantiData!.donationTotal /
                                                    100000000)
                                                .toDouble()
                                            : 0.0,
                                        backgroundColor:
                                            Color.fromARGB(255, 229, 229, 229),
                                        color:
                                            Color.fromARGB(255, 107, 125, 167),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 245, 240, 240),
                        spreadRadius: 4,
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jejak Panti Asuhan 1',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: const Icon(
                                            Icons.calendar_month_rounded),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Lahirnya Panti Asuhan 1',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                child: const Text('pada'),
                                              ),
                                              Container(
                                                child: Text(pantiData != null
                                                    ? pantiData!.foundingDate
                                                    : 'Loading...'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 7),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        child: const Icon(
                                          FontAwesomeIcons.users,
                                          size: 19,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Penjaga Panti Asuhan 1',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                child: const Text(
                                                    'telah mencapai'),
                                              ),
                                              Container(
                                                child:
                                                    const Text('1278 Donatur'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 7),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: const Icon(
                                            FontAwesomeIcons.clipboardCheck),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HistoriRABPage(
                                    pantiDetail: pantiData), // Replace with your new page widget
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Transparansi Bantuan',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  child: const Text('13'),
                                                ),
                                                Container(
                                                  child: const Text(
                                                      'Laporan Keuangan'),
                                                ),
                                              ],
                                            )
                                          ],
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
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 245, 240, 240),
                        spreadRadius: 4,
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              'Deksripsi Panti Asuhan 1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Text(
                              pantiData != null
                                  ? pantiData!.description
                                  : 'Loading...',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 245, 240, 240),
                        spreadRadius: 4,
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    'Lokasi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Lihat Peta',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 0, 85, 214)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 155, 155, 155),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                      initialZoom: 10,
                                      initialCenter:
                                          LatLng(-5.147665, 119.432731),
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              pantiData != null
                                  ? pantiData!.address
                                  : 'Loading...',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()), // Halaman tujuan
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 250, 250, 250),
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
            top: 40,
            right: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NotificationPage()), // Navigate to Notifikasi page
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 250, 250, 250),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  FontAwesomeIcons
                      .bell, // Changed from cart to notification icon
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
