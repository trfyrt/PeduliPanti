import 'package:flutter/material.dart';
import 'color.dart';

final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: kShrinePink100,
      onPrimary: kShrineBrown900,
      secondary: kShrineBrown900,
      error: kShrineErrorRed,
    ),
    // TODO: Add the text themes (103)
    // TODO: Decorate the inputs (103)
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peduli Panti'),
        backgroundColor: const Color.fromARGB(255, 162, 213, 255),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Implement menu functionality
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
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
      backgroundColor: const Color.fromARGB(209, 245, 245, 245),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(12.0),
        childAspectRatio: 0.8, // Mengatur rasio kartu
        mainAxisSpacing: 12.0, // Jarak vertikal antar kartu
        crossAxisSpacing: 12.0, // Jarak horizontal antar kartu
        children: <Widget>[
          for (var item in _items) _buildCard(item, context),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, String> item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDescription(context, item['title']!);
      },
      child: Card(
        color: const Color.fromARGB(255, 227, 246, 254), // Set card color to light blue
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: AspectRatio(
                aspectRatio: 1.2, // Ukuran gambar di dalam kartu
                child: Image.asset(
                  item['image']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item['title']!),
                  const SizedBox(height: 4.0),
                  Text(
                    item['price']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  // Removed description text to show only on tap
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDescription(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(_getDescription(title)),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getDescription(String title) {
    switch (title) {
      case 'Minyak Kelapa':
        return 'Minyak Kelapa adalah minyak yang diperoleh dari daging kelapa.';
      case 'Aqua':
        return 'Aqua adalah air mineral yang dikemas dalam botol.';
      case 'Beras':
        return 'Beras adalah bahan makanan pokok yang banyak dikonsumsi.';
      case 'Roti':
        return 'Roti adalah makanan yang terbuat dari tepung dan air.';
      case 'Indomie':
        return 'Indomie adalah mie instan yang populer di Indonesia.';
      case 'Gas':
        return 'Gas adalah bahan bakar yang digunakan untuk memasak.';
      default:
        return 'Deskripsi tidak tersedia.';
    }
  }
}

final List<Map<String, String>> _items = [
  {'image': 'minyak.webp', 'title': 'Minyak Kelapa', 'price': 'Rp. 70.000'},
  {'image': 'aqua.jpg', 'title': 'Aqua', 'price': 'Rp. 6.000'},
  {'image': 'beras.jpg', 'title': 'Beras', 'price': 'Rp. 100.000'},
  {'image': 'roti.jpg', 'title': 'Roti', 'price': 'Rp. 40.000'},
  {'image': 'mie.jpg', 'title': 'Indomie', 'price': 'Rp. 45.000'},
  {'image': 'gas.jpg', 'title': 'Gas', 'price': 'Rp. 135.000'},
];
