import 'package:flutter/material.dart';
import 'login.dart'; // Import LoginPage

void main() {
  runApp(const MaterialApp(
    home: OnboardingScreen(),
    debugShowCheckedModeBanner: false, // Menghilangkan banner debug
  ));
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0), // Jarak atas
            // Header Logo dan Teks
            Row(
              children: [
                Image.asset(
                  'pedulipanti.png', // Path gambar logo
                  width: 120, // Ukuran lebih kecil
                  height: 120,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Selamat datang di',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'PeduliPanti',
                        style: TextStyle(
                          fontSize: 28.0, // Ukuran teks lebih besar
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Berikan keadilan dengan membantu anak-anak panti asuhan dan menyalurkan barang.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0), // Jarak ke gambar utama

            // Gambar Utama
            Expanded(
              child: Align(
                alignment: Alignment.center, // Memastikan gambar berada di tengah
                child: Image.asset(
                  'onboard1.png', // Path gambar utama
                  width: 280, // Ukuran lebih besar
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20.0), // Jarak tombol dari gambar

            // Tombol
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardingScreen2()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blue,
                  elevation: 5, // Efek bayangan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // Sudut tombol lebih bulat
                  ),
                ),
                child: const Text(
                  'Berikutnya',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30.0), // Jarak bawah
          ],
        ),
      ),
    );
  }
}


class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0), // Jarak atas
            // Header dengan Ikon dan Teks
            Column(
              children: [
                Icon(
                  Icons.favorite, // Ikon cinta untuk estetika
                  color: Colors.red,
                  size: 40.0,
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Dengan berdonasi, Anda dapat menolong anak-anak panti asuhan.',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 60.0),

            // Gambar Utama
            Expanded(
              child: Center(
                child: Image.asset(
                  'gif.gif', // Ganti dengan path gambar Anda
                  width: 280, // Ukuran gambar lebih besar
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // Teks Deskripsi
            const Text(
              'Jembatan kebaikan yang menghubungkan Anda dengan mereka yang membutuhkan. Bersama kita wujudkan dunia yang lebih peduli dan penuh kasih.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40.0),

            // Tombol "Memulai"
            SizedBox(
              width: double.infinity, // Tombol memenuhi lebar layar
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardingScreen3()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blue,
                  elevation: 5, // Bayangan tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Selanjutnya',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30.0), // Jarak bawah
          ],
        ),
      ),
    );
  }
}


class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0), // Jarak atas

            // Header dengan Ikon dan Teks
            Column(
              children: [
                Icon(
                  Icons.star, // Ikon bintang sebagai elemen visual tambahan
                  color: Colors.yellow[700],
                  size: 40.0,
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Memprioritaskan panti asuhan yang kurang donasi.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 40.0),

            // Gambar Utama
            Expanded(
              child: Center(
                child: Image.asset(
                  'onboard2.jpg', // Ganti dengan path gambar Anda
                  width: 280, // Sedikit lebih kecil agar proporsional
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // Teks Deskripsi
            const Text(
              'Mari kita bersama-sama memberikan perhatian dan dukungan kepada panti asuhan yang terabaikan. Bersama, kita bisa menjadi cahaya di tengah kegelapan.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40.0),

            // Tombol "Memulai"
            SizedBox(
              width: double.infinity, // Tombol memenuhi lebar layar
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman login
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                          title: ''), // Mengarahkan ke halaman utama
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blue,
                  elevation: 5, // Bayangan tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Memulai',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30.0), // Jarak bawah
          ],
        ),
      ),
    );
  }
}
