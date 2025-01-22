import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf_gemini/pdf_gemini.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';

// void main() async {
//   runApp(MyApp());
// }

class PdfSummarizerService {
  final String geminiApiKey = 'AIzaSyBXFEkG5KtdfqEloxrXQu0SD56e4E33F58'; // Replace with your API key
  final GenaiClient _genaiService;

  PdfSummarizerService()
      : _genaiService = GenaiClient(geminiApiKey: 'AIzaSyBXFEkG5KtdfqEloxrXQu0SD56e4E33F58');

  String _generateUniqueFileName() {
    final dateTime = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return 'pdf_${formatter.format(dateTime)}.pdf';
  }

  Future<void> _uploadEvaluationToApi(
      String fileName, Uint8List pdfBytes, int pantiID) async {
    try {
      final uri = Uri.parse('http://127.0.0.1:8000/api/v1/rab');
      final request = http.MultipartRequest('POST', uri)
        ..fields['pantiID'] = pantiID.toString()
        ..fields['status'] = 'pending' // Always set to pending for valid documents
        ..files.add(
          http.MultipartFile.fromBytes(
            'pdf',
            pdfBytes,
            filename: fileName,
            contentType: MediaType('application', 'pdf'),
          ),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        print("RAB evaluation successfully uploaded via API.");
      } else {
        print("Failed to upload RAB evaluation: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading RAB evaluation: $e");
    }
  }

  Future<Map<String, dynamic>> evaluateRab(int pantiID) async {
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
          Gunakan error tolerance yang sangat tinggi untuk mengatur valid true atau false.
          Buatlah seperti contoh berikut ini:
          {
          "evaluasi": "Setelah melakukan analisis terhadap RAB Panti Asuhan ini...",
          "valid": true
          }
        ''';

        final response = await _genaiService.promptDocument(
          uniqueFileName,
          'pdf',
          bytes,
          prompt,
        );

        try {
          // Cleanup response text to ensure valid JSON
          final cleanedResponse = response.text
              .trim()
              .replaceAll(RegExp(r"```json|```"), '') // Remove markdown formatting
              .replaceAll(RegExp(r'`+'), ''); // Remove stray backticks

          final parsedResponse = json.decode(cleanedResponse);

          // Only upload if the document is valid
          if (parsedResponse['valid'] == true) {
            await _uploadEvaluationToApi(uniqueFileName, bytes, pantiID);
          }

          return {
            'evaluation': parsedResponse['evaluasi'],
            'isValid': parsedResponse['valid'],
          };
        } catch (jsonError) {
          print("JSON parsing error: $jsonError");
          print("Cleaned response: $response.text");
          return {
            'evaluation': 'Error parsing evaluation response. Raw response: ${response.text}',
            'isValid': false,
          };
        }
      }
    } catch (e) {
      print("General error: $e");
      return {
        'evaluation': 'An error occurred: $e',
        'isValid': false,
      };
    }
    return {
      'evaluation': 'No file selected',
      'isValid': false,
    };
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PDF Evaluator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PdfEvaluatorScreen(),
//     );
//   }
// }

// class PdfEvaluatorScreen extends StatefulWidget {
//   @override
//   _PdfEvaluatorScreenState createState() => _PdfEvaluatorScreenState();
// }

// class _PdfEvaluatorScreenState extends State<PdfEvaluatorScreen> {
//   final _controller = TextEditingController();
//   String _evaluationResult = '';
//   String _statusMessage = '';
//   bool _isValid = false;

//   Future<void> _evaluatePdf(int pantiID) async {
//     final pdfService = PdfSummarizerService();

//     final result = await pdfService.evaluateRab(pantiID);
//     setState(() {
//       _evaluationResult = result['evaluation'];
//       _isValid = result['isValid'];
//       _statusMessage = result['isValid']
//           ? "Evaluation completed successfully. Document is valid and has been uploaded."
//           : "Evaluation completed. Document is invalid and was not uploaded.";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Evaluator'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: 'Enter Panti ID',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final pantiID = int.tryParse(_controller.text);
//                 if (pantiID != null) {
//                   _evaluatePdf(pantiID);
//                 } else {
//                   Fluttertoast.showToast(msg: 'Please enter a valid Panti ID.');
//                 }
//               },
//               child: Text('Evaluate PDF'),
//             ),
//             SizedBox(height: 20),
//             if (_statusMessage.isNotEmpty) ...[
//               Text(
//                 _statusMessage,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: _isValid ? Colors.green : Colors.red,
//                 ),
//               ),
//               SizedBox(height: 10),
//             ],
//             if (_evaluationResult.isNotEmpty) ...[
//               Text(
//                 'Evaluation Result:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(_evaluationResult),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
