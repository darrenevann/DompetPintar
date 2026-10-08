import 'package:flutter/material.dart';

import '../models/transaksi.dart';
import '../utils/format_rupiah.dart';
import '../widgets/app_header.dart';
import '../widgets/brutalist_card.dart';

// halaman dashboard
class DashboardScreen extends StatefulWidget {
  final List<Transaksi> daftarTransaksi;
  final void Function(Transaksi transaksi) onDetailTransaksi;

  const DashboardScreen({
    super.key,
    required this.daftarTransaksi,
    required this.onDetailTransaksi,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isSearchExpanded = false;
  bool _isSaldoVisible = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSaldoVisibility() {
    setState(() {
      _isSaldoVisible = !_isSaldoVisible;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });

    if (_isSearchExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    } else {
      _searchFocusNode.unfocus();
      _searchController.clear();
    }
  }

  List<Transaksi> _getFilteredTransaksi() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.daftarTransaksi;
    }

    return widget.daftarTransaksi.where((transaksi) {
      final judul = transaksi.judul.toLowerCase();
      final tipe = transaksi.tipe.toLowerCase();
      return judul.contains(query) || tipe.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung total statis
    double totalSaldo = 15000000;
    double totalPemasukan = 5000000;
    double totalPengeluaran = 150000;
    final filteredTransaksi = _getFilteredTransaksi();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // app bar custom
          LayoutBuilder(
            builder: (context, constraints) {
              final maxSearchWidth = (constraints.maxWidth - 210).clamp(
                0.0,
                220.0,
              );

              return Row(
                children: [
                  if (!_isSearchExpanded)
                    Expanded(
                      child: BrutalistCard(
                        backgroundColor: const Color(0xFFFFD166),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: const Text(
                          'DompetPintar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  if (_isSearchExpanded) const SizedBox(width: 0),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      const BrutalistCard(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.settings, size: 24),
                      ),
                      const SizedBox(width: 12),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _isSearchExpanded ? maxSearchWidth : 0,
                        curve: Curves.easeInOutCubic,
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: BrutalistCard(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                textInputAction: TextInputAction.search,
                                keyboardType: TextInputType.text,
                                    onChanged: (_) => setState(() {}),
                                    decoration: const InputDecoration(
                                      hintText: 'Cari transaksi...',
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _toggleSearch,
                        child: const BrutalistCard(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.search, size: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          // header saldo
          const AppHeader(title: 'Saldo Anda.', subtitle: 'Kelola sekarang'),
          const SizedBox(height: 24),

          // card saldo utama
          BrutalistCard(
            backgroundColor: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TOTAL SALDO",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  key: const ValueKey('saldo-kolom'),
                  behavior: HitTestBehavior.opaque,
                  onLongPress: _toggleSaldoVisibility,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _isSaldoVisible ? formatRupiah(totalSaldo) : '****',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        key: const ValueKey('toggle-saldo'),
                        behavior: HitTestBehavior.opaque,
                        onTap: _toggleSaldoVisibility,
                        child: Icon(
                          _isSaldoVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ringkasan pemasukan & pengeluaran
          Row(
            children: [
              Expanded(
                child: BrutalistCard(
                  backgroundColor: const Color(0xFFB5E48C), // Hijau
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_downward, size: 28),
                      const SizedBox(height: 12),
                      const Text(
                        "Pemasukan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatRupiah(totalPemasukan),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BrutalistCard(
                  backgroundColor: const Color(0xFFFF9E9E), // Merah muda
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_upward, size: 28),
                      const SizedBox(height: 12),
                      const Text(
                        "Pengeluaran",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatRupiah(totalPengeluaran),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // judul riwayat
          const Text(
            "Transaksi Terakhir",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // daftar transaksi
          if (filteredTransaksi.isEmpty)
            BrutalistCard(
              backgroundColor: Colors.white,
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Tidak ada transaksi yang cocok dengan pencarian.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTransaksi.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final trx = filteredTransaksi[index];
                return GestureDetector(
                  key: ValueKey('transaksi-${trx.id}'),
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: () => widget.onDetailTransaksi(trx),
                  child: BrutalistCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        BrutalistCard(
                          backgroundColor: trx.tipe == 'Pemasukan'
                              ? const Color(0xFFB5E48C)
                              : const Color(0xFFFF9E9E),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            trx.tipe == 'Pemasukan'
                                ? Icons.attach_money
                                : Icons.money_off,
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                trx.tipe,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
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
        ],
      ),
    );
  }
}
