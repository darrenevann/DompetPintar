import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screens/main_screen.dart';

export 'utils/format_rupiah.dart' show formatRupiah;

void main() {
  runApp(const DompetPintarApp());
}

// main app
class DompetPintarApp extends StatelessWidget {
  final http.Client? client;

  const DompetPintarApp({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dompet Pintar',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        fontFamily: 'Roboto',
      ),
      home: MainScreen(client: client),
      debugShowCheckedModeBanner: false,
    );
  }
}
