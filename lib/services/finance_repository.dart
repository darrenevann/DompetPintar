import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/budget.dart';
import '../models/transaksi.dart';

class FinanceData {
  final List<Transaksi> transaksi;
  final List<Budget> anggaran;

  const FinanceData({required this.transaksi, required this.anggaran});
}

class FinanceRepository {
  static const _transactionsKey = 'finance.transactions.v1';
  static const _budgetsKey = 'finance.budgets.v1';

  static final List<Transaksi> _defaultTransactions = [
    Transaksi(
      id: '1',
      judul: 'Gaji Bulanan',
      nominal: 5000000,
      tipe: 'Pemasukan',
      tanggal: DateTime.now(),
      kategori: 'Pemasukan',
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

  static const List<Budget> _defaultBudgets = [
    Budget(kategori: 'Makanan', batas: 2000000),
    Budget(kategori: 'Transportasi', batas: 750000),
    Budget(kategori: 'Hiburan', batas: 1000000),
    Budget(kategori: 'Lainnya', batas: 1000000),
  ];

  Future<FinanceData> load() async {
    final preferences = await SharedPreferences.getInstance();
    final transactionsJson = preferences.getString(_transactionsKey);
    final budgetsJson = preferences.getString(_budgetsKey);

    final transactions = transactionsJson == null
        ? List<Transaksi>.of(_defaultTransactions)
        : _decodeList(transactionsJson, Transaksi.fromJson);
    final budgets = budgetsJson == null
        ? List<Budget>.of(_defaultBudgets)
        : _decodeList(budgetsJson, Budget.fromJson);

    if (transactionsJson == null) {
      await saveTransactions(transactions);
    }
    if (budgetsJson == null) {
      await saveBudgets(budgets);
    }

    return FinanceData(transaksi: transactions, anggaran: budgets);
  }

  Future<void> saveTransactions(List<Transaksi> transactions) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _transactionsKey,
      jsonEncode(transactions.map((transaction) => transaction.toJson()).toList()),
    );
    if (!saved) {
      throw StateError('Transaksi gagal disimpan ke penyimpanan lokal.');
    }
  }

  Future<void> saveBudgets(List<Budget> budgets) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _budgetsKey,
      jsonEncode(budgets.map((budget) => budget.toJson()).toList()),
    );
    if (!saved) {
      throw StateError('Anggaran gagal disimpan ke penyimpanan lokal.');
    }
  }

  List<T> _decodeList<T>(
    String encoded,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Data keuangan tersimpan tidak valid.');
    }

    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Data keuangan tersimpan tidak valid.');
      }
      return fromJson(item);
    }).toList();
  }
}
