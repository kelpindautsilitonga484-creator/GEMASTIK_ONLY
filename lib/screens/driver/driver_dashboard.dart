import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/location_service.dart';
import '../../services/firebase_service.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  bool isTripActive = false;
  Position? currentPosition;
  bool isLoadingLocation = false;

  StreamSubscription<Position>? _positionSubscription;

  void _startLocationTracking(String driverId) {
    _positionSubscription?.cancel();

    _positionSubscription = LocationService.getLocationStream().listen(
      (Position position) async {
        if (!mounted) return;

        setState(() {
          currentPosition = position;
        });

        try {
          await FirebaseService.updateDriverLocation(
            driverId: driverId,
            vehicleId: 'TT-001',
            position: position,
            isActive: true,
          );

          debugPrint(
            'Lokasi terkirim: '
            '${position.latitude}, ${position.longitude}',
          );
        } catch (e) {
          debugPrint('Gagal mengirim lokasi: $e');
        }
      },
      onError: (error) {
        debugPrint('GPS error: $error');
      },
    );
  }

  void _stopLocationTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<void> _toggleTrip() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (isTripActive) {
        _stopLocationTracking();
        setState(() {
          isTripActive = false;
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sesi sopir tidak valid. Silakan login kembali.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ==========================================
    // JIKA PERJALANAN SEDANG AKTIF
    // ==========================================

    if (isTripActive) {
      _stopLocationTracking();

      setState(() {
        isTripActive = false;
      });

      if (currentPosition != null) {
        try {
          await FirebaseService.updateDriverLocation(
            driverId: user.uid,
            vehicleId: 'TT-001',
            position: currentPosition!,
            isActive: false,
          );
        } catch (e) {
          debugPrint(
            'Gagal memperbarui status perjalanan: $e',
          );
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perjalanan selesai'),
        ),
      );

      return;
    }

    // ==========================================
    // MULAI PROSES GPS
    // ==========================================

    setState(() {
      isLoadingLocation = true;
    });

    // ==========================================
    // CEK GPS
    // ==========================================

    final serviceEnabled = await LocationService.isLocationServiceEnabled();

    if (!mounted) return;

    if (!serviceEnabled) {
      setState(() {
        isLoadingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'GPS belum aktif. Silakan aktifkan GPS perangkat.',
          ),
        ),
      );

      // Membuka pengaturan GPS perangkat
      await Geolocator.openLocationSettings();

      return;
    }

    // ==========================================
    // MINTA IZIN LOKASI
    // ==========================================

    final permission = await LocationService.requestPermission();

    if (!mounted) return;

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        isLoadingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Izin lokasi diperlukan untuk melakukan tracking.',
          ),
        ),
      );

      return;
    }

    // ==========================================
    // AMBIL LOKASI
    // ==========================================

    final position = await LocationService.getCurrentLocation();
    await LocationService.getCurrentLocation();

    if (!mounted) return;

    if (position == null) {
      setState(() {
        isLoadingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lokasi tidak dapat diperoleh.',
          ),
        ),
      );

      return;
    }

    // ==========================================
    // GPS BERHASIL
    // ==========================================

    setState(() {
      isTripActive = true;
      currentPosition = position;
      isLoadingLocation = false;
    });

    _startLocationTracking(user.uid);

    try {
      await FirebaseService.updateDriverLocation(
        driverId: user.uid,
        vehicleId: 'TT-001',
        position: position,
        isActive: true,
      );
    } catch (e) {
      debugPrint('Gagal mengirim lokasi ke Firebase: $e');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'GPS aktif. Perjalanan dimulai.',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F52BA),
        foregroundColor: Colors.white,
        title: const Text(
          'TravelTrack',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // SAPAAN
            // =========================
            const Text(
              'Halo, Sopir! 👋',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Siap untuk perjalanan hari ini?',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // STATUS PERJALANAN
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STATUS PERJALANAN',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTripActive ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isTripActive
                            ? 'Perjalanan sedang berlangsung'
                            : 'Perjalanan belum dimulai',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _toggleTrip,
                      icon: Icon(
                        isTripActive
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline,
                      ),
                      label: Text(
                        isTripActive ? 'AKHIRI PERJALANAN' : 'MULAI PERJALANAN',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isTripActive ? Colors.red : const Color(0xFF0F52BA),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // JUDUL PERJALANAN
            // =========================
            const Text(
              'Perjalanan Hari Ini',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // INFO RUTE
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.route,
                          color: Color(0xFF0F52BA),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jakarta → Bandung',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Perjalanan Antar Kota',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoItem(
                        Icons.access_time,
                        'Jam Berangkat',
                        '08:00',
                      ),
                      _infoItem(
                        Icons.directions_car,
                        'Kendaraan',
                        'B 1234 XYZ',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // PETA
            // =========================
            const Text(
              'Lokasi Travel',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  Positioned(
                    bottom: 20,
                    child: Text(
                      'Google Maps akan ditampilkan di sini',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // STATISTIK
            // =========================
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.people_outline,
                    title: 'Penumpang',
                    value: '12',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    icon: Icons.access_time,
                    title: 'Estimasi Tiba',
                    value: '-- menit',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // STATUS GPS
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color:
                    isTripActive ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    isTripActive ? Icons.gps_fixed : Icons.gps_off,
                    color: isTripActive ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTripActive ? 'GPS Aktif' : 'GPS Belum Aktif',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isTripActive
                              ? 'Lokasi kendaraan sedang dikirim'
                              : 'Aktifkan perjalanan untuk mulai tracking',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =========================
  // INFO ITEM
  // =========================
  Widget _infoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF0F52BA),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // STAT CARD
  // =========================
  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF0F52BA),
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
