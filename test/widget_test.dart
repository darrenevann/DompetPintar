import 'package:dompetpintar/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('klik ikon search membuka dan fokus pada search bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DompetPintarApp());

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
    await tester.pumpWidget(const DompetPintarApp());

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
    expect(find.text('Transaksi berhasil ditambahkan.'), findsOneWidget);
  });

  testWidgets('double click transaksi menampilkan detail transaksi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DompetPintarApp());

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
      await tester.pumpWidget(const DompetPintarApp());

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
}
