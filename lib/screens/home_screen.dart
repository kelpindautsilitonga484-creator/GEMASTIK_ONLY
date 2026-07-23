import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/travel_model.dart';
import 'booking_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(String search)? onNavigateToTravelList;
  final VoidCallback onNavigateToBookings;

  const HomeScreen({
    super.key,
    required this.onNavigateToTravelList,
    required this.onNavigateToBookings,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedOrigin = 'Medan';
  String _selectedDestination = 'Parapat (Danau Toba)';
  DateTime _selectedDate = DateTime.now();

  final List<String> _cities = [
    'Medan',
    'Pematangsiantar',
    'Parapat (Danau Toba)',
    'Balige',
    'Tarutung',
    'Pangururan (Samosir)',
    'Sidikalang',
    'Berastagi',
    'Rantauprapat',
    'Panyabungan',
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularTravels = TravelRepository.dummyTravels;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Hero Section
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F52BA), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Selamat Datang,',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            'Posman Penumpang 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                          onPressed: widget.onNavigateToBookings,
                          tooltip: 'Tiket Saya',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Search Card
                  Card(
                    elevation: 6,
                    shadowColor: Colors.black.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.directions_bus_outlined, color: Color(0xFF0F52BA), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Cari Perjalanan Travel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Origin Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _cities.contains(_selectedOrigin) ? _selectedOrigin : _cities.first,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF0F52BA)),
                                items: _cities.map((city) {
                                  return DropdownMenuItem(
                                    value: city,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, color: Colors.teal, size: 18),
                                        const SizedBox(width: 8),
                                        Text('Dari: $city', style: const TextStyle(fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedOrigin = val);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Destination Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _cities.contains(_selectedDestination) ? _selectedDestination : _cities[1],
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF0F52BA)),
                                items: _cities.map((city) {
                                  return DropdownMenuItem(
                                    value: city,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.pin_drop_outlined, color: Colors.orange, size: 18),
                                        const SizedBox(width: 8),
                                        Text('Ke: $city', style: const TextStyle(fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedDestination = val);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Date Picker button
                          InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded, color: Color(0xFF0F52BA), size: 18),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Ubah',
                                    style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Search Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (widget.onNavigateToTravelList != null) {
                                  widget.onNavigateToTravelList!(_selectedDestination);
                                }
                              },
                              icon: const Icon(Icons.search_rounded, color: Colors.white),
                              label: const Text(
                                'CARI JADWAL TRAVEL',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F52BA),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Features Quick Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFeatureBadge(Icons.event_seat_rounded, 'Pilih Kursi', 'Bebas Pilih No Kursi'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFeatureBadge(Icons.qr_code_scanner_rounded, 'QRIS Instant', 'Bayar Cepat & Aman'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFeatureBadge(Icons.verified_rounded, 'Pasti Berangkat', 'Garansi Layanan'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jadwal Travel Populer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.onNavigateToTravelList != null) {
                        widget.onNavigateToTravelList!('');
                      }
                    },
                    child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF0F52BA), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Popular Travel List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: popularTravels.length > 3 ? 3 : popularTravels.length,
              itemBuilder: (context, index) {
                final travel = popularTravels[index];
                return _buildTravelCard(context, travel);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF0F52BA), size: 24),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTravelCard(BuildContext context, TravelModel travel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider & Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_bus_filled_rounded, color: Color(0xFF0F52BA), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      travel.providerName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${travel.rating}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Route & Time Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(travel.departureTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(travel.origin, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0F52BA), size: 20),
                    Text(travel.vehicleType, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(travel.arrivalTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(travel.destination, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Price & Book Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rp ${travel.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    Text(
                      'Sisa ${travel.availableSeatsCount} Kursi',
                      style: TextStyle(fontSize: 11, color: travel.availableSeatsCount <= 3 ? Colors.redAccent : Colors.grey.shade600, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          travel: travel,
                          onBookingCompleted: widget.onNavigateToBookings,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F52BA),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Pesan Kursi', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
