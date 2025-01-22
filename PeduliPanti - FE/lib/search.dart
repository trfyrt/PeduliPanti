import 'package:donatur_peduli_panti/detailPanti_donatur.dart';
import 'package:donatur_peduli_panti/Services/auth_service.dart';
import 'package:donatur_peduli_panti/Services/api_service.dart';
import 'package:donatur_peduli_panti/Models/Panti.dart';
import 'package:donatur_peduli_panti/homeDonatur.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchAppState();
}

class _SearchAppState extends State<Search> {
  Map<String, dynamic>? user; // Variabel untuk menyimpan data user

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService.getUser(); // Ambil data user
    if (userData != null) {
      setState(() {
        user = userData; // Perbarui state dengan data user
      });
    }
  }

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
  List<Panti> filteredData = []; // This will store the filtered list of panti
  Map<String, dynamic>? user;
  List<Panti> pantis = []; // Original list of pantis fetched from API
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPantis();
  }

  Future<void> _fetchPantis() async {
    try {
      final data = await ApiService.fetchPantiDetails();
      setState(() {
        pantis = data;
        filteredData =
            List.from(pantis);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pantis: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService.getUser(); // Fetch user data
    if (userData != null) {
      setState(() {
        user = userData; // Update user data
      });
    }
  }

  void _updateSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, show all data
        filteredData = List.from(pantis);
      } else {
        // Filter data based on the search query
        filteredData = pantis
            .where((item) => item.name.toLowerCase().contains(
                query.toLowerCase())) // Adjust based on your Panti model field
            .toList();
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
          margin: const EdgeInsets.only(right: 16, left: 16, top: 45),
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
                onChanged: (query) {
                  // Only update search results without modifying history
                  _updateSearchResults(query);
                },
                onSubmitted: (query) {
                  // Handle search when the Enter key is pressed
                  if (query.isNotEmpty) {
                    _updateSearchResults(query); // Update the search results

                    // Add query to history if it's not empty and not already in history
                    if (!_searchHistory.contains(query)) {
                      setState(() {
                        _searchHistory.insert(0, query);
                        // Limit search history to the 3 most recent searches
                        if (_searchHistory.length > 3) {
                          _searchHistory = _searchHistory.sublist(0, 3);
                        }
                      });
                    }
                  }
                },
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
                    children: _searchHistory.map((history) {
                      return ListTile(
                        leading: const Icon(Icons.history, color: Colors.grey),
                        title: Text(history),
                        onTap: () {
                          _searchController.text = history;
                          _updateSearchResults(history);
                        },
                      );
                    }).toList(),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  // Membuat seluruh konten bisa di-scroll
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: filteredData.map((panti) {
                      final double progress =
                          panti.donationTotal / (686000 * panti.childNumber);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPantiApp(pantiId: panti.id),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 8),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        panti.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Color.fromARGB(
                                              255, 107, 125, 167),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: const Icon(
                                          Icons.verified,
                                          color: Color.fromARGB(
                                              255, 107, 125, 167),
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 18,
                                        color:
                                            Color.fromARGB(255, 107, 125, 167),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: const Text(
                                          '0', // Jumlah diatur ke 0 untuk sekarang
                                          style: TextStyle(
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
                                            value: progress.clamp(0.0, 1.0),
                                            backgroundColor:
                                                const Color.fromARGB(
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
                                        '${(progress * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 107, 125, 167),
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
                    }).toList(),
                  ),
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
