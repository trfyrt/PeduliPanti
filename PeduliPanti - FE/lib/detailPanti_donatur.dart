import 'package:donatur_peduli_panti/Services/api_service.dart';
import 'package:donatur_peduli_panti/Models/Panti.dart';
import 'package:donatur_peduli_panti/historiRABDonatur.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';
// import 'package:donatur_peduli_panti/keranjang.dart';
import 'package:donatur_peduli_panti/market.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailPantiApp extends StatelessWidget {
  final int pantiId; // ID panti asuhan yang akan diterima

  const DetailPantiApp({Key? key, required this.pantiId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: MyHomePage(title: 'Peduli Panti', pantiId: pantiId),
      debugShowCheckedModeBanner: false,
    );
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
  Panti? pantiDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      initLocation(); // Jika ada logika khusus lokasi
      fetchPantiDetails();
    });
    mapController = MapController();
  }

  // Mengambil detail panti berdasarkan pantiId
  fetchPantiDetails() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });
    try {
      final fetchedPanti = await ApiService.fetchPantiDetails(); // Panggil API
      final panti = fetchedPanti.firstWhere(
        (panti) => panti.id == widget.pantiId,
        orElse: () => throw Exception(
            'Panti dengan ID ${widget.pantiId} tidak ditemukan'),
      );

      setState(() {
        pantiDetail = panti;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching panti details: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatDate(String date) {
    // Parsing string "YYYY-MM-DD" ke DateTime
    DateTime parsedDate = DateTime.parse(date);

    // Format ke "EEEE, dd MMMM yyyy"
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(parsedDate);

    return formattedDate;
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

  @override
  Widget build(BuildContext context) {
    final LatLng initialLocation = LatLng(
      pantiDetail?.origin?.lat ?? 5.1,
      pantiDetail?.origin?.lng ?? 119.4,
    );

    final double progressValue = (pantiDetail?.donationTotal ?? 0) /
        ((pantiDetail?.childNumber ?? 1) * 686000);

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 260,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/panti1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, top: 20, bottom: 3),
                      child: Text(
                        'Panti ${pantiDetail?.name}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, bottom: 5),
                      child: Text(
                        '${pantiDetail?.address}',
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
                          Container(
                            child: const Icon(FontAwesomeIcons.angleRight),
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
                                    'Rp.${pantiDetail?.donationTotal}',
                                    style: const TextStyle(
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
                                  child: Text(
                                    'Rp.${(pantiDetail?.childNumber ?? 0) * 686000}',
                                    style: const TextStyle(
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
                                        value: progressValue,
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
                          Text(
                            'Jejak Panti ${pantiDetail?.name}',
                            style: const TextStyle(
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
                                          Text(
                                            'Lahirnya Panti ${pantiDetail?.name}',
                                            style: const TextStyle(
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
                                                child: Text(formatDate(
                                                    pantiDetail?.foundingDate ??
                                                        "1990-01-01")),
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
                                          Text(
                                            'Jumlah anak Panti ${pantiDetail?.name}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                child: Text(
                                                    'sebanyak ${pantiDetail?.childNumber ?? 0} anak'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigasi ke halaman lain
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            HistoriRAB(
                                                pantiDetail: pantiDetail),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return child; // Tidak ada animasi
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 7),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: const Icon(
                                              FontAwesomeIcons.clipboardCheck),
                                        ),
                                        Column(
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
                                                  child: Text(
                                                      '${pantiDetail?.rabs.length ?? 0}'),
                                                ),
                                                Container(
                                                  child: const Text(
                                                      'Laporan Keuangan'),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
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
                              '${pantiDetail?.description ?? 'Description not found'}',
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
                                        initialZoom: 15,
                                        initialCenter: initialLocation),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          // Marker utama (lokasi awal)
                                          Marker(
                                            point: initialLocation,
                                            width: 80,
                                            height: 80,
                                            child: Icon(
                                              Icons.location_pin,
                                              size: 40,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
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
                              '${pantiDetail?.address}',
                              style: const TextStyle(
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
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const HomeDonaturApp(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ),
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
                print("Masuk ke keranjang");
                // Navigator.push(
                //   context,
                //   PageRouteBuilder(
                //     pageBuilder: (context, animation, secondaryAnimation) =>
                //         const Keranjang(),
                //     transitionsBuilder:
                //         (context, animation, secondaryAnimation, child) {
                //       return child;
                //     },
                //   ),
                // );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 250, 250, 250),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BottomAppBar(
          color: Color.fromARGB(255, 147, 181, 255),
          child: Container(
            height: 60, // Tinggi BottomAppBar
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Market(
                        pantiDetail: pantiDetail), // Mengirimkan ID panti
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0, // Hilangkan bayangan
                backgroundColor: Color.fromARGB(255, 147, 181, 255),
              ),
              child: Text(
                'Mulai Berdonasi',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
