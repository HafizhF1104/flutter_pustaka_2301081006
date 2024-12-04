import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pustaka/pages/edit_buku.dart';
import 'package:http/http.dart' as http;

import 'form_buku.dart';

class BukuPage extends StatefulWidget {
  BukuPage({Key? key}) : super(key: key);

  @override
  State<BukuPage> createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final response = await http.get(
          Uri.parse("http://localhost/pustaka_2301081006/read.php?table=buku"));
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
              "http://localhost/pustaka_2301081006/proses_buku.php?aksi=delete"),
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

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buku'),
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
                        Icons.book,
                        size: 50,
                      ),
                      title: Text(
                        _listdata[index]['judul'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                                "Kode Buku : ${_listdata[index]['kode_buku']}"),
                          ),
                          Container(
                            child: Text(
                                "Pengarang : ${_listdata[index]['pengarang']}"),
                          ),
                          Container(
                            child: Text(
                                "Penerbit : ${_listdata[index]['penerbit']}"),
                          ),
                          Container(
                            child: Text(
                                "Tahun Terbit : ${_listdata[index]['tahun_terbit']}"),
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
                                      return EditBuku(
                                        ListData: {
                                          "id": _listdata[index]['id'],
                                          "kode_buku": _listdata[index]
                                              ['kode_buku'],
                                          "judul": _listdata[index]['judul'],
                                          "pengarang": _listdata[index]
                                              ['pengarang'],
                                          "penerbit": _listdata[index]
                                              ['penerbit'],
                                          "tahun_terbit": _listdata[index]
                                              ['tahun_terbit'],
                                        },
                                      );
                                    },
                                  ),
                                );
                                if (result == true) {
                                  await _getdata();
                                }
                              },
                              icon: Icon(Icons.edit),
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
                                                backgroundColor: Color(
                                                    0xFFFFB74D), // Warna latar tombol
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 60,
                                                    vertical: 16),
                                              ),
                                              onPressed: () async {
                                                final isDeleted = await _hapus(
                                                    _listdata[index]['id']);

                                                if (isDeleted) {
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        'Data Berhasil di Hapus'),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);

                                                  _getdata();
                                                } else {
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        'Data Gagal di Hapus'),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }

                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Ya",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(
                                                  0xFFFFB74D), // Warna latar tombol
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
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      )),
                  // ),
                );
              })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final isAdded = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FormBuku();
              },
            ),
          );
          if (isAdded == true) {
            await _getdata();
          }
        },
        backgroundColor: Color(0xFFFFB74D),
        label: Text(
          "Tambah\nBuku",
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
