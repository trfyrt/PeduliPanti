import 'package:donatur_peduli_panti/Models/Panti.dart';
import 'package:donatur_peduli_panti/detailPanti_donatur.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:convert';

class HistoriRAB extends StatelessWidget {
  const HistoriRAB({Key? key, required this.pantiDetail}) : super(key: key);

  final Panti? pantiDetail;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peduli Panti',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      home: HistoriRABPage(pantiDetail: pantiDetail),
    );
  }
}

class HistoriRABPage extends StatefulWidget {
  const HistoriRABPage({super.key, required this.pantiDetail});

  final Panti? pantiDetail;

  @override
  State<HistoriRABPage> createState() => _HistoriRABPageState();
}

class _HistoriRABPageState extends State<HistoriRABPage> {
  Future<void> requestPermission() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      // Jika izin tidak diberikan, tampilkan pesan atau proses lain
      print('Permission denied');
    }
  }

  Future<void> downloadFileFromBase64(
      String base64String, String fileName) async {
    try {
      // Mendapatkan direktori penyimpanan eksternal perangkat
      final directory = await getExternalStorageDirectory();
      String filePath = '${directory?.path}/$fileName';

      // Mendekode string Base64 menjadi data byte
      List<int> bytes = base64Decode(base64String);

      // Menyimpan data byte ke dalam file
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      print('File downloaded to: $filePath');
    } catch (e) {
      print('Error saving file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 181, 255),
        toolbarHeight: 65,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(21),
            bottomRight: Radius.circular(21),
          ),
        ),
        title: Stack(
          children: [
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DetailPantiApp(pantiId: widget.pantiDetail?.id ?? 0),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    FontAwesomeIcons.angleLeft,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'Laporan Keuangan',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Menampilkan daftar RAB yang dimiliki Panti
            widget.pantiDetail?.rabs.isEmpty ?? true
                ? Center(child: Text('Tidak ada laporan RAB.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.pantiDetail?.rabs.length ?? 0,
                    itemBuilder: (context, index) {
                      final rab = widget.pantiDetail?.rabs[index];
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: const Color.fromARGB(255, 254, 254, 254),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal: ${rab?.date ?? 'Tidak ada tanggal'}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Status: ${rab?.status ?? 'Tidak ada status'}',
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                width: double.infinity,
                                height: 1,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 211, 211, 211)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 129, 156, 214),
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Panggil fungsi untuk mendownload file Base64
                                      String base64String = rab?.pdf ??
                                          ''; // Pastikan Anda punya string Base64
                                      String fileName =
                                          'Laporan_RAB_${rab?.id}.pdf'; // Nama file
                                      downloadFileFromBase64(
                                          base64String, fileName);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.fileArrowDown,
                                          color: Color.fromARGB(
                                              255, 129, 156, 214),
                                        ),
                                        Text(
                                          " Download File",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 129, 156, 214),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
