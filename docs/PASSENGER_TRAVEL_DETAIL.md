Saya ingin menambahkan halaman detail travel pada frontend penumpang TravelTrack.

Sebelum mengubah kode, periksa:

- lib/models/travel_model.dart
- lib/data/dummy_data.dart
- lib/screens/home_screen.dart
- lib/screens/travel_list_screen.dart
- lib/screens/booking_screen.dart
- gaya visual kartu travel yang sudah tersedia

Tujuan tahap ini adalah membuat halaman detail perjalanan tanpa mengubah struktur project secara berlebihan.

FITUR

1. Buat TravelDetailScreen yang menerima satu objek TravelModel melalui constructor.
2. Tampilkan informasi yang memang sudah tersedia pada TravelModel, seperti:
   - Nama penyedia travel
   - Jenis kendaraan
   - Nomor polisi
   - Kota asal
   - Kota tujuan
   - Pool asal
   - Pool tujuan
   - Waktu keberangkatan
   - Waktu tiba
   - Harga tiket
   - Jumlah kursi tersedia
   - Rating
   - Nama atau kontak pengemudi jika tersedia
3. Tampilkan ringkasan rute secara visual dan mudah dibaca.
4. Tampilkan informasi fasilitas hanya jika datanya memang tersedia.
5. Jangan membuat informasi fiktif baru di dalam widget.
6. Tambahkan tombol utama “Pilih Kursi”.
7. Tombol tersebut harus membuka BookingScreen dengan objek TravelModel yang sama.
8. Dari TravelListScreen, ketika pengguna menekan kartu atau tombol detail, buka TravelDetailScreen.
9. Pertahankan tombol booking cepat yang sudah ada apabila memang masih dibutuhkan.
10. Pastikan tombol kembali berfungsi.

DESAIN

- Selaraskan dengan Material 3 dan tema TravelTrack.
- Gunakan Theme.of(context).
- Gunakan layout yang sederhana:
  - header operator;
  - kartu rute;
  - informasi kendaraan;
  - informasi harga dan kursi;
  - tombol aksi di bagian bawah.
- Gunakan SafeArea.
- Gunakan scroll agar tidak overflow.
- Tombol “Pilih Kursi” harus mudah ditemukan.
- Hindari animasi atau desain yang terlalu kompleks.

STRUKTUR

Buat:

- lib/screens/travel_detail_screen.dart

File yang boleh diubah secara minimal:

- lib/screens/home_screen.dart
- lib/screens/travel_list_screen.dart
- lib/screens/booking_screen.dart hanya jika constructor perlu disesuaikan
- test/widget_test.dart atau file test baru yang sederhana

Jangan mengubah TravelModel kecuali benar-benar diperlukan.
Apabila model harus diubah, gunakan parameter tambahan yang memiliki nilai default agar kode lama tidak rusak.

BATASAN

- Jangan memasang package baru.
- Jangan menghubungkan Firebase.
- Jangan menghapus data dummy.
- Jangan membuat ulang HomeScreen atau TravelListScreen.
- Jangan mengubah seluruh navigasi aplikasi.
- Jangan membuat arsitektur kompleks.
- Jangan mengimplementasikan Maps atau GPS.

PENGUJIAN

Pastikan melalui widget test bahwa:

- TravelDetailScreen dapat menerima TravelModel;
- nama operator, rute, harga, dan jadwal tampil;
- tombol “Pilih Kursi” tersedia;
- tombol tersebut membuka BookingScreen.

Setelah selesai:

- format kode;
- jalankan flutter analyze;
- jalankan flutter test;
- laporkan file yang dibuat dan diubah;
- berhenti dan tunggu persetujuan.