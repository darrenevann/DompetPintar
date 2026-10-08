import 'package:flutter/material.dart';

import '../models/transaksi.dart';
import '../utils/format_rupiah.dart';
import '../widgets/app_header.dart';
import '../widgets/brutalist_card.dart';

// halaman transaksi
class TransaksiScreen extends StatefulWidget {
  final List<Transaksi> daftarTransaksi;
  final void Function(Transaksi transaksi) onDetailTransaksi;

  const TransaksiScreen({
    super.key,
    required this.daftarTransaksi,
    required this.onDetailTransaksi,
  });

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  // state filter lokal
  String _filterAktif = 'Semua';

  @override
  Widget build(BuildContext context) {
    // logika filter data
    final dataTampil = widget.daftarTransaksi.where((trx) {
      if (_filterAktif == 'Semua') return true;
      return trx.tipe == _filterAktif;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header
        const AppHeader(title: 'Riwayat.', subtitle: 'Cek uangmu.'),
        const SizedBox(height: 20),

        // baris filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildFilterButton('Semua'),
              const SizedBox(width: 12),
              _buildFilterButton('Pemasukan'),
              const SizedBox(width: 12),
              _buildFilterButton('Pengeluaran'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // daftar transaksi
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: dataTampil.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final trx = dataTampil[index];

              // gesture detector
              return GestureDetector(
                key: ValueKey('transaksi-${trx.id}'),
                onDoubleTap: () => widget.onDetailTransaksi(trx),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Detail: ${trx.judul}')),
                  );
                },
                child: BrutalistCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      BrutalistCard(
                        backgroundColor: trx.tipe == 'Pemasukan'
                            ? const Color(0xFFB5E48C)
                            : const Color(0xFFFF9E9E),
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          trx.tipe == 'Pemasukan'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trx.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${trx.tanggal.day}/${trx.tanggal.month}/${trx.tanggal.year}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatRupiah(trx.nominal),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // widget filter button
  Widget _buildFilterButton(String label) {
    final bool isAktif = _filterAktif == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterAktif = label;
        });
      },
      child: BrutalistCard(
        backgroundColor: isAktif ? const Color(0xFFFFD166) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
