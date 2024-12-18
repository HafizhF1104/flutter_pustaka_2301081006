import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class FormPengembalian extends StatefulWidget {
  FormPengembalian({Key? key}) : super(key: key);

  @override
  State<FormPengembalian> createState() => _FormPengembalianState();
}

class _FormPengembalianState extends State<FormPengembalian> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tanggalDikembalikan = TextEditingController();
  TextEditingController terlambat = TextEditingController();
  TextEditingController denda = TextEditingController();

  List<Map<String, dynamic>> PeminjamanList = [];
  String? selectedBuku;
  String? tanggalPinjam;

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
      _kalkulasi();
    }
  }

  void _kalkulasi() {
    if (tanggalPinjam != null && tanggalDikembalikan.text.isNotEmpty) {
      DateTime tanggalPinjamDate = DateTime.parse(tanggalPinjam!);
      DateTime tanggalKembaliDate = DateTime.parse(tanggalDikembalikan.text);

      int difference = tanggalKembaliDate.difference(tanggalPinjamDate).inDays;

      // Jika terlambat, hitung denda
      if (difference > 0) {
        setState(() {
          terlambat.text = difference.toString();
          denda.text = (difference * 5000).toString();
        });
      } else {
        // Tidak ada keterlambatan
        setState(() {
          terlambat.text = "0";
          denda.text = "0";
        });
      }
    }
  }

  Future _simpan() async {
    final response = await http.post(
      Uri.parse(
          "http://localhost/pustaka_2301081006/proses_pengembalian.php?aksi=insert"),
      body: {
        "tanggal_dikembalikan": tanggalDikembalikan.text,
        "terlambat": terlambat.text,
        "denda": denda.text,
        "id_peminjaman": selectedBuku,
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
      final peminjamanResponse = await http.get(Uri.parse(
          "http://localhost/pustaka_2301081006/read.php?table=peminjaman"));
      if (peminjamanResponse.statusCode == 200) {
        setState(() {
          PeminjamanList = List<Map<String, dynamic>>.from(
              json.decode(peminjamanResponse.body));
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pengembalian'),
        backgroundColor: Color(0xFFFFB74D),
      ),
      backgroundColor: Color(0xFFFFF3E0),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Pilih Buku Yang Dikembalikan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: selectedBuku,
                items: PeminjamanList.map((buku) {
                  return DropdownMenuItem<String>(
                    value: buku['id'],
                    child: Text(buku['judul_buku']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBuku = value;
                    tanggalPinjam = PeminjamanList.firstWhere(
                        (buku) => buku['id'] == value)['tanggal_pinjam'];
                    _kalkulasi();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Buku Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                onTap: () => _selectDate(context, tanggalDikembalikan),
                controller: tanggalDikembalikan,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Tanggal Dikembalikan",
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Tanggal Dikembalikan Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: terlambat,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Terlambat (Hari)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: denda,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Denda (Rp)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
                    _simpan().then((value) {
                      if (value) {
                        final snackBar = SnackBar(
                          content: const Text('Buku Berhasil Ditambahkan'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        final snackBar = SnackBar(
                          content: const Text('Gagal Menambahkan Buku'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                    Navigator.pop(context, true);
                  }
                },
                child: Text(
                  "Simpan",
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
