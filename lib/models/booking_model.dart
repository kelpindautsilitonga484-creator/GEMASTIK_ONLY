import 'package:cloud_firestore/cloud_firestore.dart';
import 'travel_model.dart';

class BookingModel {
  final String bookingId;
  final TravelModel travel;
  final String passengerName;
  final String passengerPhone;
  final List<String> selectedSeats;
  final int totalPrice;
  final String paymentMethod;
  final String status; // 'Dikonfirmasi', 'Menunggu Pembayaran', 'Selesai', 'Dibatalkan'
  final DateTime bookingDate;

  // New Firestore fields
  final String userId;
  final String travelId;
  final String? driverId;
  final String serviceType;
  final String? pickupAddress;
  final String? notes;
  final Map<String, dynamic> travelSnapshot;

  BookingModel({
    required this.bookingId,
    required this.travel,
    required this.passengerName,
    required this.passengerPhone,
    required this.selectedSeats,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    required this.bookingDate,
    this.userId = '',
    this.travelId = '',
    this.driverId,
    this.serviceType = 'Pool to Pool',
    this.pickupAddress,
    this.notes,
    this.travelSnapshot = const {},
  });

  factory BookingModel.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    final rawSnapshot = (map['travelSnapshot'] as Map<String, dynamic>?) ?? {};

    // Construct TravelModel from travelSnapshot if travelId or snapshot is present
    final travelObj = TravelModel(
      id: map['travelId']?.toString() ?? rawSnapshot['id']?.toString() ?? '',
      providerName: rawSnapshot['providerName']?.toString() ?? '',
      vehicleType: rawSnapshot['vehicleType']?.toString() ?? '',
      plateNumber: rawSnapshot['plateNumber']?.toString() ?? '',
      origin: rawSnapshot['origin']?.toString() ?? '',
      destination: rawSnapshot['destination']?.toString() ?? '',
      departurePool: rawSnapshot['departurePool']?.toString() ?? '',
      arrivalPool: rawSnapshot['arrivalPool']?.toString() ?? '',
      departureTime: rawSnapshot['departureTime']?.toString() ?? '',
      arrivalTime: rawSnapshot['arrivalTime']?.toString() ?? '',
      price: (rawSnapshot['price'] as num?)?.toInt() ?? 0,
      occupiedSeats: const [],
      totalSeats: (rawSnapshot['totalSeats'] as num?)?.toInt() ?? 10,
      facilities: const [],
      rating: (rawSnapshot['rating'] as num?)?.toDouble() ?? 4.8,
      serviceType: rawSnapshot['serviceType']?.toString() ?? 'Pool to Pool',
      driverName: rawSnapshot['driverName']?.toString() ?? '',
      driverPhone: rawSnapshot['driverPhone']?.toString() ?? '',
      driverId: map['driverId']?.toString(),
      departureDate: rawSnapshot['departureDate']?.toString() ?? '',
    );

    DateTime parsedDate;
    final dateVal = map['createdAt'] ?? map['bookingDate'];
    if (dateVal is Timestamp) {
      parsedDate = dateVal.toDate();
    } else if (dateVal is String) {
      parsedDate = DateTime.tryParse(dateVal) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return BookingModel(
      bookingId: documentId ?? map['bookingId']?.toString() ?? map['id']?.toString() ?? '',
      travel: travelObj,
      passengerName: map['passengerName']?.toString() ?? '',
      passengerPhone: map['passengerPhone']?.toString() ?? '',
      selectedSeats: (map['selectedSeats'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      totalPrice: (map['totalPrice'] as num?)?.toInt() ?? 0,
      paymentMethod: map['paymentMethod']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Menunggu Konfirmasi',
      bookingDate: parsedDate,
      userId: map['userId']?.toString() ?? '',
      travelId: map['travelId']?.toString() ?? travelObj.id,
      driverId: map['driverId']?.toString() ?? travelObj.driverId,
      serviceType: map['serviceType']?.toString() ?? travelObj.serviceType,
      pickupAddress: map['pickupAddress']?.toString(),
      notes: map['notes']?.toString(),
      travelSnapshot: rawSnapshot,
    );
  }

  Map<String, dynamic> toMap() {
    final effectiveSnapshot = travelSnapshot.isNotEmpty
        ? travelSnapshot
        : {
            'providerName': travel.providerName,
            'vehicleType': travel.vehicleType,
            'plateNumber': travel.plateNumber,
            'origin': travel.origin,
            'destination': travel.destination,
            'departurePool': travel.departurePool,
            'arrivalPool': travel.arrivalPool,
            'departureDate': travel.departureDate,
            'departureTime': travel.departureTime,
            'arrivalTime': travel.arrivalTime,
            'price': travel.price,
            'serviceType': travel.serviceType,
            'driverName': travel.driverName,
            'driverPhone': travel.driverPhone,
          };

    return {
      'bookingId': bookingId,
      'userId': userId,
      'travelId': travelId.isNotEmpty ? travelId : travel.id,
      'driverId': driverId ?? travel.driverId,
      'passengerName': passengerName,
      'passengerPhone': passengerPhone,
      'selectedSeats': selectedSeats,
      'serviceType': serviceType,
      'pickupAddress': pickupAddress,
      'notes': notes,
      'paymentMethod': paymentMethod,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'travelSnapshot': effectiveSnapshot,
    };
  }

  BookingModel copyWith({
    String? bookingId,
    TravelModel? travel,
    String? passengerName,
    String? passengerPhone,
    List<String>? selectedSeats,
    int? totalPrice,
    String? paymentMethod,
    String? status,
    DateTime? bookingDate,
    String? userId,
    String? travelId,
    String? driverId,
    String? serviceType,
    String? pickupAddress,
    String? notes,
    Map<String, dynamic>? travelSnapshot,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      travel: travel ?? this.travel,
      passengerName: passengerName ?? this.passengerName,
      passengerPhone: passengerPhone ?? this.passengerPhone,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      userId: userId ?? this.userId,
      travelId: travelId ?? this.travelId,
      driverId: driverId ?? this.driverId,
      serviceType: serviceType ?? this.serviceType,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      notes: notes ?? this.notes,
      travelSnapshot: travelSnapshot ?? this.travelSnapshot,
    );
  }
}
