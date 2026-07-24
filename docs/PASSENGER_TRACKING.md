Saya ingin memperbaiki frontend tracking travel dan ETA penumpang TravelTrack.

Saat ini tracking masih ditampilkan sebagai dialog dengan teks lokasi dan ETA yang hardcoded. Pada tahap ini jangan memasang Google Maps atau GPS asli. Buat frontend tracking yang dinamis dan siap menerima data dari Firebase atau sistem sopir di tahap berikutnya.

Sebelum mengubah kode, periksa:

- lib/screens/booking_status_screen.dart
- lib/models/booking_model.dart
- lib/models/travel_model.dart
- lib/data/dummy_data.dart
- tampilan tracking simulasi yang sudah ada

FITUR

1. Buat halaman khusus:
   - TravelTrackingScreen
2. Jangan lagi menampilkan seluruh tracking di dialog besar.
3. TravelTrackingScreen menerima data melalui constructor atau model sederhana:
   - status perjalanan
   - nama pengemudi
   - kendaraan
   - nomor polisi
   - lokasi terakhir
   - estimasi waktu tiba
   - waktu pembaruan terakhir
   - progress perjalanan
4. Status perjalanan yang perlu didukung:
   - Menunggu Sopir
   - Sopir Menuju Penjemputan
   - Penumpang Dijemput
   - Perjalanan Berlangsung
   - Tiba di Tujuan
   - Perjalanan Selesai
5. Buat komponen progress perjalanan yang mudah dibaca.
6. Tampilkan ETA hanya jika tersedia.
7. Apabila ETA belum tersedia, tampilkan teks:
   “Estimasi waktu belum tersedia”.
8. Tampilkan waktu pembaruan lokasi terakhir.
9. Tambahkan tombol refresh frontend yang memuat ulang data dummy.
10. Tambahkan area placeholder peta yang rapi, tetapi jangan mengklaim sebagai Google Maps nyata.
11. Beri label jelas:
    “Pratinjau lokasi perjalanan”.
12. Tombol “Lacak Travel” pada BookingStatusScreen membuka TravelTrackingScreen.
13. Data simulasi jangan ditulis langsung di dalam widget.
14. Letakkan data simulasi di dummy_data.dart atau model yang sesuai agar nantinya mudah diganti dengan Stream Firestore.
15. Jangan gunakan ETA hardcoded di dalam UI. ETA harus diterima sebagai nilai parameter.

STRUKTUR

Buat:

- lib/screens/travel_tracking_screen.dart

Opsional apabila benar-benar diperlukan:

- lib/models/tracking_model.dart
- lib/widgets/trip_progress_indicator.dart

Ubah secara minimal:

- lib/screens/booking_status_screen.dart
- lib/data/dummy_data.dart
- test terkait tracking

DESAIN

- Selaraskan dengan Material 3 TravelTrack.
- Gunakan Theme.of(context).
- Gunakan Card, icon, progress indicator, dan status badge yang konsisten.
- Gunakan SafeArea dan scroll.
- Hindari desain peta palsu yang terlalu rumit.
- Jangan menambahkan animasi berat.

BATASAN

- Jangan memasang google_maps_flutter.
- Jangan memasang geolocator.
- Jangan menggunakan Firebase.
- Jangan meminta izin lokasi.
- Jangan membuat fitur sopir.
- Jangan menghitung ETA berdasarkan koordinat pada tahap ini.
- Jangan mengubah halaman booking.
- Jangan menghapus tracking lama sebelum halaman baru terbukti berfungsi.

PENGUJIAN

Tambahkan test untuk memastikan:

- halaman tracking dapat dibuka dari tiket aktif;
- status perjalanan tampil;
- ETA tampil ketika tersedia;
- fallback ETA tampil ketika data kosong;
- tombol kembali berfungsi.

Jalankan format, analyze, dan test. Laporkan perubahan lalu berhenti.