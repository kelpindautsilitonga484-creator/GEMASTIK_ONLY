import 'package:flutter/material.dart';
import '../models/travel_model.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final TravelModel travel;
  final String passengerName;
  final String passengerPhone;
  final List<String> selectedSeats;
  final String serviceType;
  final String pickupAddress;
  final String notes;
  final String paymentMethod;
  final VoidCallback onBookingCompleted;

  const PaymentConfirmationScreen({
    super.key,
    required this.travel,
    required this.passengerName,
    required this.passengerPhone,
    required this.selectedSeats,
    required this.serviceType,
    required this.pickupAddress,
    required this.notes,
    required this.paymentMethod,
    required this.onBookingCompleted,
  });

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool _isConfirmedByPassenger = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final travel = widget.travel;
    final extraCost = widget.serviceType == 'Door to Door' ? 15000 : 0;
    final ticketPriceTotal = travel.price * widget.selectedSeats.length;
    final extraCostTotal = extraCost * widget.selectedSeats.length;
    final totalPrice = ticketPriceTotal + extraCostTotal;

    final formattedTicketPrice =
        'Rp ${ticketPriceTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    final formattedExtraCost =
        'Rp ${extraCostTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    final formattedTotalPrice =
        'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F52BA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Travel & Passenger Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.directions_bus_rounded,
                            color: Color(0xFF0F52BA)),
                        SizedBox(width: 8),
                        Text('Rincian Perjalanan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildRowItem('Operator Travel', travel.providerName),
                    const SizedBox(height: 8),
                    _buildRowItem('Rute Perjalanan',
                        '${travel.origin} ➔ ${travel.destination}'),
                    const SizedBox(height: 8),
                    _buildRowItem('Jadwal',
                        '${travel.departureTime} WIB • ${travel.vehicleType}'),
                    const SizedBox(height: 8),
                    _buildRowItem(
                        'Nomor Kursi', widget.selectedSeats.join(', ')),
                    const SizedBox(height: 8),
                    _buildRowItem('Nama Penumpang', widget.passengerName),
                    const SizedBox(height: 8),
                    _buildRowItem('No. Telepon / WA', widget.passengerPhone),
                    const SizedBox(height: 8),
                    _buildRowItem('Layanan', widget.serviceType),
                    if (widget.pickupAddress.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildRowItem('Alamat Penjemputan', widget.pickupAddress),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Instructions Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.payment_rounded, color: Colors.teal),
                            SizedBox(width: 8),
                            Text('Metode Pembayaran',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Simulasi MVP',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(
                      'Pilihan: ${widget.paymentMethod}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0F52BA)),
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentInstruction(widget.paymentMethod),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Price Breakdown Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rincian Pembayaran',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(height: 20),
                    _buildRowItem(
                        'Harga Tiket (${widget.selectedSeats.length}x)',
                        formattedTicketPrice),
                    if (extraCostTotal > 0) ...[
                      const SizedBox(height: 8),
                      _buildRowItem('Biaya Penjemputan (Door-to-Door)',
                          formattedExtraCost),
                    ],
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(
                          formattedTotalPrice,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.teal),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Passenger Checkbox Confirmation
            CheckboxListTile(
              value: _isConfirmedByPassenger,
              activeColor: const Color(0xFF0F52BA),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.white,
              title: const Text(
                'Saya telah memeriksa dan menyetujui seluruh data pesanan & syarat pembayaran manual di atas.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              onChanged: (val) {
                setState(() {
                  _isConfirmedByPassenger = val ?? false;
                });
              },
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_isConfirmedByPassenger && !_isSubmitting)
                    ? _processPayment
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F52BA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('BUAT PESANAN',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.5)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInstruction(String method) {
    if (method.contains('Bank')) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Instruksi Transfer Bank (Simulasi Manual):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(height: 4),
            Text('1. Transfer sesuai nominal total pembayaran.'),
            Text('2. Rekening BCA / Mandiri TravelTrack: 123-456-7890'),
            Text('3. Status pesanan awal: "Menunggu Konfirmasi".'),
          ],
        ),
      );
    } else if (method.contains('Pool')) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Instruksi Bayar di Pool:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(height: 4),
            Text('1. Lakukan pembayaran langsung di agen/loket pool.'),
            Text('2. Tunjukkan kode booking kepada staf loket.'),
            Text('3. Pembayaran diverifikasi oleh petugas pool.'),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Instruksi Pembayaran Manual:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(height: 4),
            Text('1. Pembayaran bersifat simulasi manual frontend MVP.'),
            Text(
                '2. Pesanan akan otomatis dicatat dengan status "Menunggu Konfirmasi".'),
          ],
        ),
      );
    }
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }

  Future<void> _processPayment() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final extraCost = widget.serviceType == 'Door to Door' ? 15000 : 0;
    final totalPrice =
        (widget.travel.price + extraCost) * widget.selectedSeats.length;

    try {
      final bookingId = await BookingService.createBooking(
        travel: widget.travel,
        passengerName: widget.passengerName,
        passengerPhone: widget.passengerPhone,
        selectedSeats: widget.selectedSeats,
        serviceType: widget.serviceType,
        pickupAddress: widget.pickupAddress,
        notes: widget.notes,
        paymentMethod: widget.paymentMethod,
        totalPrice: totalPrice,
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Pesanan $bookingId berhasil dibuat! Status pesanan: Menunggu Konfirmasi.'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context); // close PaymentConfirmationScreen
      }
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // close BookingScreen
      }
      widget.onBookingCompleted(); // trigger tab to status
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      final errorMessage = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat pesanan: $errorMessage'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
