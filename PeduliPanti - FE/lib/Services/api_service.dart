import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peduliPanti/Models/Product.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Fungsi untuk mengambil data produk
  static Future<List<Product>> fetchProducts() async {
    final String apiUrl = '$_baseUrl/product';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fungsi untuk mengirim atau memperbarui permintaan
  static Future<void> postRequest({
    required int pantiID,
    required int productID,
    required int requestedQty,
  }) async {
    final url = Uri.parse('$_baseUrl/request_list');

    // Cek apakah request sudah ada dan dapatkan requestID
    int? existingRequestID = await getRequestID(pantiID, productID);

    final body = {
      "pantiID": pantiID,
      "productID": productID,
      "requested_qty": requestedQty,
      "donated_qty": 0,
    };

    if (existingRequestID != null) {
      // Jika sudah ada, lakukan update (gunakan PUT)
      await updateRequest(
        requestID: existingRequestID,
        pantiID: pantiID,
        productID: productID,
        requestedQty: requestedQty,
      );
    } else {
      // Jika belum ada, lakukan POST
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Request successfully sent");
      } else {
        print("POST Request failed with status: ${response.statusCode}");
        throw Exception(
            'Failed to send request. Status Code: ${response.statusCode}');
      }
    }
  }

  // Fungsi untuk mengecek apakah permintaan produk untuk panti tertentu sudah ada
  // Dan mengembalikan requestID jika ada
  static Future<int?> getRequestID(int pantiID, int productID) async {
    final url = Uri.parse('$_baseUrl/request_list');

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      // Mencari apakah sudah ada request yang sesuai
      for (var item in data) {
        if (item['pantiID'] == pantiID && item['productID'] == productID) {
          print("Existing request found with requestID: ${item['id']}");
          return item['id']; // Mengembalikan requestID jika ditemukan
        }
      }
    } else {
      print("GET request failed with status: ${response.statusCode}");
      throw Exception('Failed to load request list');
    }
    return null; // Jika request tidak ditemukan
  }

  // Fungsi untuk memperbarui permintaan yang sudah ada
  static Future<void> updateRequest({
    required int requestID,
    required int pantiID,
    required int productID,
    required int requestedQty,
  }) async {
    final updateUrl = Uri.parse(
        '$_baseUrl/request_list/$requestID'); // URL untuk update permintaan

    final body = {
      "pantiID": pantiID,
      "productID": productID,
      "requested_qty": requestedQty,
      "donated_qty": 0, // Atur sesuai kebutuhan
      "status_approval": 'pending'
    };

    final response = await http.put(
      updateUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("Request updated successfully");
    } else {
      print("PUT Request failed with status: ${response.statusCode}");
      throw Exception(
          'Failed to update request. Status Code: ${response.statusCode}');
    }
  }
}
