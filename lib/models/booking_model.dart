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
  });
}
