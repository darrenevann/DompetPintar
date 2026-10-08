// model transaksi
class Transaksi {
  final String id;
  final String judul;
  final double nominal;
  final String tipe;
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.judul,
    required this.nominal,
    required this.tipe,
    required this.tanggal,
  });
}
