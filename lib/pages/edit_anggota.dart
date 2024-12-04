import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EditAnggota extends StatefulWidget {
  final Map ListData;
  EditAnggota({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditAnggota> createState() => _EditAnggotaState();
}

class _EditAnggotaState extends State<EditAnggota> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController nim = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();

  String? jenisKelamin;

  List<String> jenisKelaminOptions = ['Laki-laki', 'Perempuan'];

  Future _update() async {
    final response = await http.post(
      Uri.parse(
          "http://localhost/pustaka_2301081006/proses_anggota.php?aksi=edit"),
      body: {
        "id": id.text,
        "nim": nim.text,
        "nama": nama.text,
        "jenis_kelamin": jenisKelamin!,
        "alamat": alamat.text,
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    id.text = widget.ListData['id'];
    nim.text = widget.ListData['nim'];
    nama.text = widget.ListData['nama'];
    jenisKelamin = widget.ListData['jenis_kelamin'];
    alamat.text = widget.ListData['alamat'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Anggota'),
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
                controller: nim,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "NIM",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "NIM Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nama,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Nama Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: jenisKelamin,
                onChanged: (newValue) {
                  setState(() {
                    jenisKelamin = newValue;
                  });
                },
                items: jenisKelaminOptions.map((jenis) {
                  return DropdownMenuItem<String>(
                    value: jenis,
                    child: Text(jenis),
                  );
                }).toList(),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Jenis Kelamin",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Jenis Kelamin Tidak Boleh Kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: alamat,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Alamat",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Alamat Tidak Boleh Kosong";
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
