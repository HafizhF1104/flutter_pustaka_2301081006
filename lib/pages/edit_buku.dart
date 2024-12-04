import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EditBuku extends StatefulWidget {
  final Map ListData;
  EditBuku({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditBuku> createState() => _EditBukuState();
}

class _EditBukuState extends State<EditBuku> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
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

    if (selectedDate != null) {
      setState(() {
        tahunTerbit.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future _update() async {
    final response = await http.post(
      Uri.parse(
          "http://localhost/pustaka_2301081006/proses_buku.php?aksi=edit"),
      body: {
        "id": id.text,
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
  void initState() {
    super.initState();
    id.text = widget.ListData['id'];
    kodeBuku.text = widget.ListData['kode_buku'];
    judul.text = widget.ListData['judul'];
    pengarang.text = widget.ListData['pengarang'];
    penerbit.text = widget.ListData['penerbit'];
    tahunTerbit.text = widget.ListData['tahun_terbit'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Buku'),
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
