import 'package:flutter/material.dart';
import 'package:flutter_pustaka/pages/home_page.dart';
import 'package:flutter_pustaka/screens/tampilan_awal.dart';

void main() {
  runApp(AppPustaka());
}

class AppPustaka extends StatelessWidget {
  const AppPustaka({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pustaka',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
