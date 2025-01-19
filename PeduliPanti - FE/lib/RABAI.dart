import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:pdf_gemini/pdf_gemini.dart';
import 'package:fluttertoast/fluttertoast.dart';

// void main() async {
//   runApp(MyApp());
// }

class PdfSummarizerService {
  final String geminiApiKey = 'AIzaSyBXFEkG5KtdfqEloxrXQu0SD56e4E33F58'; // Replace with your API key
  final GenaiClient _genaiService;
  final MySqlConnection _dbConnection;

  PdfSummarizerService(this._dbConnection)
      : _genaiService = GenaiClient(geminiApiKey: 'AIzaSyBXFEkG5KtdfqEloxrXQu0SD56e4E33F58');

  String _generateUniqueFileName() {
    final dateTime = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return 'pdf_${formatter.format(dateTime)}.pdf';
  }

  Future<void> _storeEvaluationInDatabase(String fileName, Uint8List pdfBytes, int pantiID, String status) async {
    try {
      final date = DateTime.now().toIso8601String().split('T').first;
      await _dbConnection.query(
        '''
        INSERT INTO rab (pantiID, status, date, pdf)
        VALUES (?, ?, ?, ?)
        ''',
        [pantiID, status, date, pdfBytes],
      );
      print("RAB evaluation successfully stored in the database.");
    } catch (e) {
      print("Failed to store RAB evaluation: $e");
    }
  }

  Future<String?> evaluateRab(int pantiID) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.first.bytes != null) {
        final bytes = result.files.first.bytes!;
        final uniqueFileName = _generateUniqueFileName();
        const prompt = '''
          Evaluasi RAB berikut ini dari segi integritas dan akuntabilitas. Identifikasi potensi kesalahan perhitungan, ketidaksesuaian harga satuan, atau item yang mencurigakan.
          Berikan dalam format JSON, dengan field 'evaluasi' yang berisi hasil evaluasi secara keseluruhan dalam format sebuah paragraf atau teks, dan field 'valid'.
          Jika hasil evaluasi sudah cukup sesuai maka atur field 'valid' menjadi true. Jika hasil evaluasi tidak sesuai maka atur field 'valid' menjadi false.
        ''';

        final response = await _genaiService.promptDocument(
          uniqueFileName,
          'pdf',
          bytes,
          prompt,
        );

        final parsedResponse = json.decode(response.text);
        if (parsedResponse['valid'] == true) {
          await _storeEvaluationInDatabase(uniqueFileName, bytes, pantiID, 'approved');
          return parsedResponse['evaluasi'];
        } else {
          await _storeEvaluationInDatabase(uniqueFileName, bytes, pantiID, 'rejected');
          return "The RAB evaluation was not valid due to exceeding error tolerance.";
        }
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
    return null;
  }
}

Future<MySqlConnection> createDatabaseConnection() async {
  final conn = await MySqlConnection.connect(
    ConnectionSettings(
      host: '127.0.0.1', // Replace with your MySQL host
      port: 3306, // Default MySQL port
      user: 'root', // Replace with your MySQL username
      password: '', // Replace with your MySQL password
      db: 'testgeminipdf', // Replace with your database name
    ),
  );
  return conn;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Evaluator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PdfEvaluatorScreen(),
    );
  }
}

class PdfEvaluatorScreen extends StatefulWidget {
  @override
  _PdfEvaluatorScreenState createState() => _PdfEvaluatorScreenState();
}

class _PdfEvaluatorScreenState extends State<PdfEvaluatorScreen> {
  final _controller = TextEditingController();
  String _evaluationResult = '';
  String _statusMessage = '';

  Future<void> _evaluatePdf(int pantiID) async {
    final dbConnection = await createDatabaseConnection(); // This will now work
    final pdfService = PdfSummarizerService(dbConnection);

    final evaluation = await pdfService.evaluateRab(pantiID);
    if (evaluation != null) {
      setState(() {
        _evaluationResult = evaluation;
        _statusMessage = "Evaluation completed successfully.";
      });
    } else {
      setState(() {
        _evaluationResult = "No evaluation result found.";
        _statusMessage = "Evaluation failed.";
      });
    }

    await dbConnection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Evaluator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Panti ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final pantiID = int.tryParse(_controller.text);
                if (pantiID != null) {
                  _evaluatePdf(pantiID);
                } else {
                  Fluttertoast.showToast(msg: 'Please enter a valid Panti ID.');
                }
              },
              child: Text('Evaluate PDF'),
            ),
            SizedBox(height: 20),
            if (_statusMessage.isNotEmpty) ...[
              Text(
                _statusMessage,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
            ],
            if (_evaluationResult.isNotEmpty) ...[
              Text(
                'Evaluation Result:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(_evaluationResult),
            ],
          ],
        ),
      ),
    );
  }
}
