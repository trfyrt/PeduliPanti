import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:donatur_peduli_panti/Services/pdf_summarizer_service.dart';
import 'package:donatur_peduli_panti/Services/auth_service.dart';

class PdfEvaluatorScreen extends StatefulWidget {
  const PdfEvaluatorScreen({Key? key}) : super(key: key);

  @override
  _PdfEvaluatorScreenState createState() => _PdfEvaluatorScreenState();
}

class _PdfEvaluatorScreenState extends State<PdfEvaluatorScreen> {
  String _evaluationResult = '';
  String _statusMessage = '';
  bool _isValid = false;
  int? _pantiID;
  String? _pantiName;

  @override
  void initState() {
    super.initState();
    _fetchPantiID();
  }

  Future<void> _fetchPantiID() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pantiDetailsJson = prefs.getString('pantiDetails');

      if (pantiDetailsJson != null) {
        final pantiDetails = jsonDecode(pantiDetailsJson);
        setState(() {
          _pantiID = pantiDetails['id'];
          _pantiName = pantiDetails['name'];
        });
      } else {
        await AuthService.fetchPantiDetails();
        final updatedPrefs = await SharedPreferences.getInstance();
        final updatedPantiDetailsJson = updatedPrefs.getString('pantiDetails');

        if (updatedPantiDetailsJson != null) {
          final pantiDetails = jsonDecode(updatedPantiDetailsJson);
          setState(() {
            _pantiID = pantiDetails['id'];
            _pantiName = pantiDetails['name'];
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching Panti ID: ${e.toString()}');
    }
  }

  Future<void> _evaluatePdf() async {
    if (_pantiID == null) {
      Fluttertoast.showToast(msg: 'Panti ID not available.');
      return;
    }

    final pdfService = PdfSummarizerService();

    final result = await pdfService.evaluateRab(_pantiID!);
    setState(() {
      _evaluationResult = result['evaluation'];
      _isValid = result['isValid'];
      _statusMessage = result['isValid']
          ? "Evaluation completed successfully. Document is valid and has been uploaded."
          : "Evaluation completed. Document is invalid and was not uploaded.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            // Top Blue Container
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 147, 181, 255),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      left: 15,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Audit Mate',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Message
                    if (_statusMessage.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: _isValid
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isValid
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                          ),
                        ),
                        child: Text(
                          _statusMessage,
                          style: TextStyle(
                            color: _isValid
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                          ),
                        ),
                      ),

                    // Evaluation Result
                    if (_evaluationResult.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Evaluation Result:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 107, 125, 167),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _evaluationResult,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Evaluate PDF Button
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 10,
          right: 10,
          child: ElevatedButton(
            onPressed: _pantiID != null ? _evaluatePdf : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 107, 125, 167),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _pantiID != null
                  ? 'Evaluate PDF for Panti $_pantiName'
                  : 'Loading Panti ID...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
