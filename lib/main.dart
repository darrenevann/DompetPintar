import 'package:flutter/material.dart';

import 'screens/main_screen.dart';

export 'utils/format_rupiah.dart' show formatRupiah;

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
