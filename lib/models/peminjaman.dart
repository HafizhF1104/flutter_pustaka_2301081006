class Peminjaman {
  int? id;
  String tanggalPinjam;
  String tanggalKembali;
  int anggotaId;
  int bukuId;

  Peminjaman({
    this.id,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.anggotaId,
    required this.bukuId,
  });
}
