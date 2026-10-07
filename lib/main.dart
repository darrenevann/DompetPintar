import 'package:flutter/material.dart';

void main() {
  runApp(const DompetPintarApp());
}

// main app
class DompetPintarApp extends StatelessWidget {
  const DompetPintarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dompet Pintar',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// model transaksi
class Transaksi {
  final String id;
  final String judul;
  final double nominal;
  final String tipe;
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

// widget brutalist card
class BrutalistCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;

  const BrutalistCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

// main screen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // state
  int _selectedIndex = 0;

  // data transaksi
  final List<Transaksi> _daftarTransaksi = [
    Transaksi(
      id: '1',
      judul: 'Gaji Bulanan',
      nominal: 5000000,
      tipe: 'Pemasukan',
      kategori: 'Lainnya',
      tanggal: DateTime.now(),
    ),
    Transaksi(
      id: '2',
      judul: 'Makan Siang',
      nominal: 50000,
      tipe: 'Pengeluaran',
      kategori: 'Makanan',
      tanggal: DateTime.now(),
    ),
    Transaksi(
      id: '3',
      judul: 'Beli Kuota',
      nominal: 100000,
      tipe: 'Pengeluaran',
      kategori: 'Lainnya',
      tanggal: DateTime.now(),
    ),
  ];

  // navigasi fungsi
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // fungsi tambah transaksi
  void _tambahTransaksi() {
    final TextEditingController judulController = TextEditingController();
    final TextEditingController nominalController = TextEditingController();

    String tipeDipilih = 'Pengeluaran';
    String kategoriDipilih = 'Makanan';
    DateTime tanggalDipilih = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Tambah Transaksi',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Transaksi',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nominal',
                        prefixText: 'Rp ',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: tipeDipilih,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Transaksi',
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
                        setDialogState(() {
                          tipeDipilih = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: kategoriDipilih,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Makanan',
                          child: Text('Makanan'),
                        ),
                        DropdownMenuItem(
                          value: 'Transportasi',
                          child: Text('Transportasi'),
                        ),
                        DropdownMenuItem(
                          value: 'Hiburan',
                          child: Text('Hiburan'),
                        ),
                        DropdownMenuItem(
                          value: 'Belanja',
                          child: Text('Belanja'),
                        ),
                        DropdownMenuItem(
                          value: 'Lainnya',
                          child: Text('Lainnya'),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          kategoriDipilih = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${tanggalDipilih.day}/${tanggalDipilih.month}/${tanggalDipilih.year}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? tanggalBaru =
                                await showDatePicker(
                              context: context,
                              initialDate: tanggalDipilih,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );

                            if (tanggalBaru != null) {
                              setDialogState(() {
                                tanggalDipilih = tanggalBaru;
                              });
                            }
                          },
                          child: const Text('Pilih Tanggal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (judulController.text.isEmpty ||
                        nominalController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nama dan nominal harus diisi.',
                          ),
                        ),
                      );
                      return;
                    }

                    final double? nominal =
                        double.tryParse(nominalController.text);

                    if (nominal == null || nominal <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nominal harus berupa angka.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _daftarTransaksi.add(
                        Transaksi(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          judul: judulController.text,
                          nominal: nominal,
                          tipe: tipeDipilih,
                          kategori: kategoriDipilih,
                          tanggal: tanggalDipilih,
                        ),
                      );
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Transaksi berhasil ditambahkan.',
                        ),
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
    final List<Widget> _halaman = [
      DashboardScreen(daftarTransaksi: _daftarTransaksi),
      TransaksiScreen(daftarTransaksi: _daftarTransaksi),
      const BudgetScreen(),
      const LaporanScreen(),
    ];

    return Scaffold(
      // body
      body: SafeArea(
        child: _halaman[_selectedIndex],
      ),

      // floating button
      floatingActionButton: BrutalistCard(
        backgroundColor: const Color(0xFFFFD166),
        padding: const EdgeInsets.all(0),
        width: 60,
        height: 60,
        child: IconButton(
          onPressed: _tambahTransaksi,
          icon: const Icon(
            Icons.add,
            size: 32,
            color: Colors.black,
          ),
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // navigasi bawah
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 3,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFFAF9F6),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
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
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// halaman dashboard
class DashboardScreen extends StatelessWidget {
  final List<Transaksi> daftarTransaksi;

  const DashboardScreen({
    super.key,
    required this.daftarTransaksi,
  });

  @override
  Widget build(BuildContext context) {
    // Menghitung total statis
    double totalSaldo = 15000000;
    double totalPemasukan = 5000000;
    double totalPengeluaran = 150000;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // app bar custom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BrutalistCard(
                backgroundColor: Color(0xFFFFD166),
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  "DompetPintar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Row(
                children: const [
                  BrutalistCard(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.settings,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  BrutalistCard(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.search,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // header saldo
          const Text(
            "Saldo Anda.\nKelola sekarang.",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),

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
                Text(
                  "Rp ${totalSaldo.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
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
                  backgroundColor: const Color(0xFFB5E48C),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        size: 28,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Pemasukan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp ${totalPemasukan.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BrutalistCard(
                  backgroundColor: const Color(0xFFFF9E9E),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        size: 28,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Pengeluaran",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp ${totalPengeluaran.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // daftar transaksi
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daftarTransaksi.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final trx = daftarTransaksi[index];

              return BrutalistCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    BrutalistCard(
                      backgroundColor:
                          trx.tipe == 'Pemasukan'
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
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            trx.judul,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${trx.tipe} • ${trx.kategori}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Rp ${trx.nominal.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// halaman transaksi
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
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text(
            "Riwayat.\nCek uangmu.",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // baris filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            itemCount: dataTampil.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final trx = dataTampil[index];

              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Detail: ${trx.judul}',
                      ),
                    ),
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
                        backgroundColor:
                            trx.tipe == 'Pemasukan'
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
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                              '${trx.tanggal.day}/${trx.tanggal.month}/${trx.tanggal.year}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trx.kategori,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Rp ${trx.nominal.toStringAsFixed(0)}",
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
        backgroundColor:
            isAktif ? const Color(0xFFFFD166) : Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

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
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text(
            "Anggaran.\nKendalikan uangmu.",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // daftar budget
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            itemCount: daftarBudget.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final budget = daftarBudget[index];

              final double rasio =
                  (budget['terpakai'] / budget['total'])
                      .clamp(0.0, 1.0);

              return BrutalistCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          budget['kategori'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Rp ${budget['terpakai']} / Rp ${budget['total']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double maxWidth =
                            constraints.maxWidth;

                        return Stack(
                          children: [
                            Container(
                              height: 24,
                              width: maxWidth,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                height: 24,
                                width: maxWidth * rasio,
                                decoration: BoxDecoration(
                                  color: budget['warna'],
                                  borderRadius:
                                      BorderRadius.circular(12),
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
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text(
            "Laporan.\nAnalisis finansialmu.",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // card grafik
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: BrutalistCard(
            height: 300,
            child: Column(
              children: [
                const Text(
                  "Pengeluaran 6 Bulan Terakhir",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const Spacer(),

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: dataGrafik.map((data) {
                    return Column(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 32,
                          height:
                              (180 * data['nilai']).toDouble(),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB5E48C),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius:
                                const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

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