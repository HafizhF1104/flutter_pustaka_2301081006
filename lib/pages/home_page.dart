import 'package:flutter/material.dart';

import 'anggota_page.dart';
import 'buku_page.dart';
import 'peminjaman_page.dart';
import 'pengembalian_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Library'),
        backgroundColor: Color(0xFFFFB74D),
      ),
      backgroundColor: Color(0xFFFFF3E0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              width: 400,
              height: 650,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 0))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Image.asset('assets/images/profile.png'),
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 100),
                  ),
                  Text(
                    'Hafizh Fadhlurrohman',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'admin@gmail.com',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    width: 320,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AnggotaPage();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shadowColor: Colors.grey,
                        backgroundColor: Colors.white, // Warna latar tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Anggota',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1),
                    width: 320,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BukuPage();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shadowColor: Colors.grey,
                        backgroundColor: Colors.white, // Warna latar tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Buku',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1),
                    width: 320,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return PeminjamanPage();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shadowColor: Colors.grey,
                        backgroundColor: Colors.white, // Warna latar tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Peminjaman',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1),
                    width: 320,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return PengembalianPage();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shadowColor: Colors.grey,
                        backgroundColor: Colors.white, // Warna latar tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Pengembalian',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
