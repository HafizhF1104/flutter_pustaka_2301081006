class Pengembalian {
  int? id;
  String tanggal_dikembalikan;
  int terlambat;
  int denda;
  int peminjaman_id;

  Pengembalian({
    this.id,
    required this.tanggal_dikembalikan,
    required this.terlambat,
    required this.denda,
    required this.peminjaman_id,
  });
}
