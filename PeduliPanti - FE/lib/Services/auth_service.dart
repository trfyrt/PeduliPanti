import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Login Function
  static Future<void> login({
    required String email,
    required String password,
    required Function(String role)
        onLoginSuccess, // Callback for role-based navigation
    required Function(String error) onError, // Callback for handling errors
  }) async {
    final url = Uri.parse('$_baseUrl/login');
    final body = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];
        final role = user['role'];

        // Store the token securely
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString(
            'user', jsonEncode(user)); // Store user info for reuse

        print("Login successful. Token stored: $token");

        // Trigger role-based navigation
        onLoginSuccess(role);
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? "Unknown error occurred";
        print("Login failed: $errorMessage");
        onError(errorMessage);
      }
    } catch (e) {
      print("An error occurred during login: ${e.toString()}");
      onError("An unexpected error occurred. Please try again.");
    }
  }

  // Logout Function
  static Future<void> logout({
    required Function() onLogoutSuccess, // Callback after successful logout
    required Function(String error) onError, // Callback for error handling
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token =
        prefs.getString('token'); // Retrieve the token from local storage

    if (token == null) {
      print("No token found. Logging out locally.");
      await _clearSession();
      onLogoutSuccess();
      return;
    }

    final url = Uri.parse('$_baseUrl/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Attach the token to the request
        },
      );

      if (response.statusCode == 200) {
        print("Logout successful on the server");
      } else {
        print("Server logout failed: ${response.statusCode}, ${response.body}");
      }

      // Clear the local session regardless of server response
      await _clearSession();
      onLogoutSuccess();
    } catch (e) {
      print("An error occurred during logout: ${e.toString()}");
      onError("Failed to log out. Please try again.");
    }
  }

  // Clear local session data
  static Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    print("Local session cleared");
  }

  // Register a new user
  static Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
    final body = {
      "name": name,
      "email": email,
      "password": password,
      "role": "donatur", // Default role for registration
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print("Account successfully created");
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? "Unknown error occurred";
        print("Failed to register: $errorMessage");
      }
    } catch (e) {
      print("An error occurred during registration: ${e.toString()}");
    }
  }

  // Function to get the stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Function to get the stored user
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  // Function to fetch panti details using the userID
  static Future<void> fetchPantiDetails() async {
    try {
      // Retrieve user details from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');

      if (userJson != null) {
        final user = jsonDecode(userJson);
        final userID = user['userID']; // Extract userID from stored user data

        // Construct the API URL
        final url = Uri.parse('$_baseUrl/user/$userID');

        final response = await http
            .get(url, headers: {"Authorization": "Bearer ${await getToken()}"});

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final pantiDetails = data['data']['pantiDetails'];

          // Store pantiDetails in SharedPreferences
          await prefs.setString('pantiDetails', jsonEncode(pantiDetails));

          print("Panti details fetched and stored.");
        } else {
          print("Failed to fetch panti details: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("Error fetching panti details: ${e.toString()}");
    }
  }

  // Function to retrieve stored panti details
  static Future<Map<String, dynamic>?> getPantiDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final pantiDetailsJson = prefs.getString('pantiDetails');
    if (pantiDetailsJson != null) {
      return jsonDecode(pantiDetailsJson);
    }
    return null;
  }
}
