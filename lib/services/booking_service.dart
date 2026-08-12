import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../models/travel_model.dart';

class BookingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Helper to generate unique booking ID with low collision risk.
  /// Format: TTR-YYYYMMDD-XXXXXXXX (8 random alphanumeric chars)
  static String _generateBookingId() {
    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    final suffix = List.generate(8, (_) => chars[rand.nextInt(chars.length)]).join();
    return 'TTR-$dateStr-$suffix';
  }

  /// Create a new booking using Firestore Transaction to prevent double booking.
  static Future<String> createBooking({
    required TravelModel travel,
    required String passengerName,
    required String passengerPhone,
    required List<String> selectedSeats,
    required String serviceType,
    required String pickupAddress,
    required String notes,
    required String paymentMethod,
    required int totalPrice,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('Pengguna harus login terlebih dahulu untuk membuat pesanan.');
    }

    if (travel.id.isEmpty) {
      throw Exception('Travel ID tidak valid.');
    }

    if (selectedSeats.isEmpty) {
      throw Exception('Minimal 1 kursi harus dipilih.');
    }

    final bookingId = _generateBookingId();
    final travelRef = _firestore.collection('travels').doc(travel.id);
    final bookingRef = _firestore.collection('bookings').doc(bookingId);

    await _firestore.runTransaction((transaction) async {
      final travelSnapshot = await transaction.get(travelRef);
      if (!travelSnapshot.exists) {
        throw Exception('Jadwal travel tidak ditemukan di database.');
      }

      final bookingDocSnapshot = await transaction.get(bookingRef);
      if (bookingDocSnapshot.exists) {
        throw Exception('ID Booking sudah digunakan, silakan coba lagi.');
      }

      final travelData = travelSnapshot.data() ?? {};
      final List<dynamic> currentOccupied = travelData['occupiedSeats'] as List<dynamic>? ?? [];
      final List<String> currentOccupiedSeats = currentOccupied.map((e) => e.toString()).toList();

      // Check for seat conflicts
      final List<String> conflictingSeats = [];
      for (final seat in selectedSeats) {
        if (currentOccupiedSeats.contains(seat)) {
          conflictingSeats.add(seat);
        }
      }

      if (conflictingSeats.isNotEmpty) {
        throw Exception('Kursi ${conflictingSeats.join(", ")} sudah dipesan oleh penumpang lain.');
      }

      // Updated occupied seats list
      final updatedOccupiedSeats = List<String>.from(currentOccupiedSeats)..addAll(selectedSeats);

      // Travel Snapshot data to embed in booking
      final Map<String, dynamic> snapshotData = {
        'providerName': travelData['providerName']?.toString() ?? travel.providerName,
        'vehicleType': travelData['vehicleType']?.toString() ?? travel.vehicleType,
        'plateNumber': travelData['plateNumber']?.toString() ?? travel.plateNumber,
        'origin': travelData['origin']?.toString() ?? travel.origin,
        'destination': travelData['destination']?.toString() ?? travel.destination,
        'departurePool': travelData['departurePool']?.toString() ?? travel.departurePool,
        'arrivalPool': travelData['arrivalPool']?.toString() ?? travel.arrivalPool,
        'departureDate': travelData['departureDate']?.toString() ?? travel.departureDate,
        'departureTime': travelData['departureTime']?.toString() ?? travel.departureTime,
        'arrivalTime': travelData['arrivalTime']?.toString() ?? travel.arrivalTime,
        'price': (travelData['price'] as num?)?.toInt() ?? travel.price,
        'serviceType': travelData['serviceType']?.toString() ?? travel.serviceType,
        'driverName': travelData['driverName']?.toString() ?? travel.driverName,
        'driverPhone': travelData['driverPhone']?.toString() ?? travel.driverPhone,
      };

      // 1. Update travels occupiedSeats
      transaction.update(travelRef, {
        'occupiedSeats': updatedOccupiedSeats,
      });

      // 2. Set new booking document
      final bookingData = {
        'bookingId': bookingId,
        'userId': currentUser.uid,
        'travelId': travel.id,
        'driverId': travelData['driverId']?.toString() ?? travel.driverId,
        'passengerName': passengerName,
        'passengerPhone': passengerPhone,
        'selectedSeats': selectedSeats,
        'serviceType': serviceType,
        'pickupAddress': pickupAddress,
        'notes': notes,
        'paymentMethod': paymentMethod,
        'totalPrice': totalPrice,
        'status': 'Menunggu Konfirmasi',
        'createdAt': FieldValue.serverTimestamp(),
        'travelSnapshot': snapshotData,
      };

      transaction.set(bookingRef, bookingData);
    });

    debugPrint('Booking berhasil dibuat dengan ID: $bookingId');
    return bookingId;
  }

  /// Get all bookings created by a specific user.
  static Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();

      final bookings = snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data(), documentId: doc.id);
      }).toList();

      // Sort in memory by date descending to avoid index requirement
      bookings.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));

      return bookings;
    } catch (e) {
      debugPrint('Gagal mengambil data booking user: $e');
      rethrow;
    }
  }

  /// Cancel a booking using Firestore Transaction.
  static Future<void> cancelBooking(String bookingId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('Pengguna harus login terlebih dahulu.');
    }

    final bookingRef = _firestore.collection('bookings').doc(bookingId);

    await _firestore.runTransaction((transaction) async {
      final bookingSnapshot = await transaction.get(bookingRef);
      if (!bookingSnapshot.exists) {
        throw Exception('Pesanan tidak ditemukan.');
      }

      final bookingData = bookingSnapshot.data() ?? {};
      final userId = bookingData['userId']?.toString() ?? '';
      if (userId != currentUser.uid) {
        throw Exception('Anda tidak memiliki akses untuk membatalkan pesanan ini.');
      }

      final status = bookingData['status']?.toString() ?? '';
      if (status == 'Dibatalkan') {
        throw Exception('Pesanan ini sudah dibatalkan sebelumnya.');
      }

      final travelId = bookingData['travelId']?.toString() ?? '';
      final List<dynamic> seatsToReleaseRaw = bookingData['selectedSeats'] as List<dynamic>? ?? [];
      final List<String> seatsToRelease = seatsToReleaseRaw.map((e) => e.toString()).toList();

      if (travelId.isNotEmpty) {
        final travelRef = _firestore.collection('travels').doc(travelId);
        final travelSnapshot = await transaction.get(travelRef);

        if (travelSnapshot.exists) {
          final travelData = travelSnapshot.data() ?? {};
          final List<dynamic> currentOccupiedRaw = travelData['occupiedSeats'] as List<dynamic>? ?? [];
          final List<String> currentOccupied = currentOccupiedRaw.map((e) => e.toString()).toList();

          final updatedOccupied = currentOccupied.where((seat) => !seatsToRelease.contains(seat)).toList();

          transaction.update(travelRef, {
            'occupiedSeats': updatedOccupied,
          });
        }
      }

      transaction.update(bookingRef, {
        'status': 'Dibatalkan',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    debugPrint('Booking $bookingId berhasil dibatalkan.');
  }
}
