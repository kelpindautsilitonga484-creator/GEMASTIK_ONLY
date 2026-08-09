Saya ingin merapikan dan melengkapi frontend profil penumpang TravelTrack.

Saat ini profil ditulis secara inline di dalam main_navigation_screen.dart dan masih menggunakan data statis. Refactor bagian ini secara minimal tanpa mengubah navigasi utama.

Sebelum mengubah kode, periksa:

- lib/screens/main_navigation_screen.dart
- lib/screens/login_screen.dart
- gaya avatar, card, tombol, icon, dan tema aplikasi
- cara BottomNavigationBar dan IndexedStack bekerja

FITUR

1. Pindahkan tampilan profil yang saat ini inline menjadi halaman terpisah:
   - ProfileScreen
2. Buat halaman:
   - EditProfileScreen
3. ProfileScreen menampilkan:
   - Avatar atau inisial pengguna
   - Nama
   - Email
   - Nomor telepon
   - Menu edit profil
   - Menu bantuan atau tentang aplikasi secara sederhana
   - Tombol logout
4. EditProfileScreen memiliki field:
   - Nama lengkap
   - Nomor telepon
   - Email
5. Email boleh dibuat read-only agar selaras dengan integrasi akun di masa depan.
6. Tambahkan validasi nama dan nomor telepon.
7. Setelah disimpan:
   - perbarui data profil pada state lokal;
   - kembali ke ProfileScreen;
   - tampilkan SnackBar berhasil.
8. Tambahkan dialog konfirmasi sebelum logout.
9. Setelah logout dikonfirmasi:
   - kembali ke LoginScreen;
   - hapus riwayat navigasi menggunakan pushAndRemoveUntil atau cara setara.
10. Jangan menyimpan password atau data sensitif.

PENGELOLAAN DATA

Karena Firebase belum dipasang:

- gunakan state lokal sederhana;
- data profil boleh menggunakan model sederhana atau parameter constructor;
- jangan menggunakan Provider, Bloc, Riverpod, GetX, atau package state management lain;
- desain kode agar nantinya mudah diganti dengan data Firebase.

Apabila diperlukan, buat model sederhana:

- lib/models/passenger_profile_model.dart

Model cukup berisi:

- name
- email
- phoneNumber

DESAIN

- Pertahankan tema biru Material 3 TravelTrack.
- Gunakan Theme.of(context).
- Gunakan komponen ListTile atau Card yang konsisten.
- Jangan menambahkan desain yang berbeda jauh dari HomeScreen.
- Gunakan spacing dan radius yang konsisten.
- Pastikan profil tetap nyaman di layar kecil.

STRUKTUR FILE

Buat hanya:

- lib/screens/profile_screen.dart
- lib/screens/edit_profile_screen.dart
- lib/models/passenger_profile_model.dart hanya jika benar-benar diperlukan

Ubah secara minimal:

- lib/screens/main_navigation_screen.dart
- test/widget_test.dart atau test profil baru

BATASAN

- Frontend saja.
- Jangan menggunakan Firebase.
- Jangan menambah package.
- Jangan mengubah tab Beranda, Cari Travel, atau Tiket Saya.
- Jangan mengubah keseluruhan MainNavigationScreen.
- Jangan membuat service atau repository.
- Jangan menambahkan fitur upload foto.
- Jangan menambahkan penyimpanan permanen pada tahap ini.

PENGUJIAN

Tambahkan test sederhana untuk memastikan:

- ProfileScreen tampil pada tab profil;
- halaman edit profil dapat dibuka;
- validasi bekerja;
- tombol logout menampilkan dialog;
- logout kembali ke LoginScreen.

Setelah selesai, jalankan format, analyze, dan test. Laporkan hasilnya dan berhenti.