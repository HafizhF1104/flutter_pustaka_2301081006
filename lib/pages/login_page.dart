import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username dan password harus diisi!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://localhost/pustaka_2301081006/login.php"),
        body: {"username": username, "password": password},
      );

      print("Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (data['status'] == "success") {
        print("Navigasi ke HomePage");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        print("Login gagal: ${data['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Login Gagal!")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Color(0xFFFFB74D),
      ),
      backgroundColor: Color(0xFFFFF3E0),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Image.asset('assets/images/book.png'),
              width: 250,
              height: 250,
            ),
            SizedBox(height: 50),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 32),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFB74D),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _login,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
