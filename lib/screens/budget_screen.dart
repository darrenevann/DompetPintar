import 'package:flutter/material.dart';

import '../utils/format_rupiah.dart';
import '../widgets/app_header.dart';
import '../widgets/brutalist_card.dart';

// halaman budget
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // data dummy
    final List<Map<String, dynamic>> daftarBudget = [
      {
        'kategori': 'Makanan',
        'terpakai': 1500000,
        'total': 2000000,
        'warna': const Color(0xFFB5E48C),
      },
      {
        'kategori': 'Transportasi',
        'terpakai': 850000,
        'total': 750000,
        'warna': const Color(0xFFFF9E9E),
      },
      {
        'kategori': 'Hiburan',
        'terpakai': 300000,
        'total': 1000000,
        'warna': const Color(0xFFFFD166),
      },
    ];

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
              // perhitungan rasio
              final double rasio = (budget['terpakai'] / budget['total']).clamp(
                0.0,
                1.0,
              );

              return BrutalistCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // info teks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          budget['kategori'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${formatRupiah(budget['terpakai'])} / ${formatRupiah(budget['total'])}',
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
                                  color: budget['warna'],
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
