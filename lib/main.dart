import 'package:flutter/material.dart';

void main() {
  runApp(const DompetPintarApp());
}

// ======================================================
// MODEL TRANSAKSI
// ======================================================

class Transaksi {
  final String id;
  final String judul;
  final double nominal;
  final String tipe; // pemasukan / pengeluaran
  final String kategori;
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.judul,
    required this.nominal,
    required this.tipe,
    required this.kategori,
    required this.tanggal,
  });
}

// ======================================================
// MODEL BUDGET
// ======================================================

class Budget {
  String kategori;
  double jumlah;

  Budget({
    required this.kategori,
    required this.jumlah,
  });
}

// ======================================================
// APP
// ======================================================

class DompetPintarApp extends StatelessWidget {
  const DompetPintarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DompetPintar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// ======================================================
// MAIN SCREEN
// ======================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Transaksi> _daftarTransaksi = [
    Transaksi(
      id: '1',
      judul: 'Uang Bulanan',
      nominal: 3000000,
      tipe: 'pemasukan',
      kategori: 'Gaji',
      tanggal: DateTime.now(),
    ),
    Transaksi(
      id: '2',
      judul: 'Makan Siang',
      nominal: 25000,
      tipe: 'pengeluaran',
      kategori: 'Makanan',
      tanggal: DateTime.now(),
    ),
    Transaksi(
      id: '3',
      judul: 'Transportasi',
      nominal: 20000,
      tipe: 'pengeluaran',
      kategori: 'Transportasi',
      tanggal: DateTime.now(),
    ),
  ];

  final List<Budget> _daftarBudget = [
    Budget(
      kategori: 'Makanan',
      jumlah: 1000000,
    ),
    Budget(
      kategori: 'Transportasi',
      jumlah: 500000,
    ),
    Budget(
      kategori: 'Hiburan',
      jumlah: 300000,
    ),
  ];

  void _tambahTransaksi(Transaksi transaksi) {
    setState(() {
      _daftarTransaksi.insert(0, transaksi);
    });
  }

  void _tambahAtauUpdateBudget(Budget budget) {
    setState(() {
      final index = _daftarBudget.indexWhere(
        (item) => item.kategori == budget.kategori,
      );

      if (index >= 0) {
        _daftarBudget[index] = budget;
      } else {
        _daftarBudget.add(budget);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> halaman = [
      DashboardScreen(
        daftarTransaksi: _daftarTransaksi,
      ),
      TransaksiScreen(
        daftarTransaksi: _daftarTransaksi,
      ),
      BudgetScreen(
        daftarBudget: _daftarBudget,
        daftarTransaksi: _daftarTransaksi,
        onBudgetChanged: _tambahAtauUpdateBudget,
      ),
      LaporanScreen(
        daftarTransaksi: _daftarTransaksi,
      ),
    ];

    return Scaffold(
      body: halaman[_selectedIndex],

      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                _showTambahTransaksi(context);
              },
              child: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }

  // ====================================================
  // DIALOG TAMBAH TRANSAKSI
  // ====================================================

  void _showTambahTransaksi(BuildContext context) {
    final judulController = TextEditingController();
    final nominalController = TextEditingController();

    String tipe = 'pengeluaran';
    String kategori = 'Makanan';
    DateTime tanggal = DateTime.now();

    final List<String> kategoriPengeluaran = [
      'Makanan',
      'Transportasi',
      'Hiburan',
      'Belanja',
      'Tagihan',
      'Lainnya',
    ];

    final List<String> kategoriPemasukan = [
      'Gaji',
      'Bonus',
      'Uang Saku',
      'Investasi',
      'Lainnya',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final kategoriList = tipe == 'pengeluaran'
                ? kategoriPengeluaran
                : kategoriPemasukan;

            if (!kategoriList.contains(kategori)) {
              kategori = kategoriList.first;
            }

            return AlertDialog(
              title: const Text('Tambah Transaksi'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(
                        labelText: 'Nama transaksi',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nominal',
                        prefixText: 'Rp ',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: tipe,
                      decoration: const InputDecoration(
                        labelText: 'Tipe',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'pemasukan',
                          child: Text('Pemasukan'),
                        ),
                        DropdownMenuItem(
                          value: 'pengeluaran',
                          child: Text('Pengeluaran'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setDialogState(() {
                          tipe = value;
                          kategori = value == 'pengeluaran'
                              ? kategoriPengeluaran.first
                              : kategoriPemasukan.first;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: kategori,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: kategoriList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setDialogState(() {
                          kategori = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Tanggal'),
                      subtitle: Text(
                        '${tanggal.day}/${tanggal.month}/${tanggal.year}',
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tanggal,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            tanggal = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nominal = double.tryParse(
                      nominalController.text.replaceAll('.', ''),
                    );

                    if (judulController.text.trim().isEmpty ||
                        nominal == null ||
                        nominal <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nama dan nominal harus diisi dengan benar.',
                          ),
                        ),
                      );
                      return;
                    }

                    final transaksi = Transaksi(
                      id: DateTime.now()
                          .millisecondsSinceEpoch
                          .toString(),
                      judul: judulController.text.trim(),
                      nominal: nominal,
                      tipe: tipe,
                      kategori: kategori,
                      tanggal: tanggal,
                    );

                    _tambahTransaksi(transaksi);

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ======================================================
// DASHBOARD
// ======================================================

class DashboardScreen extends StatelessWidget {
  final List<Transaksi> daftarTransaksi;

  const DashboardScreen({
    super.key,
    required this.daftarTransaksi,
  });

  double get totalPemasukan {
    return daftarTransaksi
        .where((item) => item.tipe == 'pemasukan')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get totalPengeluaran {
    return daftarTransaksi
        .where((item) => item.tipe == 'pengeluaran')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get saldo {
    return totalPemasukan - totalPengeluaran;
  }

  String formatRupiah(double angka) {
    return 'Rp ${angka.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DompetPintar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SALDO
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Saat Ini',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatRupiah(saldo),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // PEMASUKAN & PENGELUARAN
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    context,
                    'Pemasukan',
                    totalPemasukan,
                    Icons.arrow_downward,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoCard(
                    context,
                    'Pengeluaran',
                    totalPengeluaran,
                    Icons.arrow_upward,
                    Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Transaksi Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (daftarTransaksi.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text('Belum ada transaksi.'),
                ),
              )
            else
              ...daftarTransaksi.take(5).map(
                (transaksi) {
                  final isIncome =
                      transaksi.tipe == 'pemasukan';

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          isIncome
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                        ),
                      ),
                      title: Text(transaksi.judul),
                      subtitle: Text(
                        '${transaksi.kategori} • ${transaksi.tanggal.day}/${transaksi.tanggal.month}/${transaksi.tanggal.year}',
                      ),
                      trailing: Text(
                        '${isIncome ? '+' : '-'} ${formatRupiah(transaksi.nominal)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    BuildContext context,
    String title,
    double nominal,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(title),
            const SizedBox(height: 4),
            Text(
              formatRupiah(nominal),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// TRANSAKSI SCREEN
// ======================================================

class TransaksiScreen extends StatefulWidget {
  final List<Transaksi> daftarTransaksi;

  const TransaksiScreen({
    super.key,
    required this.daftarTransaksi,
  });

  @override
  State<TransaksiScreen> createState() =>
      _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  String filter = 'Semua';

  String formatRupiah(double angka) {
    return 'Rp ${angka.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    List<Transaksi> transaksi = widget.daftarTransaksi;

    if (filter == 'Pemasukan') {
      transaksi = transaksi
          .where((item) => item.tipe == 'pemasukan')
          .toList();
    } else if (filter == 'Pengeluaran') {
      transaksi = transaksi
          .where((item) => item.tipe == 'pengeluaran')
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Semua',
                  label: Text('Semua'),
                ),
                ButtonSegment(
                  value: 'Pemasukan',
                  label: Text('Masuk'),
                ),
                ButtonSegment(
                  value: 'Pengeluaran',
                  label: Text('Keluar'),
                ),
              ],
              selected: {filter},
              onSelectionChanged: (value) {
                setState(() {
                  filter = value.first;
                });
              },
            ),
          ),

          Expanded(
            child: transaksi.isEmpty
                ? const Center(
                    child: Text('Belum ada transaksi.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: transaksi.length,
                    itemBuilder: (context, index) {
                      final item = transaksi[index];
                      final isIncome =
                          item.tipe == 'pemasukan';

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                            ),
                          ),
                          title: Text(item.judul),
                          subtitle: Text(
                            '${item.kategori} • ${item.tanggal.day}/${item.tanggal.month}/${item.tanggal.year}',
                          ),
                          trailing: Text(
                            '${isIncome ? '+' : '-'} ${formatRupiah(item.nominal)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isIncome
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// BUDGET SCREEN
// ======================================================

class BudgetScreen extends StatefulWidget {
  final List<Budget> daftarBudget;
  final List<Transaksi> daftarTransaksi;
  final Function(Budget) onBudgetChanged;

  const BudgetScreen({
    super.key,
    required this.daftarBudget,
    required this.daftarTransaksi,
    required this.onBudgetChanged,
  });

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  double pengeluaranKategori(String kategori) {
    return widget.daftarTransaksi
        .where(
          (item) =>
              item.tipe == 'pengeluaran' &&
              item.kategori == kategori,
        )
        .fold(
          0.0,
          (sum, item) => sum + item.nominal,
        );
  }

  String formatRupiah(double angka) {
    return 'Rp ${angka.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBudgetDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: widget.daftarBudget.isEmpty
          ? const Center(
              child: Text('Belum ada budget.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.daftarBudget.length,
              itemBuilder: (context, index) {
                final budget = widget.daftarBudget[index];

                final terpakai =
                    pengeluaranKategori(budget.kategori);

                // DIPAKSA DOUBLE AGAR TIDAK ERROR NUM
                final double rasio = budget.jumlah <= 0
                    ? 0.0
                    : (terpakai / budget.jumlah)
                        .toDouble();

                final double progress =
                    rasio.clamp(0.0, 1.0).toDouble();

                final bool melebihi =
                    terpakai > budget.jumlah;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              budget.kategori,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showBudgetDialog(
                                  context,
                                  budgetLama: budget,
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '${formatRupiah(terpakai)} / ${formatRupiah(budget.jumlah)}',
                        ),

                        const SizedBox(height: 8),

                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          melebihi
                              ? 'Budget terlampaui!'
                              : '${(rasio * 100).toStringAsFixed(0)}% digunakan',
                          style: TextStyle(
                            color: melebihi
                                ? Colors.red
                                : Colors.grey[700],
                            fontWeight: melebihi
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showBudgetDialog(
    BuildContext context, {
    Budget? budgetLama,
  }) {
    final nominalController = TextEditingController(
      text: budgetLama?.jumlah.toStringAsFixed(0) ?? '',
    );

    String kategori = budgetLama?.kategori ?? 'Makanan';

    final kategoriList = [
      'Makanan',
      'Transportasi',
      'Hiburan',
      'Belanja',
      'Tagihan',
      'Lainnya',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                budgetLama == null
                    ? 'Tambah Budget'
                    : 'Edit Budget',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: kategori,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: kategoriList.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: budgetLama != null
                        ? null
                        : (value) {
                            if (value == null) return;

                            setDialogState(() {
                              kategori = value;
                            });
                          },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: nominalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Batas Budget',
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final jumlah = double.tryParse(
                      nominalController.text.replaceAll('.', ''),
                    );

                    if (jumlah == null || jumlah <= 0) {
                      return;
                    }

                    widget.onBudgetChanged(
                      Budget(
                        kategori: kategori,
                        jumlah: jumlah,
                      ),
                    );

                    setState(() {});

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ======================================================
// LAPORAN SCREEN
// ======================================================

class LaporanScreen extends StatelessWidget {
  final List<Transaksi> daftarTransaksi;

  const LaporanScreen({
    super.key,
    required this.daftarTransaksi,
  });

  String formatRupiah(double angka) {
    return 'Rp ${angka.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final transaksiBulanIni = daftarTransaksi.where((item) {
      return item.tanggal.year == now.year &&
          item.tanggal.month == now.month;
    }).toList();

    final double pemasukan = transaksiBulanIni
        .where((item) => item.tipe == 'pemasukan')
        .fold(
          0.0,
          (sum, item) => sum + item.nominal,
        );

    final double pengeluaran = transaksiBulanIni
        .where((item) => item.tipe == 'pengeluaran')
        .fold(
          0.0,
          (sum, item) => sum + item.nominal,
        );

    final double saldo = pemasukan - pengeluaran;

    final double maxValue = pemasukan > pengeluaran
        ? pemasukan
        : pengeluaran;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Laporan Bulan ${now.month}/${now.year}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _summaryRow(
                      'Total Pemasukan',
                      pemasukan,
                      Colors.green,
                    ),
                    const Divider(),
                    _summaryRow(
                      'Total Pengeluaran',
                      pengeluaran,
                      Colors.red,
                    ),
                    const Divider(),
                    _summaryRow(
                      'Saldo',
                      saldo,
                      Colors.blue,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Grafik Pemasukan & Pengeluaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 260,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      _buildBar(
                        'Pemasukan',
                        pemasukan,
                        maxValue,
                        Colors.green,
                      ),
                      _buildBar(
                        'Pengeluaran',
                        pengeluaran,
                        maxValue,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Detail Transaksi Bulan Ini',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (transaksiBulanIni.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Belum ada transaksi bulan ini.',
                    ),
                  ),
                ),
              )
            else
              ...transaksiBulanIni.map(
                (item) {
                  final isIncome =
                      item.tipe == 'pemasukan';

                  return Card(
                    child: ListTile(
                      title: Text(item.judul),
                      subtitle: Text(
                        '${item.kategori} • ${item.tanggal.day}/${item.tanggal.month}/${item.tanggal.year}',
                      ),
                      trailing: Text(
                        '${isIncome ? '+' : '-'} ${formatRupiah(item.nominal)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String title,
    double value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          formatRupiah(value),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBar(
    String label,
    double value,
    double maxValue,
    Color color,
  ) {
    // Semua dibuat DOUBLE agar aman dari error num -> double
    final double tinggi = maxValue <= 0
        ? 0.0
        : ((value / maxValue) * 170).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          formatRupiah(value),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: 70,
          height: tinggi,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(label),
      ],
    );
  }
}