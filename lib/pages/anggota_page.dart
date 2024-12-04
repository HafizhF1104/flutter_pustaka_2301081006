import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pustaka/pages/edit_anggota.dart';
import 'package:http/http.dart' as http;

import 'form_anggota.dart';

class AnggotaPage extends StatefulWidget {
  AnggotaPage({Key? key}) : super(key: key);

  @override
  State<AnggotaPage> createState() => _AnggotaPageState();
}

class _AnggotaPageState extends State<AnggotaPage> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          "http://localhost/pustaka_2301081006/read.php?table=anggota"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _hapus(String id) async {
    try {
      final response = await http.post(
          Uri.parse(
              "http://localhost/pustaka_2301081006/proses_anggota.php?aksi=delete"),
          body: {
            "id": id,
          });
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 25,
                height: 50,
              ),
              Text("Memuat data...."),
            ],
          ),
        );
      },
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    _getdata();

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
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: Icon(
                      Icons.person,
                      size: 50,
                    ),
                    title: Text(
                      _listdata[index]['nama'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("NIM : ${_listdata[index]['nim']}"),
                        ),
                        Container(
                          child: Text(
                              "Jenis Kelamin : ${_listdata[index]['jenis_kelamin']}"),
                        ),
                        Container(
                          child: Text("Alamat : ${_listdata[index]['alamat']}"),
                        ),
                      ],
                    ),
                    trailing: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EditAnggota(
                                      ListData: {
                                        "id": _listdata[index]['id'],
                                        "nim": _listdata[index]['nim'],
                                        "nama": _listdata[index]['nama'],
                                        "jenis_kelamin": _listdata[index]
                                            ['jenis_kelamin'],
                                        "alamat": _listdata[index]['alamat'],
                                      },
                                    );
                                  },
                                ),
                              );
                              if (result == true) {
                                _showLoadingDialog(context);
                                await Future.delayed(Duration(seconds: 1));
                                await _getdata();
                                _hideLoadingDialog(context);
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.orange),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      content: Text(
                                        "Yakin Anda Menghapus Data?",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFFFB74D),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 60, vertical: 16),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              _showLoadingDialog(context);
                                              final isDeleted = await _hapus(
                                                  _listdata[index]['id']);

                                              if (isDeleted) {
                                                final snackBar = SnackBar(
                                                  content: const Text(
                                                      'Data Berhasil di Hapus'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                final snackBar = SnackBar(
                                                  content: const Text(
                                                      'Data Gagal di Hapus'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }

                                              await _getdata();
                                              _hideLoadingDialog(context);
                                            },
                                            child: Text(
                                              "Ya",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            )),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFFFB74D),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 60, vertical: 16),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Batal",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }));
                            },
                            icon: Icon(
                              Icons.delete,
                              color: const Color.fromARGB(255, 229, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ),
                );
              })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final isAdded = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FormAnggota();
              },
            ),
          );
          if (isAdded == true) {
            _showLoadingDialog(context);
            await Future.delayed(Duration(seconds: 1));
            await _getdata();
            _hideLoadingDialog(context);
          }
        },
        backgroundColor: Color(0xFFFFB74D),
        label: Text(
          "Tambah\nAnggota",
          style: TextStyle(
            color: Colors.black, // Warna teks
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(Icons.add),
      ),
    );
  }
}
