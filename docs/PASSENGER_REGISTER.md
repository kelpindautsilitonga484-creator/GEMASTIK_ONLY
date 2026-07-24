Saya ingin menambahkan frontend registrasi penumpang pada project TravelTrack yang sudah ada.

Sebelum melakukan perubahan, periksa terlebih dahulu:

- lib/main.dart
- lib/screens/login_screen.dart
- tema, warna, bentuk tombol, input field, spacing, dan tipografi yang digunakan project
- pola navigasi yang sudah digunakan

Bangun fitur registrasi penumpang dengan ketentuan berikut.

FITUR

1. Buat halaman RegisterScreen.
2. Form registrasi memiliki field:
   - Nama lengkap
   - Email
   - Nomor telepon
   - Password
   - Konfirmasi password
3. Tambahkan validasi:
   - Semua field wajib diisi.
   - Email harus memiliki format yang benar.
   - Nomor telepon hanya menerima angka dan memiliki panjang yang wajar.
   - Password minimal 6 karakter.
   - Konfirmasi password harus sama dengan password.
4. Tambahkan tombol tampilkan/sembunyikan password.
5. Tambahkan indikator loading pada tombol daftar.
6. Setelah simulasi registrasi berhasil:
   - tampilkan SnackBar atau dialog keberhasilan;
   - arahkan pengguna kembali ke halaman login.
7. Tambahkan tautan “Belum punya akun? Daftar” pada LoginScreen.
8. Pada halaman registrasi, tambahkan tautan “Sudah punya akun? Masuk”.

DESAIN

- Gunakan tema Material 3 yang sudah digunakan project.
- Gunakan Theme.of(context), jangan mengulang hardcoded warna di banyak tempat.
- Pertahankan identitas visual TravelTrack.
- Gunakan warna utama, card style, input style, radius, shadow, dan spacing yang selaras dengan LoginScreen.
- Pastikan tampilan tidak overflow pada layar Android kecil.
- Gunakan SingleChildScrollView agar form tetap dapat digunakan ketika keyboard terbuka.
- Gunakan SafeArea.

STRUKTUR

Buat hanya file yang benar-benar diperlukan:

- lib/screens/register_screen.dart

File yang boleh diubah:

- lib/screens/login_screen.dart
- test/widget_test.dart jika perlu menambahkan atau menyesuaikan test

Jangan memindahkan seluruh struktur folder.
Jangan membuat Clean Architecture.
Jangan membuat repository, use case, dependency injection, atau state management kompleks.
Gunakan StatefulWidget dan setState apabila sudah cukup.

BATASAN

- Frontend saja.
- Jangan memasang Firebase.
- Jangan menyimpan password secara lokal.
- Jangan menambahkan package baru.
- Jangan mengubah halaman lain.
- Jangan mengubah login yang sudah berfungsi selain menambahkan navigasi ke registrasi.
- Jangan menghapus fitur yang sudah ada.

PENGUJIAN

Tambahkan atau sesuaikan widget test untuk memastikan:

- halaman registrasi dapat dibuka dari LoginScreen;
- validasi muncul ketika form kosong;
- password yang berbeda ditolak;
- tombol kembali ke login berfungsi.

Setelah implementasi:

1. Jalankan dart format lib test.
2. Jalankan flutter analyze.
3. Jalankan flutter test.
4. Laporkan file yang dibuat dan diubah.
5. Laporkan hasil analyze dan test.
6. Jelaskan apakah ada perubahan perilaku pada halaman lama.

Berhenti setelah fitur registrasi selesai. Jangan mengerjakan fitur lain.