import 'package:flutter/material.dart';

import '../models/transaksi.dart';
import '../widgets/app_header.dart';
import '../widgets/brutalist_card.dart';

// halaman laporan
class LaporanScreen extends StatelessWidget {
  final List<Transaksi> daftarTransaksi;

  const LaporanScreen({super.key, required this.daftarTransaksi});

  @override
  Widget build(BuildContext context) {
    final sekarang = DateTime.now();
    final bulanAwal = DateTime(sekarang.year, sekarang.month - 5);
    final bulan = List<DateTime>.generate(
      6,
      (index) => DateTime(bulanAwal.year, bulanAwal.month + index),
    );
    final pengeluaranBulanan = List<double>.filled(6, 0);

    for (final transaksi in daftarTransaksi) {
      if (transaksi.tipe != 'Pengeluaran') {
        continue;
      }
      final index =
          (transaksi.tanggal.year - bulanAwal.year) * 12 +
          transaksi.tanggal.month -
          bulanAwal.month;
      if (index >= 0 && index < pengeluaranBulanan.length) {
        pengeluaranBulanan[index] += transaksi.nominal;
      }
    }

    final pengeluaranMaksimal = pengeluaranBulanan.fold<double>(
      0,
      (maximum, value) => value > maximum ? value : maximum,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header
        const AppHeader(title: 'Laporan.', subtitle: 'Analisis finansialmu.'),
        const SizedBox(height: 32),

        // card grafik
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BrutalistCard(
            height: 300,
            child: Column(
              children: [
                const Text(
                  "Pengeluaran 6 Bulan Terakhir",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(bulan.length, (index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // batang grafik
                        Container(
                          width: 32,
                          height: pengeluaranMaksimal == 0
                              ? 0
                              : 180 *
                                    (pengeluaranBulanan[index] /
                                        pengeluaranMaksimal),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB5E48C),
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // label bulan
                        Text(
                          _namaBulan(bulan[index].month),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _namaBulan(int month) {
    const namaBulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return namaBulan[month - 1];
  }
}
