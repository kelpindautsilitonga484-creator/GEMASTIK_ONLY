Saya ingin Anda melakukan pemeriksaan menyeluruh dan memperbaiki error pada project Flutter TravelTrack yang sedang terbuka.

Tujuan utama tahap ini adalah memastikan project dapat dianalisis, diuji, dan dibangun tanpa error, sambil mempertahankan fitur, tema, struktur, dan perilaku aplikasi yang sudah ada.

ATURAN GIT

1. Periksa branch aktif dengan:
   git branch --show-current

2. Periksa kondisi project dengan:
   git status

3. Bekerja hanya pada branch yang sedang aktif.

4. Jangan menjalankan:
   - git checkout
   - git switch
   - git merge
   - git rebase
   - git reset
   - git restore
   - git clean
   - git commit
   - git push
   - git pull
   - git stash

5. Jangan memindahkan pekerjaan ke main atau branch lain.

6. Jangan menghapus atau menimpa perubahan lokal pengguna.

Jika terdapat perubahan lokal, pertahankan perubahan tersebut dan perbaiki kode dengan hati-hati tanpa membuang pekerjaan yang sudah ada.

PEMERIKSAAN PROJECT

Periksa bagian berikut:

- pubspec.yaml
- pubspec.lock
- lib/
- test/
- android/
- konfigurasi Flutter yang berkaitan langsung dengan build
- import antarfail
- constructor dan parameter widget
- navigation dan route
- controller dan dispose
- penggunaan BuildContext setelah operasi asynchronous
- null-safety
- tipe data model
- widget overflow
- error kompilasi
- warning dan lint yang benar-benar relevan
- test yang sudah tidak sesuai dengan aplikasi

Jalankan perintah berikut secara bertahap:

1. flutter pub get
2. dart format --output=none --set-exit-if-changed lib test
3. flutter analyze
4. flutter test

Jika analyze dan test sudah berhasil, jalankan:

5. flutter build apk --debug

CARA MEMPERBAIKI

1. Identifikasi penyebab setiap error terlebih dahulu.
2. Perbaiki error yang benar-benar dapat dibuktikan dari hasil command atau kode.
3. Ubah hanya file yang berkaitan langsung dengan error.
4. Gunakan solusi paling sederhana dan aman.
5. Pertahankan struktur project yang sekarang.
6. Pertahankan tema Material 3 dan tampilan TravelTrack.
7. Pertahankan alur login, navigasi, pencarian travel, booking, tiket, dan profil yang sudah ada.
8. Jangan menghapus fitur untuk membuat test berhasil.
9. Jangan mengganti implementasi yang berfungsi dengan placeholder kosong.
10. Jangan mengubah data dummy kecuali terdapat error nyata di dalamnya.
11. Jangan melakukan refactor besar hanya karena file terlihat panjang.
12. Jangan membuat Clean Architecture, repository layer, use case, dependency injection, atau state management kompleks.
13. Jangan menambahkan komentar berlebihan atau file yang tidak diperlukan.

FORMAT KODE

Jika pemeriksaan format menemukan file yang belum sesuai, jalankan:

dart format lib test

Format kode boleh diperbaiki, tetapi jangan mengubah logika hanya untuk kepentingan formatting.

DEPENDENCY

- Jangan menambah, menghapus, atau memperbarui package tanpa persetujuan saya.
- Jangan mengubah versi Flutter atau Dart.
- Jangan menjalankan flutter upgrade.
- Jangan menambahkan Firebase, Maps, Geolocator, atau package lain pada tahap ini.
- Jika sebuah error benar-benar memerlukan package baru, berhenti dan jelaskan alasannya terlebih dahulu.

PENGUJIAN

Setelah setiap perbaikan penting, jalankan kembali:

- flutter analyze
- flutter test

Setelah seluruh error selesai, jalankan:

- flutter build apk --debug

Target akhir:

- flutter analyze menghasilkan “No issues found”.
- flutter test menghasilkan “All tests passed”.
- flutter build apk --debug berhasil.
- Tidak ada fitur lama yang hilang.
- Tidak ada perubahan desain yang tidak diminta.

JIKA TEST LAMA TIDAK SESUAI

Jika test masih memeriksa Counter App bawaan Flutter atau widget yang sudah tidak ada:

- sesuaikan test dengan perilaku TravelTrack saat ini;
- gunakan smoke test yang benar;
- jangan mengubah aplikasi hanya agar cocok dengan test lama.

BATASAN PERUBAHAN

Jangan mengimplementasikan fitur baru dalam proses ini.

Jangan membuat:

- portal admin;
- portal sopir;
- Firebase;
- GPS;
- Google Maps;
- payment gateway;
- registrasi tambahan di luar yang sedang dikerjakan;
- perubahan besar pada UI.

Fokus hanya pada error, warning penting, test gagal, dan build gagal.

LAPORAN AKHIR

Setelah selesai, laporkan secara terstruktur:

1. Branch yang digunakan.
2. Kondisi awal git status.
3. Semua command yang dijalankan.
4. Error yang ditemukan.
5. Penyebab setiap error.
6. Cara setiap error diperbaiki.
7. Daftar file yang dibuat.
8. Daftar file yang diubah.
9. Ringkasan perubahan pada setiap file.
10. Hasil akhir flutter analyze.
11. Hasil akhir flutter test.
12. Hasil akhir flutter build apk --debug.
13. Apakah terdapat perubahan perilaku atau desain aplikasi.
14. Error atau risiko yang masih tersisa.

Jangan melakukan commit, push, merge, checkout, reset, atau penghapusan file.

Berhenti setelah perbaikan dan laporan selesai. Tunggu saya meninjau perubahan sebelum melakukan tindakan lain.