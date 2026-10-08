import 'package:flutter/material.dart';

import '../models/budget.dart';
import '../models/transaksi.dart';
import '../services/finance_repository.dart';
import '../utils/format_rupiah.dart';
import '../widgets/brutalist_card.dart';
import 'budget_screen.dart';
import 'dashboard_screen.dart';
import 'laporan_screen.dart';
import 'transaksi_screen.dart';

// main screen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const double _saldoAwal = 10150000;

  int _selectedIndex = 0;
  final FinanceRepository _repository = FinanceRepository();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  List<Transaksi> _daftarTransaksi = [];
  List<Budget> _daftarBudget = [];
  bool _isReady = false;
  String? _loadError;

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  Future<void> _loadFinanceData() async {
    try {
      final data = await _repository.load();
      if (!mounted) return;
      setState(() {
        _daftarTransaksi = data.transaksi;
        _daftarBudget = data.anggaran;
        _isReady = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.toString();
        _isReady = true;
      });
    }
  }

  double get _totalPemasukan => _daftarTransaksi
      .where((transaksi) => transaksi.tipe == 'Pemasukan')
      .fold(0, (total, transaksi) => total + transaksi.nominal);

  double get _totalPengeluaran => _daftarTransaksi
      .where((transaksi) => transaksi.tipe == 'Pengeluaran')
      .fold(0, (total, transaksi) => total + transaksi.nominal);

  double get _totalSaldo => _saldoAwal + _totalPemasukan - _totalPengeluaran;

  // navigasi fungsi
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _tampilkanDetailTransaksi(Transaksi transaksi) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Detail Transaksi',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Judul', transaksi.judul),
              const SizedBox(height: 12),
              _buildDetailRow('Tipe', transaksi.tipe),
              const SizedBox(height: 12),
              _buildDetailRow('Nominal', formatRupiah(transaksi.nominal)),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Tanggal',
                '${transaksi.tanggal.day}/${transaksi.tanggal.month}/${transaksi.tanggal.year}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  double? _parseNominal(String input) {
    var normalized = input.trim().replaceAll(RegExp(r'\s+'), '');
    normalized = normalized.replaceFirst(
      RegExp(r'^Rp\.?', caseSensitive: false),
      '',
    );
    if (!RegExp(r'^(?:\d+|\d{1,3}(?:\.\d{3})+)(?:,\d+)?$')
        .hasMatch(normalized)) {
      return null;
    }

    normalized = normalized.replaceAll('.', '').replaceFirst(',', '.');
    final value = double.tryParse(normalized);
    return value != null && value.isFinite && value > 0 ? value : null;
  }

  Future<void> _tambahTransaksi() async {
    if (!_isReady || _loadError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _loadError == null
                ? 'Data masih dimuat. Coba lagi sebentar.'
                : 'Data gagal dimuat: $_loadError',
          ),
        ),
      );
      return;
    }

    _judulController.clear();
    _nominalController.clear();
    String tipeTransaksi = 'Pengeluaran';
    DateTime tanggalTransaksi = DateTime.now();
    bool sedangMenyimpan = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Tambah Transaksi',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      key: const ValueKey('judul'),
                      controller: _judulController,
                      decoration: const InputDecoration(
                        labelText: 'Judul transaksi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('nominal'),
                      controller: _nominalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nominal',
                        prefixText: 'Rp. ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: const ValueKey('tipe'),
                      initialValue: tipeTransaksi,
                      decoration: const InputDecoration(
                        labelText: 'Tipe transaksi',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Pemasukan',
                          child: Text('Pemasukan'),
                        ),
                        DropdownMenuItem(
                          value: 'Pengeluaran',
                          child: Text('Pengeluaran'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => tipeTransaksi = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tanggal: ${tanggalTransaksi.day}/${tanggalTransaksi.month}/${tanggalTransaksi.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final tanggalDipilih = await showDatePicker(
                              context: context,
                              initialDate: tanggalTransaksi,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                            );

                            if (tanggalDipilih != null) {
                              setDialogState(() {
                                tanggalTransaksi = tanggalDipilih;
                              });
                            }
                          },
                          child: const Text('Pilih tanggal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: sedangMenyimpan
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: sedangMenyimpan
                      ? null
                      : () async {
                          final judul = _judulController.text.trim();
                          final nominal = _parseNominal(
                            _nominalController.text,
                          );

                          if (judul.isEmpty || nominal == null) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Judul dan nominal transaksi harus valid.',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => sedangMenyimpan = true);
                          final transaksiBaru = Transaksi(
                            id: DateTime.now().microsecondsSinceEpoch
                                .toString(),
                            judul: judul,
                            nominal: nominal,
                            tipe: tipeTransaksi,
                            tanggal: tanggalTransaksi,
                          );
                          final transaksiTerbaru = [
                            ..._daftarTransaksi,
                            transaksiBaru,
                          ]..sort((a, b) => b.tanggal.compareTo(a.tanggal));

                          try {
                            await _repository.saveTransactions(
                              transaksiTerbaru,
                            );
                            if (!mounted || !dialogContext.mounted) return;
                            setState(() => _daftarTransaksi = transaksiTerbaru);
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Transaksi berhasil ditambahkan.',
                                ),
                              ),
                            );
                          } catch (error) {
                            if (!dialogContext.mounted) return;
                            setDialogState(() => sedangMenyimpan = false);
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Transaksi gagal disimpan: $error',
                                ),
                              ),
                            );
                          }
                        },
                  child: const Text('Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // daftar halaman
    final List<Widget> halaman = [
      DashboardScreen(
        daftarTransaksi: _daftarTransaksi,
        onDetailTransaksi: _tampilkanDetailTransaksi,
        totalSaldo: _totalSaldo,
        totalPemasukan: _totalPemasukan,
        totalPengeluaran: _totalPengeluaran,
      ),
      TransaksiScreen(
        daftarTransaksi: _daftarTransaksi,
        onDetailTransaksi: _tampilkanDetailTransaksi,
      ),
      BudgetScreen(
        daftarBudget: _daftarBudget,
        daftarTransaksi: _daftarTransaksi,
      ),
      LaporanScreen(daftarTransaksi: _daftarTransaksi),
    ];

    return Scaffold(
      // body
      body: SafeArea(
        child: !_isReady
            ? const Center(child: CircularProgressIndicator())
            : _loadError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Gagal memuat data keuangan: $_loadError'),
                ),
              )
            : halaman[_selectedIndex],
      ),
      // floating button
      floatingActionButton: BrutalistCard(
        backgroundColor: const Color(0xFFFFD166), // Kuning
        padding: const EdgeInsets.all(0),
        width: 60,
        height: 60,
        child: IconButton(
          onPressed: _isReady && _loadError == null ? _tambahTransaksi : null,
          icon: const Icon(Icons.add, size: 32, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // navigasi bawah
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 3)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFFAF9F6),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Laporan',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
