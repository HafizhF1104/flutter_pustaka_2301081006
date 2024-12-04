class Pengembalian {
  int? id;
  String tanggalDikembalikan;
  int terlambat;
  int denda;
  int peminjamanId;

  Pengembalian({
    this.id,
    required this.tanggalDikembalikan,
    required this.terlambat,
    required this.denda,
    required this.peminjamanId,
  });
}
