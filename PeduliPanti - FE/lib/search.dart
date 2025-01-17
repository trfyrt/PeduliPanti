import 'package:donatur_peduli_panti/detailPanti_donatur.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchAppState();
}

class _SearchAppState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: const SearchPage(title: 'Peduli Panti'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.title});

  final String title;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  String _currentSearch = "";
  List<Map<String, dynamic>> filteredData = [];

  final List<Map<String, dynamic>> data = [
    {"nama": "Panti Asuhan 1", "jumlah": 50, "progress": 0.5},
    {"nama": "Panti Asuhan 2", "jumlah": 30, "progress": 0.3},
    {"nama": "Panti Asuhan 3", "jumlah": 70, "progress": 0.7},
    {"nama": "Panti Asuhan 4", "jumlah": 90, "progress": 0.9},
    {"nama": "Panti Asuhan 5", "jumlah": 90, "progress": 0.9},
    {"nama": "Panti Asuhan 5", "jumlah": 90, "progress": 0.9},
  ];

  @override
  void initState() {
    super.initState();
    // Default, tampilkan semua data
    filteredData = List.from(data);
  }

  void _updateSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        // Tampilkan semua data jika query kosong
        filteredData = List.from(data);
      } else {
        // Filter data berdasarkan nama
        filteredData = data
            .where((item) =>
                item['nama'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      if (query.isNotEmpty) {
        _searchHistory.insert(0, query);
        // Batasi hanya 3 history terbaru
        if (_searchHistory.length > 3) {
          _searchHistory = _searchHistory.sublist(0, 3);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 193, 211, 254),
            Color.fromARGB(255, 255, 255, 255)
          ],
          stops: [0.1, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const HomeDonaturApp(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return child;
                              },
                            ), // Halaman profil
                          );
                        },
                      ),
                    )),
                onSubmitted: _updateSearchResults,
              ),
              if (_searchController
                  .text.isEmpty) // Tampilkan histori jika kosong
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: _searchHistory.map((history) {
                          return ListTile(
                            leading:
                                const Icon(Icons.history, color: Colors.grey),
                            title: Text(history),
                            onTap: () {
                              _searchController.text = history;
                              _updateSearchResults(history);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final item = filteredData[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailPantiApp(pantiId: pantiId),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 129, 129, 129)
                                  .withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item['nama'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color:
                                            Color.fromARGB(255, 107, 125, 167),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      child: const Icon(Icons.verified,
                                          color: Color.fromARGB(
                                              255, 107, 125, 167),
                                          size: 18),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 18,
                                        color:
                                            Color.fromARGB(255, 107, 125, 167)),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        '${item['jumlah']}',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 107, 125, 167),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 25),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        height: 15,
                                        child: LinearProgressIndicator(
                                          value: item['progress'],
                                          backgroundColor: const Color.fromARGB(
                                              255, 229, 229, 229),
                                          color: const Color.fromARGB(
                                              255, 107, 125, 167),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      '${(item['progress'] * 100).toInt()}%',
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 107, 125, 167),
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
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
