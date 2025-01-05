import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CekRabPage extends StatelessWidget {
  const CekRabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 166, 224, 252), // Warna AppBar biru muda
        title: const Text('AuditMate'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Aksi untuk tombol bantuan
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Kosong',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'docx'],
          );
          if (result != null) {
            String? filePath = result.files.single.path;
            // File dipilih, tangani sesuai kebutuhan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File selected: $filePath')),
            );
          } else {
            // Pengguna membatalkan pemilihan file
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File selection canceled')),
            );
          }
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.note_add),
      ),
    );
  }
}
