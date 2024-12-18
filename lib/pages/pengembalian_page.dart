import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pustaka/pages/form_pengembalian.dart';
import 'package:http/http.dart' as http;

class PengembalianPage extends StatefulWidget {
  PengembalianPage({Key? key}) : super(key: key);

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  List _listdataPengembalian = [];
  bool _isloading = true;

  // Fungsi untuk mengambil data pengembalian dari API
  Future<void> _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          "http://localhost/pustaka_2301081006/read.php?table=pengembalian"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdataPengembalian = data;
          print(_listdataPengembalian);
        });
      } else {
        print("Failed to fetch data: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  Future<bool> _hapus(String id) async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://localhost/pustaka_2301081006/proses_pemngembalian.php?aksi=delete"),
        body: {"id": id},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata();
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
          ? Center(child: CircularProgressIndicator())
          : _listdataPengembalian.isEmpty
              ? Center(child: Text("Data tidak tersedia"))
              : ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: _listdataPengembalian.length,
                  itemBuilder: (context, index) {
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
                          _listdataPengembalian[index]['judul_buku'] ?? "-",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Anggota: ${_listdataPengembalian[index]['nama_anggota'] ?? "-"}",
                            ),
                            Text(
                              "Tanggal Dikembalikan: ${_listdataPengembalian[index]['tanggal_dikembalikan'] ?? "-"}",
                            ),
                            Text(
                              "Terlambat: ${_listdataPengembalian[index]['terlambat'] ?? "0"} hari",
                            ),
                            Text(
                              "Denda: Rp. ${_listdataPengembalian[index]['denda'] ?? "0"}",
                            ),
                          ],
                        ),
                        trailing: FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            children: [
                              // IconButton(
                              //   onPressed: () async {
                              //     final result =
                              //         await Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (context) {
                              //           return EditPengembalian(
                              //             ListData: {
                              //               "id": _listdataPeminjaman[index]
                              //                   ['id'],
                              //               "tanggal_pinjam":
                              //                   _listdataPeminjaman[index]
                              //                       ['tanggal_pinjam'],
                              //               "tanggal_kembali":
                              //                   _listdataPeminjaman[index]
                              //                       ['tanggal_kembali'],
                              //               "id_anggota":
                              //                   _listdataPeminjaman[index]
                              //                       ['id_anggota'],
                              //               "id_buku":
                              //                   _listdataPeminjaman[index]
                              //                       ['id_buku'],
                              //             },
                              //           );
                              //         },
                              //       ),
                              //     );
                              //     if (result == true) {
                              //       await _getdata();
                              //     }
                              //   },
                              //   icon: Icon(Icons.edit),
                              // ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
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
                                            ),
                                            onPressed: () async {
                                              final isDeleted = await _hapus(
                                                _listdataPengembalian[index]
                                                    ['id'],
                                              );
                                              if (isDeleted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Data Berhasil di Hapus'),
                                                  ),
                                                );
                                                _getdata();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Data Gagal di Hapus'),
                                                  ),
                                                );
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Ya",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFFFB74D),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
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
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final isAdded = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FormPengembalian();
              },
            ),
          );
          if (isAdded == true) {
            await _getdata(); // Refresh data setelah tambah pengembalian
          }
        },
        backgroundColor: Color(0xFFFFB74D),
        label: Text(
          "Kembalikan\nBuku",
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(Icons.add),
      ),
    );
  }
}
