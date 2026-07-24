Saya ingin meningkatkan kualitas frontend penumpang TravelTrack dengan kondisi loading, empty state, error state, dan validasi yang konsisten.

Jangan mengubah fungsi utama atau desain besar aplikasi.

Sebelum mengubah kode, periksa:

- lib/screens/home_screen.dart
- lib/screens/travel_list_screen.dart
- lib/screens/booking_screen.dart
- lib/screens/booking_status_screen.dart
- lib/screens/profile_screen.dart jika sudah tersedia
- pola warna, card, icon, dan button yang digunakan

TUJUAN

Membuat pengalaman pengguna tetap jelas ketika:

- data sedang dimuat;
- pencarian tidak menemukan jadwal;
- pengguna belum mempunyai tiket;
- data gagal dimuat;
- form belum lengkap;
- tombol sedang memproses data.

FITUR

1. Buat reusable widget sederhana untuk kondisi halaman.
2. Widget harus mendukung:
   - loading
   - empty
   - error
3. Empty state memiliki:
   - icon;
   - judul;
   - deskripsi;
   - tombol aksi opsional.
4. Error state memiliki tombol “Coba Lagi”.
5. Loading state menggunakan CircularProgressIndicator yang selaras dengan tema.
6. Terapkan secara minimal pada:
   - TravelListScreen
   - BookingStatusScreen
7. Pada TravelListScreen:
   - tampilkan empty state ketika filter atau pencarian tidak menghasilkan data;
   - sediakan tombol reset filter.
8. Pada BookingStatusScreen:
   - tampilkan empty state ketika tidak ada tiket aktif;
   - tampilkan empty state terpisah ketika belum ada riwayat.
9. Pada form booking:
   - tampilkan pesan validasi dekat field terkait;
   - cegah double tap ketika proses booking berlangsung;
   - tampilkan loading pada tombol.
10. Gunakan mounted check setelah operasi asynchronous sebelum memakai context atau setState.
11. Pastikan semua controller dan resource yang dibuat di-dispose.

STRUKTUR

Buat maksimal:

- lib/widgets/app_state_view.dart

Jangan membuat banyak file widget kecil yang tidak diperlukan.

File yang boleh diubah:

- lib/screens/travel_list_screen.dart
- lib/screens/booking_screen.dart
- lib/screens/booking_status_screen.dart
- test terkait

DESAIN

- Gunakan Theme.of(context).
- Gunakan warna dan icon yang konsisten.
- Jangan mengubah keseluruhan layout.
- Jangan menggunakan ilustrasi atau asset baru.
- Pastikan responsive pada layar kecil.

BATASAN

- Jangan memasang package baru.
- Jangan menghubungkan Firebase.
- Jangan mengubah model data.
- Jangan mengubah struktur navigasi.
- Jangan membuat state management kompleks.
- Jangan menghapus fitur.
- Jangan melakukan refactor besar pada file yang tidak berkaitan.

PENGUJIAN

Tambahkan test sederhana untuk:

- empty state pencarian;
- reset filter;
- empty state tiket;
- tombol booking tidak dapat ditekan berulang saat loading.

Setelah selesai:

1. Jalankan dart format lib test.
2. Jalankan flutter analyze.
3. Jalankan flutter test.
4. Laporkan perubahan.
5. Berhenti dan tunggu persetujuan.