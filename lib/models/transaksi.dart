// model transaksi
class Transaksi {
  final String id;
  final String judul;
  final double nominal;
  final String tipe;
  final DateTime tanggal;
  final String kategori;

  Transaksi({
    required this.id,
    required this.judul,
    required this.nominal,
    required this.tipe,
    required this.tanggal,
    String? kategori,
  }) : kategori = kategori ?? kategoriDariJudul(judul);

  static String kategoriDariJudul(String judul) {
    final normalizedTitle = judul.toLowerCase();

    const kategoriDanKataKunci = <String, List<String>>{
      'Makanan': [
        'makan',
        'makanan',
        'food',
        'restoran',
        'restaurant',
        'warung',
        'snack',
        'jajan',
        'kopi',
        'minum',
        'groceries',
        'belanja dapur',
      ],
      'Transportasi': [
        'transport',
        'ojek',
        'grab',
        'gojek',
        'bensin',
        'bbm',
        'parkir',
        'tol',
        'bus',
        'kereta',
        'taksi',
        'taxi',
      ],
      'Hiburan': [
        'hiburan',
        'entertainment',
        'movie',
        'film',
        'game',
        'netflix',
        'spotify',
        'streaming',
        'konser',
        'rekreasi',
      ],
    };

    for (final entry in kategoriDanKataKunci.entries) {
      if (entry.value.any(
        (keyword) =>
            RegExp('\\b${RegExp.escape(keyword)}\\b').hasMatch(normalizedTitle),
      )) {
        return entry.key;
      }
    }

    return 'Lainnya';
  }

  Map<String, Object> toJson() => {
    'id': id,
    'judul': judul,
    'nominal': nominal,
    'tipe': tipe,
    'tanggal': tanggal.toIso8601String(),
    'kategori': kategori,
  };

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    final nominal = (json['nominal'] as num?)?.toDouble();
    final judul = json['judul'] as String?;
    final tipe = json['tipe'] as String?;
    final tanggalValue = json['tanggal'] as String?;
    final id = json['id'] as String?;

    if (id == null ||
        judul == null ||
        tipe == null ||
        tanggalValue == null ||
        nominal == null ||
        !nominal.isFinite ||
        nominal <= 0 ||
        (tipe != 'Pemasukan' && tipe != 'Pengeluaran')) {
      throw const FormatException('Data transaksi tersimpan tidak valid.');
    }

    return Transaksi(
      id: id,
      judul: judul,
      nominal: nominal,
      tipe: tipe,
      tanggal: DateTime.parse(tanggalValue),
      kategori: json['kategori'] as String?,
    );
  }
}
