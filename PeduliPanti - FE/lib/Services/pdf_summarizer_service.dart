import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:pdf_gemini/pdf_gemini.dart';

class PdfSummarizerService {
  final String geminiApiKey = 'AIzaSyBXFEkG5KtdfqEloxrXQu0SD56e4E33F58';
  final GenaiClient _genaiService;

  PdfSummarizerService()
      : _genaiService = GenaiClient(
            geminiApiKey: 'AIzaSyBXFEkG5KtdfqEloxrXQu0SD56e4E33F58');

  String _generateUniqueFileName() {
    final dateTime = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return 'pdf_${formatter.format(dateTime)}.pdf';
  }

  Future<void> _uploadEvaluationToApi(
      String fileName, Uint8List pdfBytes, int pantiID) async {
    try {
      final uri = Uri.parse('http://192.168.177.165:8000/api/v1/rab');
      final request = http.MultipartRequest('POST', uri)
        ..fields['pantiID'] = pantiID.toString()
        ..fields['status'] = 'pending'
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
        withData: true,
      );

      print('FilePicker result: $result');
      if (result != null) {
        print('File name: ${result.files.first.name}');
        print('File size: ${result.files.first.size}');
        print('File bytes available: ${result.files.first.bytes != null}');
      }

      if (result == null || result.files.first.bytes == null) {
        return {
          'evaluation': 'No file selected',
          'isValid': false,
        };
      }

      final bytes = result.files.first.bytes!;
      final uniqueFileName = _generateUniqueFileName();
      const prompt = '''
         Evaluasi RAB berikut ini dari segi integritas dan akuntabilitas. Identifikasi potensi kesalahan perhitungan, ketidaksesuaian harga satuan, atau item yang mencurigakan.
         Berikan dalam format JSON, dengan field 'evaluasi' yang berisi hasil evaluasi secara keseluruhan dalam format sebuah paragraf atau teks, dan field 'valid'.
         Jika hasil evaluasi sudah cukup sesuai maka atur field 'valid' menjadi true. Jika hasil evaluasi tidak sesuai maka atur field 'valid' menjadi false.
         Gunakan error tolerance yang sangat tinggi untuk mengatur valid true atau false.
       ''';

      final response = await _genaiService.promptDocument(
        uniqueFileName,
        'pdf',
        bytes,
        prompt,
      );

      try {
        final cleanedResponse = response.text
            .trim()
            .replaceAll(RegExp(r"```json|```"), '')
            .replaceAll(RegExp(r'`+'), '');

        final parsedResponse = json.decode(cleanedResponse);

        if (parsedResponse['valid'] == true) {
          await _uploadEvaluationToApi(uniqueFileName, bytes, pantiID);
        }

        return {
          'evaluation': parsedResponse['evaluasi'] ?? 'Tidak ada evaluasi',
          'isValid': parsedResponse['valid'] ?? false,
        };
      } catch (jsonError) {
        print("JSON parsing error: $jsonError");
        return {
          'evaluation': 'Gagal mengurai respon evaluasi',
          'isValid': false,
        };
      }
    } catch (e) {
      print("Kesalahan umum: $e");
      return {
        'evaluation': 'Terjadi kesalahan: $e',
        'isValid': false,
      };
    }
  }
}
