import 'package:flutter/material.dart';

import '../models/transaksi.dart';
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
  // state
  int _selectedIndex = 0;

  // data dummy
  final List<Transaksi> _daftarTransaksi = [
    Transaksi(
      id: '1',
      judul: 'Gaji Bulanan',
      nominal: 5000000,
      tipe: 'Pemasukan',
      tanggal: DateTime.now(),
    ),
    Transaksi(
      id: '2',
      judul: 'Makan Siang',
      nominal: 50000,
      tipe: 'Pengeluaran',
      tanggal: DateTime.now(),
    ),
    Transaksi(
      id: '3',
      judul: 'Beli Kuota',
      nominal: 100000,
      tipe: 'Pengeluaran',
      tanggal: DateTime.now(),
    ),
  ];

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

  void _tambahTransaksi() {
    final judulController = TextEditingController();
    final nominalController = TextEditingController();
    String tipeTransaksi = 'Pengeluaran';
    DateTime tanggalTransaksi = DateTime.now();

    showDialog<void>(
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
                      controller: judulController,
                      decoration: const InputDecoration(
                        labelText: 'Judul transaksi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('nominal'),
                      controller: nominalController,
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
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final judul = judulController.text.trim();
                    final nominal = double.tryParse(nominalController.text);

                    if (judul.isEmpty || nominal == null || nominal <= 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Judul dan nominal transaksi harus valid.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _daftarTransaksi.insert(
                        0,
                        Transaksi(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          judul: judul,
                          nominal: nominal,
                          tipe: tipeTransaksi,
                          tanggal: tanggalTransaksi,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaksi berhasil ditambahkan.'),
                      ),
                    );
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
      ),
      TransaksiScreen(
        daftarTransaksi: _daftarTransaksi,
        onDetailTransaksi: _tampilkanDetailTransaksi,
      ),
      const BudgetScreen(),
      const LaporanScreen(),
    ];

    return Scaffold(
      // body
      body: SafeArea(child: halaman[_selectedIndex]),
      // floating button
      floatingActionButton: BrutalistCard(
        backgroundColor: const Color(0xFFFFD166), // Kuning
        padding: const EdgeInsets.all(0),
        width: 60,
        height: 60,
        child: IconButton(
          onPressed: _tambahTransaksi,
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
