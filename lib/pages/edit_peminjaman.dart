import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EditPeminjaman extends StatefulWidget {
  final Map ListData;
  EditPeminjaman({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditPeminjaman> createState() => _EditPeminjamanState();
}

class _EditPeminjamanState extends State<EditPeminjaman> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController tanggalPinjam = TextEditingController();
  TextEditingController tanggalKembali = TextEditingController();

  List<Map<String, dynamic>> anggotaList = [];
  List<Map<String, dynamic>> bukuList = [];
  String? selectedAnggota;
  String? selectedBuku;

  Future _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future _update() async {
    final response = await http.post(
      Uri.parse(
          "http://localhost/pustaka_2301081006/proses_peminjaman.php?aksi=edit"),
      body: {
        "id": id.text,
        "tanggal_pinjam": tanggalPinjam.text,
        "tanggal_kembali": tanggalKembali.text,
        "id_anggota": selectedAnggota,
        "id_buku": selectedBuku,
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future _fetchData() async {
    try {
      // Fetch anggota
      final anggotaResponse = await http.get(Uri.parse(
          "http://localhost/pustaka_2301081006/read.php?table=anggota"));
      if (anggotaResponse.statusCode == 200) {
        setState(() {
          anggotaList = List<Map<String, dynamic>>.from(
              json.decode(anggotaResponse.body));
          //print("Anggota List: $anggotaList"); // Debug log
        });
      } else {
        print(
            "Failed to fetch anggota. Status code: ${anggotaResponse.statusCode}");
      }

      // Fetch buku
      final bukuResponse = await http.get(
          Uri.parse("http://localhost/pustaka_2301081006/read.php?table=buku"));
      if (bukuResponse.statusCode == 200) {
        setState(() {
          bukuList =
              List<Map<String, dynamic>>.from(json.decode(bukuResponse.body));
          //print("Buku List: $bukuList"); // Debug log
        });
      } else {
        print("Failed to fetch buku. Status code: ${bukuResponse.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    id.text = widget.ListData['id'];
    tanggalPinjam.text = widget.ListData['tanggal_pinjam'];
    tanggalKembali.text = widget.ListData['tanggal_kembali'];
    selectedAnggota = widget.ListData['id_anggota'];
    selectedBuku = widget.ListData['id_buku'];

    _fetchData().then((_) {
      setState(() {
        // Pastikan selectedAnggota dan selectedBuku cocok dengan data anggotaList dan bukuList
        if (!anggotaList.any((item) => item['id'] == selectedAnggota)) {
          selectedAnggota = null;
        }
        if (!bukuList.any((item) => item['id'] == selectedBuku)) {
          selectedBuku = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Peminjaman'),
        backgroundColor: Color(0xFFFFB74D),
      ),
      backgroundColor: Color(0xFFFFF3E0),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                onTap: () => _selectDate(context, tanggalPinjam),
                controller: tanggalPinjam,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Tanggal Pinjam",
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Tanggal Pinjam Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                onTap: () => _selectDate(context, tanggalKembali),
                controller: tanggalKembali,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Tanggal Kembali",
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Tanggal Kembali Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Pilih Anggota",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: anggotaList.isNotEmpty ? selectedAnggota : null,
                items: anggotaList.isNotEmpty
                    ? anggotaList.map((anggota) {
                        return DropdownMenuItem<String>(
                          value: anggota['id'],
                          child: Text(anggota['nama']),
                        );
                      }).toList()
                    : [],
                onChanged: (value) {
                  setState(() {
                    selectedAnggota = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Anggota Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Pilih Buku",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: bukuList.isNotEmpty ? selectedBuku : null,
                items: bukuList.isNotEmpty
                    ? bukuList.map((buku) {
                        return DropdownMenuItem<String>(
                          value: buku['id'],
                          child: Text(buku['judul']),
                        );
                      }).toList()
                    : [],
                onChanged: (value) {
                  setState(() {
                    selectedBuku = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Buku Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFB74D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 185, vertical: 16),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _update().then((value) {
                      if (value) {
                        final snackBar = SnackBar(
                          content: const Text('Data Berhasil di Update'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        final snackBar = SnackBar(
                          content: const Text('Data Gagal di Update'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                    Navigator.pop(context, true);
                  }
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
