import 'dart:convert';

import 'package:dompetpintar/main.dart';
import 'package:dompetpintar/models/transaksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late MockClient client;
  late List<Map<String, dynamic>> transaksi;
  late Map<String, num> anggaran;

  setUp(() {
    final tanggal = DateTime.now().toIso8601String();
    transaksi = [
      {
        'id': '1',
        'judul': 'Gaji Bulanan',
        'nominal': 5000000,
        'tipe': 'Pemasukan',
        'tanggal': tanggal,
        'kategori': 'Pemasukan',
      },
      {
        'id': '2',
        'judul': 'Makan Siang',
        'nominal': 50000,
        'tipe': 'Pengeluaran',
        'tanggal': tanggal,
        'kategori': 'Makanan',
      },
      {
        'id': '3',
        'judul': 'Beli Kuota',
        'nominal': 100000,
        'tipe': 'Pengeluaran',
        'tanggal': tanggal,
        'kategori': 'Lainnya',
      },
    ];
    anggaran = {'Makanan': 2000000, 'Transportasi': 750000};

    client = MockClient((permintaan) async {
      final jalur = permintaan.url.pathSegments;
      if (permintaan.method == 'GET' && jalur.first == 'transaksi') {
        return http.Response(jsonEncode(transaksi), 200);
      }
      if (permintaan.method == 'GET' && jalur.first == 'anggaran') {
        return http.Response(
          jsonEncode([
            for (final item in anggaran.entries)
              {'kategori': item.key, 'batas': item.value},
          ]),
          200,
        );
      }
      if (permintaan.method == 'POST' && jalur.first == 'transaksi') {
        transaksi.add(jsonDecode(permintaan.body) as Map<String, dynamic>);
        return http.Response(permintaan.body, 201);
      }
      if (permintaan.method == 'PUT' && jalur.first == 'transaksi') {
        final index = transaksi.indexWhere((item) => item['id'] == jalur.last);
        transaksi[index] = jsonDecode(permintaan.body) as Map<String, dynamic>;
        return http.Response(permintaan.body, 200);
      }
      if (permintaan.method == 'DELETE' && jalur.first == 'transaksi') {
        transaksi.removeWhere((item) => item['id'] == jalur.last);
        return http.Response('', 204);
      }
      if (permintaan.method == 'PUT' && jalur.first == 'anggaran') {
        anggaran[jalur.last] = jsonDecode(permintaan.body)['batas'] as num;
        return http.Response(permintaan.body, 200);
      }
      return http.Response('{"pesan":"Data tidak ditemukan."}', 404);
    });
  });

  testWidgets('klik ikon search membuka dan fokus pada search bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(DompetPintarApp(client: client));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).focusNode,
      isNotNull,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus,
      isTrue,
    );
  });

  testWidgets('tombol tambah dapat menyimpan transaksi baru', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(DompetPintarApp(client: client));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('judul')), 'Bonus Proyek');
    await tester.enterText(find.byKey(const ValueKey('nominal')), '750000');
    await tester.tap(find.byKey(const ValueKey('tipe')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pemasukan').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Bonus Proyek'), findsOneWidget);
    expect(find.text('Rp. 750.000,00'), findsWidgets);
    expect(find.text('Rp. 5.750.000,00'), findsOneWidget);
    expect(find.text('Transaksi berhasil ditambahkan.'), findsOneWidget);
  });

  testWidgets('double click transaksi menampilkan detail transaksi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(DompetPintarApp(client: client));
    await tester.pumpAndSettle();

    final transaksiCard = find.byKey(const ValueKey('transaksi-1'));

    await tester.ensureVisible(transaksiCard);
    await tester.pumpAndSettle();
    await tester.tap(transaksiCard);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(transaksiCard);
    await tester.pumpAndSettle();

    expect(find.text('Detail Transaksi'), findsOneWidget);
    expect(find.text('Gaji Bulanan'), findsWidgets);
    expect(find.text('Pemasukan'), findsWidgets);
    expect(find.text('Rp. 5.000.000,00'), findsWidgets);
  });

  testWidgets(
    'total saldo dapat disembunyikan dan ditampilkan dengan mata atau long press',
    (WidgetTester tester) async {
      await tester.pumpWidget(DompetPintarApp(client: client));
      await tester.pumpAndSettle();

      expect(find.text('****'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('toggle-saldo')));
      await tester.pumpAndSettle();

      expect(find.text('Rp. 15.000.000,00'), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      await tester.longPress(find.byKey(const ValueKey('saldo-kolom')));
      await tester.pumpAndSettle();

      expect(find.text('****'), findsOneWidget);
    },
  );

  test('format rupiah menggunakan titik sebagai pemisah ribuan', () {
    expect(formatRupiah(100000), 'Rp. 100.000,00');
    expect(formatRupiah(5000000), 'Rp. 5.000.000,00');
  });

  test(
    'kategori transaksi tidak mencocokkan kata sebagai potongan sembarang',
    () {
      expect(Transaksi.kategoriDariJudul('Makan Siang'), 'Makanan');
      expect(Transaksi.kategoriDariJudul('Bayar Tol'), 'Transportasi');
      expect(Transaksi.kategoriDariJudul('Toleransi layanan'), 'Lainnya');
    },
  );

  testWidgets('transaksi pengeluaran menyambungkan dashboard budget dan API', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(DompetPintarApp(client: client));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('judul')), 'Makan Malam');
    await tester.enterText(find.byKey(const ValueKey('nominal')), '250.000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Rp. 400.000,00'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('toggle-saldo')));
    await tester.pumpAndSettle();
    expect(find.text('Rp. 14.750.000,00'), findsOneWidget);

    await tester.tap(find.text('Budget').last);
    await tester.pumpAndSettle();
    expect(find.text('Rp. 300.000,00 / Rp. 2.000.000,00'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(DompetPintarApp(client: client));
    await tester.pumpAndSettle();
    expect(find.text('Makan Malam'), findsOneWidget);
    expect(find.text('Rp. 400.000,00'), findsOneWidget);
  });

  testWidgets('transaksi menolak nominal tidak valid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(DompetPintarApp(client: client));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('judul')), 'Invalid');
    await tester.enterText(find.byKey(const ValueKey('nominal')), '1.2.3');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Tambah'));
    await tester.pumpAndSettle();

    expect(
      find.text('Judul dan nominal transaksi harus valid.'),
      findsOneWidget,
    );
    expect(find.text('Invalid'), findsOneWidget);
  });

  testWidgets('edit transaksi, hapus transaksi, dan edit anggaran lewat API', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(DompetPintarApp(client: client));
    await tester.pumpAndSettle();

    final kartu = find.byKey(const ValueKey('transaksi-1'));
    await tester.ensureVisible(kartu);
    await tester.tap(kartu);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(kartu);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('judul')), 'Gaji Baru');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(transaksi.first['judul'], 'Gaji Baru');

    await tester.ensureVisible(kartu);
    await tester.tap(kartu);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(kartu);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(transaksi.any((item) => item['id'] == '1'), isFalse);

    await tester.tap(find.text('Budget').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit anggaran Makanan'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '500.000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(anggaran['Makanan'], 500000);
    expect(find.text('Rp. 50.000,00 / Rp. 500.000,00'), findsOneWidget);
  });
}
