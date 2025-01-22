import 'package:donatur_peduli_panti/Services/auth_service.dart';
import 'package:donatur_peduli_panti/regist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'homePanti.dart';
import 'homeDonatur.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Panti',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 254, 254, 254)),
      home: const MyHomePage(title: 'Peduli Panti'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    await AuthService.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      onLoginSuccess: (String role) async {
        // Navigate based on the role
        if (role == 'panti_asuhan') {
          await AuthService.fetchPantiDetails();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else if (role == 'donatur') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeDonaturApp()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unknown role: $role')),
          );
        }
      },
      onError: (String error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $error')),
        );
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Pusatkan secara vertikal
          crossAxisAlignment:
              CrossAxisAlignment.center, // Pusatkan secara horizontal
          children: <Widget>[
            // Logo
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Pusatkan logo secara horizontal
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang untuk bayangan
                    borderRadius: BorderRadius.circular(60), // Sudut melengkung
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/img/pedulipanti.png',
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10), // Memberi jarak antar elemen
                Text(
                  'PeduliPanti',
                  style: TextStyle(
                    color: Color.fromARGB(255, 147, 181, 255),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Title and Subtitle
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 40, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Pusatkan teks
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Login',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                      textAlign: TextAlign.start, // Teks di tengah
                    ),
                  ),
                  Text(
                    'Masukkan email dan password.',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Color.fromARGB(255, 72, 78, 90),
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.start, // Teks di tengah
                  ),
                ],
              ),
            ),

            // Email Field
            _buildTextField(
              controller: emailController,
              hintText: 'Email',
              icon: FontAwesomeIcons.solidUser,
            ),

            // Password Field
            _buildTextField(
              controller: passwordController,
              hintText: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),

            // Login Button
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 10),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 171, 196, 255),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Masuk",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Belum punya akun? ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: "Daftar Disini",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RegistApp()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(15),
            child: Icon(icon, color: Colors.grey, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
