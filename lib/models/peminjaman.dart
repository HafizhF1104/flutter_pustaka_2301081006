class Peminjaman {
  int? id;
  String tanggal_pinjam;
  String tanggal_kembali;
  int anggota_id;
  int buku_id;

  Peminjaman({
    this.id,
    required this.tanggal_pinjam,
    required this.tanggal_kembali,
    required this.anggota_id,
    required this.buku_id,
  });
}
