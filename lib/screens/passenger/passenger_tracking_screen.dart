import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/location_model.dart';
import '../../services/firebase_service.dart';

class PassengerTrackingScreen extends StatefulWidget {
  final String driverId;

  const PassengerTrackingScreen({
    super.key,
    required this.driverId,
  });

  @override
  State<PassengerTrackingScreen> createState() =>
      _PassengerTrackingScreenState();
}

class _PassengerTrackingScreenState
    extends State<PassengerTrackingScreen> {
  GoogleMapController? _mapController;

  Marker? _driverMarker;

  LatLng? _driverLocation;

  bool _isDriverActive = false;

  static const LatLng _initialLocation =
      LatLng(-6.200000, 106.816666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
      ),
      body: StreamBuilder(
        stream: FirebaseService.listenToDriverLocation(
          widget.driverId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n${snapshot.error}',
              ),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Lokasi travel belum tersedia.',
              ),
            );
          }

          final data = snapshot.data!.data();

          if (data == null) {
            return const Center(
              child: Text(
                'Data lokasi tidak tersedia.',
              ),
            );
          }

          final location =
              LocationModel.fromMap(data);

          _updateDriverLocation(location);

          return _buildMap(location);
        },
      ),
    );
  }

  void _updateDriverLocation(
    LocationModel location,
  ) {
    final newPosition = LatLng(
      location.latitude,
      location.longitude,
    );

    _driverLocation = newPosition;
    _isDriverActive = location.status == 'active';

    _driverMarker = Marker(
      markerId: const MarkerId('travel_driver'),
      position: newPosition,
      infoWindow: InfoWindow(
        title: 'TravelTrack',
        snippet: location.vehicleId,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(newPosition),
      );
    });
  }

  Widget _buildMap(LocationModel location) {
    final position = LatLng(
      location.latitude,
      location.longitude,
    );

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 15,
          ),

          onMapCreated: (
            GoogleMapController controller,
          ) {
            _mapController = controller;

            controller.animateCamera(
              CameraUpdate.newLatLng(position),
            );
          },

          markers: {
            if (_driverMarker != null)
              _driverMarker!,
          },

          myLocationEnabled: true,
          myLocationButtonEnabled: true,

          zoomControlsEnabled: false,
        ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: _buildDriverInfo(location),
        ),
      ],
    );
  }

  Widget _buildDriverInfo(
    LocationModel location,
  ) {
    final isActive =
        location.status == 'active';

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  isActive
                      ? 'Travel sedang berjalan'
                      : 'Travel tidak aktif',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Kendaraan: ${location.vehicleId}',
            ),

            const SizedBox(height: 6),

            Text(
              'Kecepatan: '
              '${(location.speed * 3.6).toStringAsFixed(1)} km/jam',
            ),
          ],
        ),
      ),
    );
  }
}