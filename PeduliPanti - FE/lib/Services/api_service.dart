import 'dart:convert';
import 'package:donatur_peduli_panti/Models/Bundle.dart';
import 'package:http/http.dart' as http;
import 'package:donatur_peduli_panti/Models/Product.dart';
import 'package:donatur_peduli_panti/Models/Panti.dart';
import 'package:donatur_peduli_panti/Services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Fungsi untuk mengambil data Panti Asuhan
  static Future<List<Panti>> fetchPantiDetails() async {
    final String apiUrl = '$_baseUrl/panti_detail';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((json) => Panti.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load panti details');
      }
    } catch (e) {
      throw Exception('Error fetching panti details: $e');
    }
  }

  // Fungsi untuk mengambil detail panti berdasarkan ID
  static Future<Panti> fetchPantiById(int pantiId) async {
    final String apiUrl = '$_baseUrl/panti_detail/$pantiId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Panti.fromJson(
            data); // Mengembalikan objek Panti berdasarkan data JSON
      } else {
        throw Exception('Failed to load panti details');
      }
    } catch (e) {
      throw Exception('Error fetching panti details: $e');
    }
  }

  // // Fungsi untuk mengambil data RAB berdasarkan pantiID dan status "approved" secara lokal
  // static Future<List<RAB>> fetchRABByPantiId(int pantiId) async {
  //   final String apiUrl =
  //       '$_baseUrl/rab'; // Ambil semua data RAB dari endpoint yang ada

  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body)['data'] as List;

  //       // Filter data secara lokal berdasarkan pantiID dan status "approved"
  //       final filteredData = data
  //           .where((json) =>
  //               json['pantiID'] == pantiId && json['status'] == 'approved')
  //           .map((json) => RAB.fromJson(json))
  //           .toList();

  //       return filteredData;
  //     } else {
  //       throw Exception('Failed to load RAB');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching RAB by pantiID: $e');
  //   }
  // }

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

  // Fetch Bundles
  static Future<List<Bundle>> fetchBundles() async {
    final String apiUrl = '$_baseUrl/bundle';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['data'] == null ||
          (jsonResponse['data'] as List).isEmpty) {
        print('No bundles found'); // Jika data kosong
        return [];
      }

      try {
        final data = jsonResponse['data'] as List;
        return data.map((json) => Bundle.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing bundle: $e');
        throw Exception('Failed to parse bundles');
      }
    } else {
      throw Exception('Failed to load bundles');
    }
  }

  // Fungsi untuk menyimpan atau memperbarui keranjang
  static Future<http.Response> storeOrUpdateCart(
      Map<String, dynamic> cartData) async {
    final String apiUrl = '$_baseUrl/cart'; // Endpoint API

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer your-auth-token', // Ganti dengan token autentikasi Anda
        },
        body: jsonEncode(cartData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Failed to update cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while updating cart: $e');
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

  // Edit User
  static Future<void> updateUserWithMultipart({
    required Map<String, String> fields, // Data key-value pairs
    Map<String, http.MultipartFile>? files, // Optional files
    required Function() onSuccess, // Callback on success
    required Function(String error) onError, // Callback on error
  }) async {
    try {
      // Retrieve token and user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = await AuthService.getToken();
      final userJson = prefs.getString('user');
      if (token == null || userJson == null) {
        onError("Session expired. Please log in again.");
        return;
      }

      final user = jsonDecode(userJson);
      final userID = user['id']; // Assuming 'id' is the key for user ID

      // Construct the API URL
      final url = Uri.parse('$_baseUrl/user/$userID');

      // Create the multipart request
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          "Authorization": "Bearer $token",
        })
        ..fields.addAll(fields)
        ..fields['_method'] = 'PUT'; // Add _method=PUT

      // Attach files if provided
      if (files != null) {
        request.files.addAll(files.values);
      }

      // Send the request
      final response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        // Parse response if needed
        final responseBody = await response.stream.bytesToString();
        final updatedUser = jsonDecode(responseBody)['data'];
        await prefs.setString(
            'user', jsonEncode(updatedUser)); // Update local user data

        print("User profile updated successfully.");
        onSuccess();
      } else {
        final responseBody = await response.stream.bytesToString();
        final errorMessage =
            jsonDecode(responseBody)['message'] ?? "Failed to update profile.";
        onError(errorMessage);
      }
    } catch (e) {
      print("An error occurred while updating user profile: ${e.toString()}");
      onError("An unexpected error occurred. Please try again.");
    }
  }
}
