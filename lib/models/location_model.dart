class LocationModel {
  final String driverId;
  final String vehicleId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final String status;

  LocationModel({
    required this.driverId,
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.status,
  });

  factory LocationModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return LocationModel(
      driverId: map['driverId'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      speed: (map['speed'] ?? 0).toDouble(),
      heading: (map['heading'] ?? 0).toDouble(),
      status: map['status'] ?? 'inactive',
    );
  }
}