class TravelModel {
  final String id;
  final String providerName;
  final String
      vehicleType; // e.g., Toyota HiAce Premio, Isuzu Elf, Mitsubishi L300
  final String plateNumber;
  final String origin;
  final String destination;
  final String departurePool;
  final String arrivalPool;
  final String departureTime;
  final String arrivalTime;
  final int price;
  final List<String> occupiedSeats;
  final int totalSeats;
  final List<String> facilities;
  final double rating;
  final String serviceType; // 'Pool to Pool' or 'Door to Door'
  final String driverName;
  final String driverPhone;
  final String? driverId;
  final String departureDate; // e.g. "2026-08-12"

  TravelModel({
    required this.id,
    required this.providerName,
    required this.vehicleType,
    required this.plateNumber,
    required this.origin,
    required this.destination,
    required this.departurePool,
    required this.arrivalPool,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.occupiedSeats,
    this.totalSeats = 10,
    required this.facilities,
    this.rating = 4.8,
    this.serviceType = 'Pool to Pool',
    required this.driverName,
    required this.driverPhone,
    this.driverId,
    this.departureDate = '',
  });

  int get availableSeatsCount => totalSeats - occupiedSeats.length;

  factory TravelModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return TravelModel(
      id: documentId ?? (map['id']?.toString() ?? ''),
      providerName: map['providerName']?.toString() ?? '',
      vehicleType: map['vehicleType']?.toString() ?? '',
      plateNumber: map['plateNumber']?.toString() ?? '',
      origin: map['origin']?.toString() ?? '',
      destination: map['destination']?.toString() ?? '',
      departurePool: map['departurePool']?.toString() ?? '',
      arrivalPool: map['arrivalPool']?.toString() ?? '',
      departureTime: map['departureTime']?.toString() ?? '',
      arrivalTime: map['arrivalTime']?.toString() ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      occupiedSeats: (map['occupiedSeats'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      totalSeats: (map['totalSeats'] as num?)?.toInt() ?? 10,
      facilities: (map['facilities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
      serviceType: map['serviceType']?.toString() ?? 'Pool to Pool',
      driverName: map['driverName']?.toString() ?? '',
      driverPhone: map['driverPhone']?.toString() ?? '',
      driverId: map['driverId']?.toString(),
      departureDate: map['departureDate']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerName': providerName,
      'vehicleType': vehicleType,
      'plateNumber': plateNumber,
      'origin': origin,
      'destination': destination,
      'departurePool': departurePool,
      'arrivalPool': arrivalPool,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'price': price,
      'occupiedSeats': occupiedSeats,
      'totalSeats': totalSeats,
      'facilities': facilities,
      'rating': rating,
      'serviceType': serviceType,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverId': driverId,
      'departureDate': departureDate,
    };
  }

  TravelModel copyWith({
    String? id,
    String? providerName,
    String? vehicleType,
    String? plateNumber,
    String? origin,
    String? destination,
    String? departurePool,
    String? arrivalPool,
    String? departureTime,
    String? arrivalTime,
    int? price,
    List<String>? occupiedSeats,
    int? totalSeats,
    List<String>? facilities,
    double? rating,
    String? serviceType,
    String? driverName,
    String? driverPhone,
    String? driverId,
    String? departureDate,
  }) {
    return TravelModel(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      vehicleType: vehicleType ?? this.vehicleType,
      plateNumber: plateNumber ?? this.plateNumber,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departurePool: departurePool ?? this.departurePool,
      arrivalPool: arrivalPool ?? this.arrivalPool,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      price: price ?? this.price,
      occupiedSeats: occupiedSeats ?? this.occupiedSeats,
      totalSeats: totalSeats ?? this.totalSeats,
      facilities: facilities ?? this.facilities,
      rating: rating ?? this.rating,
      serviceType: serviceType ?? this.serviceType,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverId: driverId ?? this.driverId,
      departureDate: departureDate ?? this.departureDate,
    );
  }
}
