class Budget {
  final String kategori;
  final double batas;

  const Budget({required this.kategori, required this.batas});

  Map<String, Object> toJson() => {'kategori': kategori, 'batas': batas};

  factory Budget.fromJson(Map<String, dynamic> json) {
    final kategori = json['kategori'] as String?;
    final batas = (json['batas'] as num?)?.toDouble();

    if (kategori == null ||
        kategori.trim().isEmpty ||
        batas == null ||
        !batas.isFinite ||
        batas <= 0) {
      throw const FormatException('Data anggaran tersimpan tidak valid.');
    }

    return Budget(kategori: kategori, batas: batas);
  }
}
