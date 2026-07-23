import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/booking_model.dart';

class BookingStatusScreen extends StatefulWidget {
  const BookingStatusScreen({super.key});

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showETicketDialog(BookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildETicketBottomSheet(booking),
    );
  }

  void _showLiveTrackingModal(BookingModel booking) {
    final travel = booking.travel;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.g_mobiledata_rounded, color: Colors.teal, size: 28),
            Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 24),
            SizedBox(width: 8),
            Text('Lacak Lokasi Travel (GPS)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(travel.providerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('${travel.vehicleType} • ${travel.plateNumber}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_pin_rounded, color: Color(0xFF0F52BA), size: 16),
                      const SizedBox(width: 4),
                      Text('Pengemudi: ${travel.driverName}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Status Posisi Terkini:', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.directions_bus_filled_rounded, color: Colors.teal, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Jalan Medan - Tebing Tinggi (Km 34)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Estimasi waktu penjemputan: 15 - 20 Menit Lagi',
              style: TextStyle(fontSize: 12, color: Colors.teal.shade800, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.map_rounded, size: 40, color: Colors.black38),
                        SizedBox(height: 4),
                        Text('Peta GPS Berjalan (Simulasi Live)', style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 40,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                      child: const Icon(Icons.directions_bus, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmCancelBooking(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Reservasi?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pemesanan tiket ${booking.bookingId} (${booking.travel.providerName})?\n\nDana akan dikembalikan sesuai ketentuan pembatalan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                TravelRepository.cancelBooking(booking.bookingId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pemesanan tiket berhasil dibatalkan.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BookingModel booking) {
    int rating = 5;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Ulasan Perjalanan: ${booking.travel.providerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Bagaimana pengalaman perjalanan Anda dengan pengemudi?'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      starIndex <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        rating = starIndex;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tulis komentar ulasan Anda (layanan, kenyamanan supir, tepat waktu)...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terima kasih! Ulasan Anda berhasil dikirim.'),
                    backgroundColor: Colors.teal,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F52BA),
                foregroundColor: Colors.white,
              ),
              child: const Text('Kirim Ulasan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeBookings = TravelRepository.userBookings.where((b) => b.status == 'Dikonfirmasi' || b.status == 'Menunggu Pembayaran').toList();
    final historyBookings = TravelRepository.userBookings.where((b) => b.status == 'Selesai' || b.status == 'Dibatalkan').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Status Pemesanan & Tiket', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F52BA),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Tiket Aktif'),
            Tab(text: 'Riwayat Pemesanan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(activeBookings, isActiveTab: true),
          _buildBookingList(historyBookings, isActiveTab: false),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings, {required bool isActiveTab}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActiveTab ? Icons.confirmation_number_outlined : Icons.history_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              isActiveTab ? 'Belum Ada Tiket Aktif' : 'Belum Ada Riwayat Pemesanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              isActiveTab ? 'Pesan tiket travel Anda di tab "Cari Travel".' : 'Riwayat perjalanan Anda yang lalu akan tampil di sini.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildTicketCard(booking);
      },
    );
  }

  Widget _buildTicketCard(BookingModel booking) {
    final travel = booking.travel;
    final formattedPrice = 'Rp ${booking.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    Color statusBgColor = Colors.teal.shade50;
    Color statusTextColor = Colors.teal;
    if (booking.status == 'Menunggu Pembayaran') {
      statusBgColor = Colors.amber.shade50;
      statusTextColor = Colors.amber.shade900;
    } else if (booking.status == 'Selesai') {
      statusBgColor = Colors.blue.shade50;
      statusTextColor = const Color(0xFF0F52BA);
    } else if (booking.status == 'Dibatalkan') {
      statusBgColor = Colors.red.shade50;
      statusTextColor = Colors.redAccent;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => _showETicketDialog(booking),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ticket Header (Code & Status)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.qr_code_rounded, color: Color(0xFF0F52BA), size: 20),
                      const SizedBox(width: 6),
                      Text(
                        booking.bookingId,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status,
                      style: TextStyle(color: statusTextColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Operator & Time
              Row(
                children: [
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
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jam: ${travel.departureTime} WIB • ${travel.vehicleType}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text('KURSI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA))),
                        const SizedBox(height: 2),
                        Text(
                          booking.selectedSeats.join(','),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (booking.status == 'Dikonfirmasi') ...[
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _showLiveTrackingModal(booking),
                          icon: const Icon(Icons.my_location_rounded, size: 16, color: Colors.teal),
                          label: const Text('Lacak GPS', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.teal),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _confirmCancelBooking(booking),
                          child: const Text('Batalkan', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                        ),
                      ],
                    ),
                  ] else if (booking.status == 'Selesai') ...[
                    OutlinedButton.icon(
                      onPressed: () => _showRatingDialog(booking),
                      icon: const Icon(Icons.star_half_rounded, size: 16, color: Colors.amber),
                      label: const Text('Beri Ulasan', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ] else ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Biaya', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        Text(
                          formattedPrice,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ],
                    ),
                  ],
                  ElevatedButton.icon(
                    onPressed: () => _showETicketDialog(booking),
                    icon: const Icon(Icons.receipt_long_rounded, size: 18),
                    label: const Text('E-Tiket', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F52BA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildETicketBottomSheet(BookingModel booking) {
    final travel = booking.travel;
    final formattedPrice = 'Rp ${booking.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.confirmation_number_rounded, color: Color(0xFF0F52BA), size: 24),
                SizedBox(width: 8),
                Text(
                  'E-TIKET RESERVASI TRAVEL',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code_2_rounded, size: 90, color: Color(0xFF0F52BA)),
                          const SizedBox(height: 4),
                          Text(
                            booking.bookingId,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tunjukkan QR Code ini kepada pengemudi travel saat penjemputan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Menghubungi Supir ${travel.driverName} (${travel.driverPhone})...'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
                icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
                label: Text('Hubungi Supir: ${travel.driverName} (${travel.driverPhone})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Operator Travel', travel.providerName),
                  const Divider(height: 14),
                  _buildInfoRow('Armada & Nopol', '${travel.vehicleType} (${travel.plateNumber})'),
                  const Divider(height: 14),
                  _buildInfoRow('Pengemudi / Supir', '${travel.driverName} (${travel.driverPhone})'),
                  const Divider(height: 14),
                  _buildInfoRow('Rute', '${travel.origin} ➔ ${travel.destination}'),
                  const Divider(height: 14),
                  _buildInfoRow('Pool Penjemputan', travel.departurePool),
                  const Divider(height: 14),
                  _buildInfoRow('Jam Keberangkatan', '${travel.departureTime} WIB'),
                  const Divider(height: 14),
                  _buildInfoRow('Nomor Kursi', booking.selectedSeats.join(', ')),
                  const Divider(height: 14),
                  _buildInfoRow('Nama Penumpang', booking.passengerName),
                  const Divider(height: 14),
                  _buildInfoRow('Metode Bayar', booking.paymentMethod),
                  const Divider(height: 14),
                  _buildInfoRow('Total Biaya', formattedPrice, isBold: true, color: Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Tutup'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('E-Tiket berhasil diunduh ke galeri ponsel!'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Simpan Tiket'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F52BA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}
