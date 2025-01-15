import 'dart:typed_data';
import 'package:pdf_gemini/pdf_gemini.dart';
import 'package:intl/intl.dart'; // For generating a unique file name
import 'package:file_picker/file_picker.dart';

class PdfSummarizerService {
  final String geminiApiKey;
  final GenaiClient _genaiService;

  PdfSummarizerService(this.geminiApiKey)
      : _genaiService = GenaiClient(geminiApiKey: geminiApiKey);

  // Function to generate a unique file name
  String _generateUniqueFileName() {
    final dateTime = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return 'pdf_${formatter.format(dateTime)}.pdf';
  }

  // Function to pick and summarize the PDF
  Future<String?> summarizePdf() async {
    try {
      // Pick a PDF file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.first.bytes != null) {
        final bytes = result.files.first.bytes!; // Access file content as bytes

        // Generate a unique file name
        final uniqueFileName = _generateUniqueFileName();

        // Provide your custom prompt for summarization
        const prompt = 'Summarize this PDF in JSON format.';

        // Call Gemini API to summarize
        final response = await _genaiService.promptDocument(
          uniqueFileName,  // Unique file name for the current PDF
          'pdf',           // File type
          bytes,           // File contents as bytes
          prompt,          // Your summarization prompt
        );

        return response.text; // Return the summary
      }
    } catch (e) {
      return 'An error occurred: $e'; // Handle errors gracefully
    }
    return null;
  }
}
