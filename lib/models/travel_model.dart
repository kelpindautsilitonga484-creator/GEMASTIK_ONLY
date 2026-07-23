class TravelModel {
  final String id;
  final String providerName;
  final String vehicleType; // e.g., Toyota HiAce Premio, Isuzu Elf, Mitsubishi L300
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
  });

  int get availableSeatsCount => totalSeats - occupiedSeats.length;
}
