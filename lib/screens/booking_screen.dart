import 'package:flutter/material.dart';
import '../models/travel_model.dart';
import '../models/booking_model.dart';
import '../data/dummy_data.dart';

class BookingScreen extends StatefulWidget {
  final TravelModel travel;
  final VoidCallback onBookingCompleted;

  const BookingScreen({
    super.key,
    required this.travel,
    required this.onBookingCompleted,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Posman Penumpang');
  final _phoneController = TextEditingController(text: '081234567890');
  final _pickupAddressController = TextEditingController(text: 'Jl. Dr. Mansyur No. 120, Padang Bulan, Medan');
  final _notesController = TextEditingController(text: 'Penjemputan tepat waktu di depan gerbang utama');

  final List<String> _selectedSeats = [];
  String _selectedPaymentMethod = 'QRIS Instant';
  String _serviceTypeOption = 'Pool to Pool';
  bool _isSubmitting = false;

  final List<String> _paymentMethods = [
    'QRIS Instant',
    'Transfer Bank BCA',
    'Transfer Bank Mandiri',
    'E-Wallet GoPay',
    'E-Wallet ShopeePay',
  ];

  @override
  void initState() {
    super.initState();
    _serviceTypeOption = widget.travel.serviceType;
  }

  void _toggleSeat(String seatCode) {
    if (widget.travel.occupiedSeats.contains(seatCode)) return;

    setState(() {
      if (_selectedSeats.contains(seatCode)) {
        _selectedSeats.remove(seatCode);
      } else {
        _selectedSeats.add(seatCode);
      }
    });
  }

  void _submitBooking() {
    if (_selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih minimal 1 kursi terlebih dahulu!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final bookingId = 'TTR-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${(10 + TravelRepository.userBookings.length + 1)}';
      final extraCost = _serviceTypeOption == 'Door to Door' ? 15000 : 0;
      final totalPrice = (widget.travel.price + extraCost) * _selectedSeats.length;

      final newBooking = BookingModel(
        bookingId: bookingId,
        travel: widget.travel,
        passengerName: _nameController.text.trim(),
        passengerPhone: _phoneController.text.trim(),
        selectedSeats: List.from(_selectedSeats),
        totalPrice: totalPrice,
        paymentMethod: _selectedPaymentMethod,
        status: 'Dikonfirmasi',
        bookingDate: DateTime.now(),
      );

      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        TravelRepository.addBooking(newBooking);

        setState(() {
          _isSubmitting = false;
        });

        // Show Success Dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              children: const [
                Icon(Icons.check_circle_rounded, color: Colors.teal, size: 56),
                SizedBox(height: 10),
                Text(
                  'Pemesanan Berhasil!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kode Booking Anda: $bookingId',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F52BA), fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pengemudi: ${widget.travel.driverName}\nNomor Kursi: ${_selectedSeats.join(', ')}\nTotal Bayar: Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close booking screen
                    widget.onBookingCompleted(); // Navigate to Ticket Status tab
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F52BA),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('LIHAT E-TIKET SAYA', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final travel = widget.travel;
    final extraCost = _serviceTypeOption == 'Door to Door' ? 15000 : 0;
    final totalPrice = (travel.price + extraCost) * (_selectedSeats.isEmpty ? 1 : _selectedSeats.length);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Pilih Kursi & Booking', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F52BA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Travel Summary Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F52BA).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.directions_bus_rounded, color: Color(0xFF0F52BA), size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  travel.providerName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${travel.origin} ➔ ${travel.destination}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F52BA)),
                                ),
                                Text(
                                  'Jam: ${travel.departureTime} WIB • ${travel.vehicleType} (${travel.plateNumber})',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.pin_drop_rounded, size: 16, color: Colors.redAccent),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Pool Asal: ${travel.departurePool}',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Service Type Selector (Pool to Pool vs Door to Door)
              const Text(
                'Layanan Penjemputan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Pool to Pool (Kumpul di Pool)'),
                      selected: _serviceTypeOption == 'Pool to Pool',
                      selectedColor: const Color(0xFF0F52BA),
                      labelStyle: TextStyle(
                        color: _serviceTypeOption == 'Pool to Pool' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _serviceTypeOption = 'Pool to Pool');
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Door to Door (+Rp15rb)'),
                      selected: _serviceTypeOption == 'Door to Door',
                      selectedColor: Colors.teal,
                      labelStyle: TextStyle(
                        color: _serviceTypeOption == 'Door to Door' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _serviceTypeOption = 'Door to Door');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Interactive Seat Selection Grid
              const Text(
                'Denah & Pemilihan Kursi Armada',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 4),
              Text(
                'Ketuk nomor kursi yang ingin Anda tempati.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),

              // Seat Grid Container
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    // Front vehicle dashboard indicator
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.drive_eta_rounded, size: 18, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text('Pengemudi: ${travel.driverName}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                            ],
                          ),
                          const Icon(Icons.airline_seat_recline_extra_rounded, color: Colors.indigo, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Seat Grid 2 x 5 Layout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (Seats A)
                        Column(
                          children: ['1A', '2A', '3A', '4A', '5A'].map((seatCode) {
                            return _buildSeatItem(seatCode);
                          }).toList(),
                        ),
                        // Aisle
                        Container(
                          width: 24,
                          alignment: Alignment.center,
                          child: const Text('LORONG', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                        ),
                        // Right Column (Seats B)
                        Column(
                          children: ['1B', '2B', '3B', '4B', '5B'].map((seatCode) {
                            return _buildSeatItem(seatCode);
                          }).toList(),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Seat Legends
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem(Colors.grey.shade300, Colors.grey.shade700, 'Terisi'),
                        _buildLegendItem(Colors.white, const Color(0xFF0F52BA), 'Tersedia', hasBorder: true),
                        _buildLegendItem(Colors.teal, Colors.white, 'Dipilih'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Passenger Details Form
              const Text(
                'Data Pemesan & Penjemputan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap Penumpang',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'No. WhatsApp / HP Active',
                  prefixIcon: const Icon(Icons.phone_android_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'No HP wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              if (_serviceTypeOption == 'Door to Door') ...[
                TextFormField(
                  controller: _pickupAddressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Alamat Lengkap Penjemputan (Door-to-Door)',
                    hintText: 'Nama jalan, no rumah, patokan...',
                    prefixIcon: const Icon(Icons.home_work_outlined, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.teal.shade50.withValues(alpha: 0.3),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Alamat penjemputan wajib diisi' : null,
                ),
                const SizedBox(height: 12),
              ],

              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Catatan Khusus ke Pengemudi (Opsional)',
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method Selection
              const Text(
                'Metode Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),

              Column(
                children: _paymentMethods.map((method) {
                  final isSelected = _selectedPaymentMethod == method;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = method;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Card(
                      elevation: isSelected ? 2 : 0.5,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF0F52BA) : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              method.contains('QRIS')
                                  ? Icons.qr_code_2_rounded
                                  : method.contains('Bank')
                                      ? Icons.account_balance_rounded
                                      : Icons.account_balance_wallet_rounded,
                              color: const Color(0xFF0F52BA),
                            ),
                            const SizedBox(width: 12),
                            Text(method, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            const Spacer(),
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? const Color(0xFF0F52BA) : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Submit Button & Total Price Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -2)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Biaya (${_selectedSeats.length} Kursi)',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            Text(
                              'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                            ),
                          ],
                        ),
                        _selectedSeats.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)),
                                child: Text('Kursi: ${_selectedSeats.join(', ')}', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F52BA),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('KONFIRMASI & BAYAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatItem(String seatCode) {
    final isOccupied = widget.travel.occupiedSeats.contains(seatCode);
    final isSelected = _selectedSeats.contains(seatCode);

    Color bgColor = Colors.white;
    Color textColor = const Color(0xFF0F52BA);
    Border border = Border.all(color: const Color(0xFF0F52BA), width: 1.5);

    if (isOccupied) {
      bgColor = Colors.grey.shade300;
      textColor = Colors.grey.shade600;
      border = Border.all(color: Colors.grey.shade400);
    } else if (isSelected) {
      bgColor = Colors.teal;
      textColor = Colors.white;
      border = Border.all(color: Colors.teal, width: 2);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () => _toggleSeat(seatCode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: border,
            boxShadow: isSelected
                ? [
                    BoxShadow(color: Colors.teal.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4)),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isOccupied
                    ? Icons.person_rounded
                    : isSelected
                        ? Icons.check_circle_rounded
                        : Icons.event_seat_rounded,
                size: 20,
                color: textColor,
              ),
              const SizedBox(height: 2),
              Text(
                seatCode,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color bgColor, Color textColor, String label, {bool hasBorder = false}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
            border: hasBorder ? Border.all(color: textColor) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
