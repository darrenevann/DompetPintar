# DompetPintar 👛



**DompetPintar** adalah aplikasi manajemen keuangan pribadi berbasis **Flutter** yang dirancang untuk membantu pengguna mencatatkan transaksi harian, mengelola anggaran (*budgeting*), serta menganalisis laporan keuangan secara visual dengan antarmuka kustom bergaya *Neo-Brutalist UI*.



## 🌟 Fitur Utama



* 📊 **Dashboard Keuangan**: Menampilkan ringkasan saldo, total pemasukan, total pengeluaran, serta daftar transaksi terbaru.

* 💸 **Pencatatan Transaksi**: Fitur pencatatan dan pengelolaan riwayat pemasukan dan pengeluaran uang.

* 🎯 **Manajemen Budget (Anggaran)**: Pengaturan serta pemantauan batas anggaran per kategori agar keuangan tetap teratur.

* 📈 **Laporan & Statistik**: Rekapitulasi visual pengeluaran dan pemasukan untuk memantau kebiasaan finansial.

* 🎨 **Neo-Brutalist UI Design**: Tampilan antarmuka yang unik, tegas, dan modern menggunakan komponen kustom seperti `BrutalistCard`.

* 🇮🇩 **Format Rupiah Otomatis**: Formatter bawaan untuk mengonversi nilai angka langsung ke format mata uang Rupiah (`Rp`).



## 🛠️ Teknologi yang Digunakan



* **Framework**: [Flutter](https://flutter.dev/) (Dart)

* **Target Platform**: Android, iOS

* **State & Data Management**: Custom Repository (`finance_repository.dart`)

* **UI Style**: Custom Neo-Brutalist Components



## 📂 Struktur Proyek



```

lib/

├── main.dart                 # Entry point utama aplikasi

├── models/                   # Model data

│   ├── budget.dart           # Model data anggaran/budget

│   └── transaksi.dart        # Model data transaksi

├── screens/                  # Tampilan halaman/layar

│   ├── main_screen.dart      # Wadah navigasi utama

│   ├── dashboard_screen.dart # Halaman ringkasan dashboard

│   ├── transaksi_screen.dart # Halaman kelola transaksi

│   ├── budget_screen.dart    # Halaman manajemen budget

│   └── laporan_screen.dart   # Halaman laporan & analisis keuangan

├── services/                 # Layer penyimpanan & logika bisnis

│   └── finance_repository.dart # Repository pengelolaan data keuangan

├── utils/                    # Helper & utility

│   └── format_rupiah.dart    # Fungsi pengubah format mata uang IDR

└── widgets/                  # Komponen UI yang dapat digunakan kembali

    ├── app_header.dart       # Widget header kustom

    └── brutalist_card.dart   # Widget card bertema Brutalist UI

```



## 🚀 Cara Menjalankan Aplikasi



### 1. Prasyarat (*Prerequisites*)



Pastikan perangkat Anda sudah terpasang:

* **Flutter SDK** (versi 3.0.0 atau lebih baru)

* **Dart SDK**

* **Android Studio** atau **VS Code** (dengan ekstensi Flutter & Dart)

* Emulator Android / iOS atau Browser Chrome (untuk target Web)



### 2. Langkah Instalasi & Jalankan



1. **Clone Repositori**:

   ```bash

   git clone https://github.com/username/DompetPintar.git

   cd DompetPintar

   ```



2. **Unduh Dependensi**:

   Jalankan perintah berikut pada terminal untuk mengunduh seluruh library yang dibutuhkan:

   ```bash

   flutter pub get

   ```



3. **Jalankan Aplikasi**:

   Pilih emulator atau perangkat fisik yang terhubung, lalu jalankan:

   ```bash

   flutter run

   ```



   *Untuk menjalankan di Google Chrome (Web):*

   ```bash

   flutter run -d chrome

   ```



## 🧪 Menjalankan Pengujian (Testing)



Untuk menjalankan unit test/widget test bawaan:

```bash

flutter test

```



## 📝 Lisensi & Kredit



Dikembangkan sebagai proyek UTS Mata Kuliah Mobile Programming

Darren Evan Nathanael | Ryan Alvino | I Made Wijaya Kesuma