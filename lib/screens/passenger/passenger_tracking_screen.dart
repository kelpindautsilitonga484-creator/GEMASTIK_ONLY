import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../services/firebase_service.dart';

class PassengerTrackingScreen extends StatefulWidget {
  final String driverId;
  final String travelId;

  const PassengerTrackingScreen({
    super.key,
    required this.driverId,
    required this.travelId,
  });

  @override
  State<PassengerTrackingScreen> createState() =>
      _PassengerTrackingScreenState();
}

class _PassengerTrackingScreenState extends State<PassengerTrackingScreen> {
  final MapController _mapController = MapController();

  LatLng? _lastDriverPosition;

  void _followDriver(LatLng position) {
    if (_lastDriverPosition?.latitude == position.latitude &&
        _lastDriverPosition?.longitude == position.longitude) {
      return;
    }

    _lastDriverPosition = position;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        _mapController.move(position, 16);
      } catch (_) {
        // Map belum siap. Posisi tetap akan digunakan
        // sebagai initialCenter ketika widget dibangun.
      }
    });
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
          'Live Tracking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseService.listenToDriverLocation(
          widget.driverId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _buildMessageState(
              icon: Icons.error_outline_rounded,
              title: 'Gagal memuat lokasi',
              message: 'Terjadi kesalahan saat mengambil lokasi driver.',
              color: Colors.red,
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildMessageState(
              icon: Icons.location_searching_rounded,
              title: 'Driver belum memulai perjalanan',
              message:
                  'Lokasi driver akan tersedia setelah perjalanan dimulai.',
              color: Colors.orange,
            );
          }

          final data = snapshot.data!.data();

          if (data == null) {
            return _buildMessageState(
              icon: Icons.location_off_outlined,
              title: 'Lokasi belum tersedia',
              message: 'Data lokasi driver belum dapat ditemukan.',
              color: Colors.grey,
            );
          }

          final locationTravelId = (data['travelId'] ?? '').toString();

          // Sangat penting:
          // Jangan tampilkan lokasi driver dari perjalanan lain.
          if (locationTravelId != widget.travelId) {
            return _buildMessageState(
              icon: Icons.directions_bus_outlined,
              title: 'Perjalanan belum dimulai',
              message: 'Driver belum memulai perjalanan untuk tiket ini.',
              color: Colors.orange,
            );
          }

          final latitudeRaw = data['latitude'];
          final longitudeRaw = data['longitude'];

          if (latitudeRaw is! num || longitudeRaw is! num) {
            return _buildMessageState(
              icon: Icons.location_off_outlined,
              title: 'Koordinat belum tersedia',
              message: 'Menunggu driver mengirimkan posisi terbaru.',
              color: Colors.grey,
            );
          }

          final latitude = latitudeRaw.toDouble();
          final longitude = longitudeRaw.toDouble();

          final isActive =
              data['isActive'] == true || data['status'] == 'active';

          if (!isActive) {
            return _buildMessageState(
              icon: Icons.directions_bus_filled_outlined,
              title: 'Perjalanan tidak aktif',
              message:
                  'Driver belum memulai perjalanan atau perjalanan telah selesai.',
              color: Colors.orange,
            );
          }

          final speedRaw = data['speed'];
          final speed = speedRaw is num ? speedRaw.toDouble() : 0.0;

          final position = LatLng(
            latitude,
            longitude,
          );

          _followDriver(position);

          return _buildTrackingMap(
            position: position,
            speed: speed,
          );
        },
      ),
    );
  }

  Widget _buildTrackingMap({
    required LatLng position,
    required double speed,
  }) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: position,
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app_gemastik',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: position,
                  width: 56,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F52BA),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            const SimpleAttributionWidget(
              source: Text(
                '© OpenStreetMap contributors',
              ),
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Material(
            color: Colors.white,
            elevation: 3,
            borderRadius: BorderRadius.circular(12),
            child: IconButton(
              tooltip: 'Fokus ke driver',
              onPressed: () {
                _mapController.move(
                  position,
                  16,
                );
              },
              icon: const Icon(
                Icons.my_location_rounded,
                color: Color(0xFF0F52BA),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: _buildDriverInfo(
            speed: speed,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo({
    required double speed,
  }) {
    final speedKmH = speed * 3.6;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Travel sedang berjalan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.gps_fixed_rounded,
                size: 18,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Lokasi driver diperbarui secara real-time',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.speed_rounded,
                size: 18,
                color: Color(0xFF0F52BA),
              ),
              const SizedBox(width: 8),
              Text(
                'Kecepatan: ${speedKmH.toStringAsFixed(1)} km/jam',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageState({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 38,
                color: color,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
