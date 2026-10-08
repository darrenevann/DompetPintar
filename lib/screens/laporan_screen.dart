import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/brutalist_card.dart';

// halaman laporan
class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // data grafik statis
    final List<Map<String, dynamic>> dataGrafik = [
      {'bulan': 'Jan', 'nilai': 0.4},
      {'bulan': 'Feb', 'nilai': 0.7},
      {'bulan': 'Mar', 'nilai': 0.5},
      {'bulan': 'Apr', 'nilai': 0.9},
      {'bulan': 'Mei', 'nilai': 0.6},
      {'bulan': 'Jun', 'nilai': 0.8},
    ];

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
                  children: dataGrafik.map((data) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // batang grafik
                        Container(
                          width: 32,
                          height: (180 * data['nilai']).toDouble(),
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
                          data['bulan'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
