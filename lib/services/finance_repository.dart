import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/budget.dart';
import '../models/transaksi.dart';

class FinanceData {
  final List<Transaksi> transaksi;
  final List<Budget> anggaran;

  const FinanceData({required this.transaksi, required this.anggaran});
}

class FinanceRepository {
  static const _alamatApi = String.fromEnvironment('API_URL');
  static const _waktuTunggu = Duration(seconds: 8);
  static const _headerJson = {'Content-Type': 'application/json'};

  final http.Client _client;

  FinanceRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _alamat(String jalur) {
    final alamat = _alamatApi.isNotEmpty
        ? _alamatApi
        : !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8000'
        : 'http://127.0.0.1:8000';
    return Uri.parse('${alamat.replaceFirst(RegExp(r'/+$'), '')}/$jalur');
  }

  Future<FinanceData> load() async {
    final respons = await Future.wait([
      _client.get(_alamat('transaksi')).timeout(_waktuTunggu),
      _client.get(_alamat('anggaran')).timeout(_waktuTunggu),
    ]);
    final transaksi =
        (_bacaRespons(respons[0]) as List)
            .map((item) => Transaksi.fromJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
    final anggaran = (_bacaRespons(respons[1]) as List)
        .map((item) => Budget.fromJson(item as Map<String, dynamic>))
        .toList();
    return FinanceData(transaksi: transaksi, anggaran: anggaran);
  }

  Future<Transaksi> simpanTransaksi(
    Transaksi transaksi, {
    required bool edit,
  }) async {
    final isi = jsonEncode(transaksi.toJson());
    final respons = edit
        ? await _client
              .put(
                _alamat('transaksi/${Uri.encodeComponent(transaksi.id)}'),
                headers: _headerJson,
                body: isi,
              )
              .timeout(_waktuTunggu)
        : await _client
              .post(_alamat('transaksi'), headers: _headerJson, body: isi)
              .timeout(_waktuTunggu);
    return Transaksi.fromJson(_bacaRespons(respons) as Map<String, dynamic>);
  }

  Future<void> hapusTransaksi(String id) async {
    final respons = await _client
        .delete(_alamat('transaksi/${Uri.encodeComponent(id)}'))
        .timeout(_waktuTunggu);
    _bacaRespons(respons);
  }

  Future<Budget> simpanAnggaran(Budget budget) async {
    final respons = await _client
        .put(
          _alamat('anggaran/${Uri.encodeComponent(budget.kategori)}'),
          headers: _headerJson,
          body: jsonEncode(budget.toJson()),
        )
        .timeout(_waktuTunggu);
    return Budget.fromJson(_bacaRespons(respons) as Map<String, dynamic>);
  }

  dynamic _bacaRespons(http.Response respons) {
    if (respons.statusCode == 204) return null;
    final data = jsonDecode(utf8.decode(respons.bodyBytes));
    if (respons.statusCode < 200 || respons.statusCode >= 300) {
      throw Exception(data is Map ? data['pesan'] : 'Permintaan API gagal.');
    }
    return data;
  }

  void tutup() => _client.close();
}
