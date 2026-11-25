import argparse
import json
import math
import sqlite3
from contextlib import closing
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import unquote, urlsplit


def buka_database():
    koneksi = sqlite3.connect(lokasi_database)
    koneksi.row_factory = sqlite3.Row
    return koneksi


def siapkan_database():
    with closing(buka_database()) as koneksi, koneksi:
        koneksi.execute("BEGIN")
        tabel_sudah_ada = koneksi.execute(
            "SELECT name FROM sqlite_master WHERE name = 'transaksi'"
        ).fetchone()
        koneksi.execute("""
            CREATE TABLE IF NOT EXISTS transaksi (
                id TEXT PRIMARY KEY,
                judul TEXT NOT NULL,
                nominal REAL NOT NULL CHECK (nominal > 0),
                tipe TEXT NOT NULL CHECK (tipe IN ('Pemasukan', 'Pengeluaran')),
                tanggal TEXT NOT NULL,
                kategori TEXT NOT NULL
            )
        """)
        koneksi.execute("""
            CREATE TABLE IF NOT EXISTS anggaran (
                kategori TEXT PRIMARY KEY,
                batas REAL NOT NULL CHECK (batas > 0)
            )
        """)
        if not tabel_sudah_ada:
            sekarang = datetime.now().isoformat()
            koneksi.executemany(
                "INSERT INTO transaksi VALUES (?, ?, ?, ?, ?, ?)",
                [
                    ('1', 'Gaji Bulanan', 5000000, 'Pemasukan', sekarang, 'Pemasukan'),
                    ('2', 'Makan Siang', 50000, 'Pengeluaran', sekarang, 'Makanan'),
                    ('3', 'Beli Kuota', 100000, 'Pengeluaran', sekarang, 'Lainnya'),
                ],
            )
            koneksi.executemany(
                "INSERT INTO anggaran VALUES (?, ?)",
                [('Makanan', 2000000), ('Transportasi', 750000),
                 ('Hiburan', 1000000), ('Lainnya', 1000000)],
            )


def teks_valid(data, nama):
    nilai = data.get(nama)
    if not isinstance(nilai, str) or not nilai.strip():
        raise ValueError(f'{nama.capitalize()} wajib diisi.')
    return nilai.strip()


def nominal_valid(data, nama):
    nilai = data.get(nama)
    if type(nilai) not in (int, float) or not (0 < nilai <= 1e308) or not math.isfinite(nilai):
        raise ValueError(f'{nama.capitalize()} harus lebih dari nol.')
    return nilai


class ApiDompet(BaseHTTPRequestHandler):
    def kirim_json(self, status, data=None):
        isi = json.dumps(data).encode('utf-8') if data is not None else b''
        self.send_response(status)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Content-Length', str(len(isi)))
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
        self.wfile.write(isi)

    def baca_json(self):
        panjang = int(self.headers.get('Content-Length', 0))
        if not 0 < panjang <= 16384:
            raise ValueError('Ukuran data tidak valid.')
        try:
            data = json.loads(self.rfile.read(panjang))
        except (json.JSONDecodeError, UnicodeError):
            raise ValueError('Format JSON tidak valid.')
        if not isinstance(data, dict):
            raise ValueError('Data harus berupa objek JSON.')
        return data

    def do_OPTIONS(self):
        self.kirim_json(204)

    def do_GET(self):
        self.layani()

    do_POST = do_GET
    do_PUT = do_GET
    do_DELETE = do_GET

    def layani(self):
        bagian = [unquote(b) for b in urlsplit(self.path).path.strip('/').split('/')]
        try:
            with closing(buka_database()) as koneksi, koneksi:
                status, data = self.proses(koneksi, bagian)
        except ValueError as error:
            status, data = 400, {'pesan': str(error)}
        except sqlite3.Error:
            status, data = 500, {'pesan': 'Database gagal diakses.'}
        self.kirim_json(status, data)

    def proses(self, koneksi, bagian):
        if bagian == ['transaksi'] and self.command == 'GET':
            baris = koneksi.execute('SELECT * FROM transaksi ORDER BY tanggal DESC')
            return 200, [dict(item) for item in baris]

        if bagian == ['anggaran'] and self.command == 'GET':
            baris = koneksi.execute('SELECT * FROM anggaran ORDER BY rowid')
            return 200, [dict(item) for item in baris]

        if bagian == ['transaksi'] and self.command == 'POST':
            data = self.baca_json()
            id_transaksi = teks_valid(data, 'id')
            koneksi.execute(
                'INSERT INTO transaksi VALUES (?, ?, ?, ?, ?, ?) ON CONFLICT(id) DO NOTHING',
                (id_transaksi, *self.detail_transaksi(data)),
            )
            baris = koneksi.execute('SELECT * FROM transaksi WHERE id = ?', (id_transaksi,))
            return 201, dict(baris.fetchone())

        if len(bagian) == 2 and bagian[0] == 'transaksi':
            id_transaksi = bagian[1]
            if self.command == 'PUT':
                detail = self.detail_transaksi(self.baca_json())
                hasil = koneksi.execute(
                    'UPDATE transaksi SET judul = ?, nominal = ?, tipe = ?, tanggal = ?, '
                    'kategori = ? WHERE id = ?', (*detail, id_transaksi),
                )
                if hasil.rowcount:
                    return 200, dict(zip(
                        ('id', 'judul', 'nominal', 'tipe', 'tanggal', 'kategori'),
                        (id_transaksi, *detail),
                    ))
            if self.command == 'DELETE':
                koneksi.execute('DELETE FROM transaksi WHERE id = ?', (id_transaksi,))
                return 204, None

        if len(bagian) == 2 and bagian[0] == 'anggaran' and self.command == 'PUT':
            kategori = bagian[1]
            batas = nominal_valid(self.baca_json(), 'batas')
            hasil = koneksi.execute(
                'UPDATE anggaran SET batas = ? WHERE kategori = ?', (batas, kategori),
            )
            if hasil.rowcount:
                return 200, {'kategori': kategori, 'batas': batas}

        return 404, {'pesan': 'Data atau alamat API tidak ditemukan.'}

    def detail_transaksi(self, data):
        judul = teks_valid(data, 'judul')
        nominal = nominal_valid(data, 'nominal')
        tipe = teks_valid(data, 'tipe')
        tanggal = teks_valid(data, 'tanggal')
        kategori = teks_valid(data, 'kategori')
        if tipe not in ('Pemasukan', 'Pengeluaran'):
            raise ValueError('Tipe transaksi tidak valid.')
        try:
            datetime.fromisoformat(tanggal)
        except ValueError:
            raise ValueError('Tanggal transaksi tidak valid.')
        return judul, nominal, tipe, tanggal, kategori


if __name__ == '__main__':
    argumen = argparse.ArgumentParser()
    argumen.add_argument('--host', default='127.0.0.1')
    argumen.add_argument('--port', type=int, default=8000)
    argumen.add_argument('--database', type=Path, default=Path(__file__).with_name('dompet_pintar.db'))
    pilihan = argumen.parse_args()
    lokasi_database = pilihan.database
    siapkan_database()
    with ThreadingHTTPServer((pilihan.host, pilihan.port), ApiDompet) as server:
        print(f'API DompetPintar berjalan di http://{pilihan.host}:{pilihan.port}', flush=True)
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            pass
