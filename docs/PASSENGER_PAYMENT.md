Saya ingin menyempurnakan frontend pembayaran penumpang TravelTrack tanpa membuat integrasi payment gateway.

Saat ini BookingScreen sudah memiliki pilihan metode pembayaran dan dialog pemesanan berhasil. Ubah alurnya menjadi lebih jelas dan sesuai MVP pembayaran manual.

Sebelum mengubah kode, periksa:

- lib/models/booking_model.dart
- lib/data/dummy_data.dart
- lib/screens/booking_screen.dart
- lib/screens/booking_status_screen.dart
- format harga dan desain kartu yang sudah digunakan

FITUR

1. Buat halaman PaymentConfirmationScreen.
2. Setelah pengguna mengisi data penumpang dan memilih kursi di BookingScreen, tombol lanjutkan harus membuka PaymentConfirmationScreen.
3. PaymentConfirmationScreen menampilkan:
   - operator travel;
   - rute;
   - tanggal dan waktu;
   - nomor kursi;
   - nama penumpang;
   - metode pembayaran;
   - harga tiket;
   - biaya tambahan;
   - total pembayaran.
4. Sediakan metode pembayaran frontend sederhana:
   - Transfer Bank
   - Bayar di Pool
   - Pembayaran manual lainnya yang memang sudah tersedia di project
5. Jangan membuat QRIS nyata atau transaksi e-wallet nyata.
6. Untuk Transfer Bank, tampilkan instruksi pembayaran dummy yang jelas dan diberi label bahwa ini simulasi.
7. Tambahkan checkbox atau persetujuan bahwa pengguna telah memeriksa data booking.
8. Tombol “Buat Pesanan” hanya aktif setelah data valid.
9. Setelah ditekan:
   - simpan booking pada repository lokal yang sudah tersedia;
   - gunakan status awal “Menunggu Konfirmasi”;
   - arahkan pengguna ke BookingStatusScreen;
   - tampilkan pesan berhasil.
10. Pada BookingStatusScreen, tampilkan status pembayaran menggunakan badge:
    - Menunggu Konfirmasi
    - Dikonfirmasi
    - Ditolak
    - Dibatalkan
11. Gunakan tampilan kosong apabila pengguna belum mempunyai booking.
12. Jangan membuat logika konfirmasi admin pada tahap ini.

MODEL DATA

Periksa BookingModel terlebih dahulu.

Apabila belum tersedia, tambahkan field paymentStatus secara minimal.

Gunakan enum sederhana apabila tidak menyebabkan perubahan besar, misalnya:

- pending
- confirmed
- rejected
- cancelled

Pastikan constructor lama tetap kompatibel dengan memberikan nilai default.

STRUKTUR

Buat:

- lib/screens/payment_confirmation_screen.dart

Ubah secara minimal:

- lib/models/booking_model.dart
- lib/screens/booking_screen.dart
- lib/screens/booking_status_screen.dart
- lib/data/dummy_data.dart jika diperlukan
- test terkait booking

BATASAN

- Jangan memasang Firebase.
- Jangan memasang payment gateway.
- Jangan menggunakan API bank, QRIS, atau e-wallet.
- Jangan menghapus metode pembayaran yang sudah ada tanpa alasan.
- Jangan mengubah tampilan halaman lain.
- Jangan membuat arsitektur repository baru karena TravelRepository lokal sudah tersedia.
- Jangan mengubah booking menjadi sistem kompleks.

PENGUJIAN

Pastikan:

- ringkasan pembayaran menampilkan data booking yang benar;
- total pembayaran konsisten;
- tombol tidak aktif sebelum konfirmasi;
- booking baru memiliki status Menunggu Konfirmasi;
- status tampil pada BookingStatusScreen.

Setelah selesai:

- jalankan dart format;
- jalankan flutter analyze;
- jalankan flutter test;
- laporkan seluruh perubahan;
- berhenti dan tunggu persetujuan.