import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class TampilanAwal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3E0), // Warna latar belakang
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('assets/images/book.png'),
              width: 250,
              height: 250,
              margin: EdgeInsets.only(top: 110),
            ),
            SizedBox(height: 250),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFB74D), // Warna latar tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black, // Warna teks
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
