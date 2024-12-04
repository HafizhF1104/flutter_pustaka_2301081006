import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class FormBuku extends StatefulWidget {
  FormBuku({Key? key}) : super(key: key);

  @override
  State<FormBuku> createState() => _FormBukuState();
}

class _FormBukuState extends State<FormBuku> {
  final formKey = GlobalKey<FormState>();
  TextEditingController kodeBuku = TextEditingController();
  TextEditingController judul = TextEditingController();
  TextEditingController pengarang = TextEditingController();
  TextEditingController penerbit = TextEditingController();
  TextEditingController tahunTerbit = TextEditingController();

  Future _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        tahunTerbit.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future _simpan() async {
    final response = await http.post(
      Uri.parse(
          "http://localhost/pustaka_2301081006/proses_buku.php?aksi=insert"),
      body: {
        "kode_buku": kodeBuku.text,
        "judul": judul.text,
        "pengarang": pengarang.text,
        "penerbit": penerbit.text,
        "tahun_terbit": tahunTerbit.text,
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Buku'),
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
                controller: kodeBuku,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Kode Buku",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kode Buku Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: judul,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Judul Buku",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Judul Buku Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: pengarang,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Pengarang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pengarang Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: penerbit,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Penerbit",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Penerbit Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                onTap: () => _selectDate(context),
                controller: tahunTerbit,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Tahun terbit",
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Tahun Terbit Tidak Boleh Kosong";
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
