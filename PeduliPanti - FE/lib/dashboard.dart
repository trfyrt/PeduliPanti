import 'package:flutter/material.dart';

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Topup Game Shop',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primaryColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      home: const MyHomePage(title: 'Topup Game'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> imagePaths = [
    'assets/coc.png',
    'assets/cr.png',
    'assets/hok.png',
    'assets/ff.png',
    'assets/genshin.png',
    'assets/ml.png',
    'assets/honkai.png',
    'assets/apex.png',
    'assets/valo.png',
    'assets/pubg.png',
  ];

  final List<String> titles = [
    'Clash of Clans',
    'Clash Royale',
    'Honor Of Kings',
    'Free Fire',
    'Genshin Impact',
    'Mobile Legends',
    'Honkai Impact 3',
    'Apex Legends',
    'Valorant',
    'PUBG',
  ];

  List<Card> _buildGridCards(int count) {
    List<Card> cards = List.generate(
      count,
      (int index) {
        String imagePath = imagePaths[index % imagePaths.length];
        String title = titles[index % titles.length];

        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4.0,
          color: Colors.white,
          child: InkWell(
            onTap: () {
              // Navigasi ke halaman detail game sesuai dengan yang dipilih
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailPage(
                    gameTitle: title,
                    gameImage: imagePath,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 18.0 / 11.0,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
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
    );
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                semanticLabel: 'menu',
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              print('Filter button');
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Top Up', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: _buildGridCards(10),
      ),
    );
  }
}

class GameDetailPage extends StatelessWidget {
  final String gameTitle;
  final String gameImage;

  const GameDetailPage({
    super.key,
    required this.gameTitle,
    required this.gameImage,
  });

  @override
  Widget build(BuildContext context) {
    // Daftar harga untuk topup game
    Map<String, List<Map<String, dynamic>>> gameTopup = {
      'Mobile Legends': [
        {'diamond': 100, 'price': 10000},
        {'diamond': 250, 'price': 20000},
        {'diamond': 500, 'price': 35000},
      ],
      'Valorant': [
        {'diamond': 500, 'price': 15000},
        {'diamond': 1000, 'price': 30000},
        {'diamond': 2000, 'price': 55000},
      ],
    };

    // Mengambil daftar topup yang sesuai dengan game
    List<Map<String, dynamic>> topupItems = gameTopup[gameTitle] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(gameTitle, style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Menampilkan gambar yang dipilih
            Image.asset(gameImage, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            
            // Form untuk mengisi user id dan nama
            TextField(
              decoration: InputDecoration(
                labelText: 'User ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Dropdown list untuk memilih item topup
            Text(
              'Pilih Diamond',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField(
              items: topupItems.map((item) {
                return DropdownMenuItem(
                  value: item['diamond'],
                  child: Text('${item['diamond']} Diamonds - Rp ${item['price']}'),
                );
              }).toList(),
              onChanged: (value) {
                // Handle selected item
              },
              decoration: InputDecoration(
                labelText: 'Diamond',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
