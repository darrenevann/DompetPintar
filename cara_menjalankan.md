# Menjalankan DompetPintar

Jalankan perintah dari folder `DompetPintar`. Siapkan Python 3.10 atau yang lebih baru dan Flutter.

1. Buka terminal pertama dan jalankan `python server_dompet.py`. Server membuat `dompet_pintar.db` berisi transaksi contoh dan batas anggaran saat pertama kali dijalankan.
2. Buka terminal kedua, jalankan `flutter pub get`, lalu `flutter run`. Emulator Android memakai `10.0.2.2:8000`. Windows dan Chrome di komputer yang sama memakai `127.0.0.1:8000`.
3. Untuk HP Android, jalankan server dengan `python server_dompet.py --host 0.0.0.0` di jaringan lokal. Hubungkan HP ke Wi-Fi yang sama dan jalankan `flutter run --dart-define=API_URL=http://192.168.1.10:8000` dengan mengganti IP tersebut memakai IP komputer.

Tombol tambah mencatat transaksi baru. Ketuk dua kali kartu transaksi untuk membuka detail dan memilih Edit atau Hapus. Di halaman Budget, tekan ikon pensil pada kategori untuk mengganti batas anggaran.

| Metode | Alamat | Kegunaan |
| --- | --- | --- |
| GET | `/transaksi` | Menampilkan daftar transaksi |
| POST | `/transaksi` | Menambah transaksi |
| PUT | `/transaksi/{id}` | Mengubah transaksi |
| DELETE | `/transaksi/{id}` | Menghapus transaksi |
| GET | `/anggaran` | Menampilkan daftar kategori dan batas anggaran |
| PUT | `/anggaran/{kategori}` | Mengubah batas pada kategori yang tersedia |

Dashboard dan Laporan menghitung ringkasan dari data API. Perubahan disimpan di SQLite. Riwayat SharedPreferences dari versi UTS belum diimpor ke database UAS.
