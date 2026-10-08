import 'package:flutter/material.dart';

import '../models/budget.dart';
import '../models/transaksi.dart';
import '../utils/format_rupiah.dart';
import '../widgets/app_header.dart';
import '../widgets/brutalist_card.dart';

// halaman budget
class BudgetScreen extends StatelessWidget {
  final List<Budget> daftarBudget;
  final List<Transaksi> daftarTransaksi;

  const BudgetScreen({
    super.key,
    required this.daftarBudget,
    required this.daftarTransaksi,
  });

  @override
  Widget build(BuildContext context) {
    final sekarang = DateTime.now();
    final pengeluaranPerKategori = <String, double>{};
    for (final transaksi in daftarTransaksi) {
      if (transaksi.tipe == 'Pengeluaran' &&
          transaksi.tanggal.year == sekarang.year &&
          transaksi.tanggal.month == sekarang.month) {
        pengeluaranPerKategori.update(
          transaksi.kategori,
          (total) => total + transaksi.nominal,
          ifAbsent: () => transaksi.nominal,
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header
        const AppHeader(title: 'Anggaran.', subtitle: 'Kendalikan uangmu.'),
        const SizedBox(height: 20),

        // daftar budget
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: daftarBudget.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final budget = daftarBudget[index];
              final terpakai = pengeluaranPerKategori[budget.kategori] ?? 0;
              final rasio = (terpakai / budget.batas).clamp(0.0, 1.0);
              final warna = switch (budget.kategori) {
                'Transportasi' => const Color(0xFFFF9E9E),
                'Hiburan' => const Color(0xFFFFD166),
                _ => const Color(0xFFB5E48C),
              };

              return BrutalistCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // info teks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          budget.kategori,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${formatRupiah(terpakai)} / ${formatRupiah(budget.batas)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // progress bar custom
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double maxWidth = constraints.maxWidth;
                        return Stack(
                          children: [
                            // background bar
                            Container(
                              height: 24,
                              width: maxWidth,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            // foreground bar
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                height: 24,
                                width: maxWidth * rasio,
                                decoration: BoxDecoration(
                                  color: warna,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
