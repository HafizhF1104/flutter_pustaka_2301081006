import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'form_anggota.dart';

class AnggotaPage extends StatefulWidget {
  @override
  State<AnggotaPage> createState() => _AnggotaPageState();
}

class _AnggotaPageState extends State<AnggotaPage> {
  List _listdata = [];

  Future _getdata() async {
    try {
      final response = await http.get(
          Uri.parse("http://10.126.161.37/pustaka_2301081006/koneksi.php"));
      if (response.statusCode == 200) {
        // print(response.body);
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    //print(_listdata);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anggota'),
        backgroundColor: Color(0xFFFFB74D),
      ),
      backgroundColor: Color(0xFFFFF3E0),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       Container(
      //         margin: EdgeInsets.only(top: 30),
      //         width: 400,
      //         height: 650,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(3),
      //           boxShadow: [
      //             BoxShadow(
      //                 color: Colors.grey.withOpacity(0.5),
      //                 spreadRadius: 1,
      //                 blurRadius: 1,
      //                 offset: Offset(0, 0))
      //           ],
      //         ),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Container(
      //               margin: EdgeInsets.only(top: 20),
      //               child: Text(
      //                 'Data Anggota',
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 20,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ),
      //             // Container(
      //             //   margin: EdgeInsets.only(top: 10),
      //             //   child: ListView.builder(
      //             //     itemCount: 10,
      //             //     itemBuilder: ((context, index) {
      //             //       return Card(
      //             //         child: ListTile(
      //             //           title: Text("data"),
      //             //         ),
      //             //       );
      //             //     }),
      //             //   ),
      //             // ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: ListView.builder(
          itemCount: _listdata.length,
          itemBuilder: ((context, index) {
            return Card(
              child: ListTile(
                title: Text("data"),
              ),
            );
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return FormAnggota();
          }));
        },
        backgroundColor: Color(0xFFFFB74D),
        child: Icon(Icons.add),
      ),
    );
  }
}
