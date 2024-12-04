import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pustaka/pages/edit_peminjaman.dart';
import 'package:flutter_pustaka/pages/form_peminjaman.dart';
import 'package:http/http.dart' as http;

class PengembalianPage extends StatefulWidget {
  PengembalianPage({Key? key}) : super(key: key);

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          "http://localhost/pustaka_2301081006/read.php?table=pengembalian"));
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
              "http://localhost/pustaka_2301081006/proses_pemngembalian.php?aksi=delete"),
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
        title: Text('Pengembalian'),
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
                        _listdata[index]['judul_buku'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                                "Nama Anggota : ${_listdata[index]['nama_anggota']}"),
                          ),
                          Container(
                            child: Text(
                                "Tanggal Dikembalikan : ${_listdata[index]['tanggal_dikembalikan']}"),
                          ),
                          Container(
                            child: Text(
                                "Terlambat : ${_listdata[index]['terlambat']}"),
                          ),
                          Container(
                            child: Text("Denda : ${_listdata[index]['denda']}"),
                          ),
                        ],
                      ),
                      trailing: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                print(_listdata[index]['id_anggota']);
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditPeminjaman(
                                        ListData: {
                                          "id": _listdata[index]['id'],
                                          "tanggal_pinjam": _listdata[index]
                                              ['tanggal_pinjam'],
                                          "tanggal_kembali": _listdata[index]
                                              ['tanggal_kembali'],
                                          "id_anggota": _listdata[index]
                                              ['id_anggota'],
                                          "id_buku": _listdata[index]
                                              ['id_buku'],
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
                return FormPeminjaman();
              },
            ),
          );
          if (isAdded == true) {
            await _getdata();
          }
        },
        backgroundColor: Color(0xFFFFB74D),
        label: Text(
          "Kembalikan\nBuku",
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
