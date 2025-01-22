import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donatur_peduli_panti/Models/Payment.dart';

class PaymentService {
  static const String baseUrl = 'YOUR_API_BASE_URL';
  
  // Menambahkan method untuk mendapatkan token
  Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }
    return token;
  }

  Future<List<PaymentMethod>> getUserPaymentMethods(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/user/$userId/payment-methods'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PaymentMethod.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment methods');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> createPayment({
    required String name,
    required int qty,
    required int price,
    required int grandTotal,
    required String paymentType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/payment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await getAuthToken()}',
        },
        body: jsonEncode({
          'name': name,
          'qty': qty,
          'price': price,
          'grand_total': grandTotal,
          'payment_type': paymentType,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}