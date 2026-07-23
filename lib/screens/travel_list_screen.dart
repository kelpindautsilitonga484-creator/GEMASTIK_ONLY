import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/travel_model.dart';
import 'booking_screen.dart';

class TravelListScreen extends StatefulWidget {
  final VoidCallback onBookingSuccess;
  final String? initialOrigin;
  final String? initialDestination;

  const TravelListScreen({
    super.key,
    required this.onBookingSuccess,
    this.initialOrigin,
    this.initialDestination,
  });

  @override
  State<TravelListScreen> createState() => _TravelListScreenState();
}

class _TravelListScreenState extends State<TravelListScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  String _activeFilter = 'Semua';

  final List<String> _filters = [
    'Semua',
    'Door to Door',
    'Shuttle Bandara',
    'Terpagi',
    'Termurah',
    'Rating',
  ];

  @override
  void initState() {
    super.initState();
    String defaultText = '';
    if (widget.initialOrigin != null && widget.initialOrigin!.isNotEmpty) {
      defaultText = widget.initialOrigin!;
    }
    _searchController = TextEditingController(text: defaultText);
    _searchQuery = defaultText;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TravelModel> filteredList = TravelRepository.dummyTravels.where((t) {
      final query = _searchQuery.toLowerCase();
      final matchesQuery = t.providerName.toLowerCase().contains(query) ||
          t.origin.toLowerCase().contains(query) ||
          t.destination.toLowerCase().contains(query) ||
          t.departurePool.toLowerCase().contains(query) ||
          t.vehicleType.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      if (_activeFilter == 'Door to Door') {
        return t.serviceType == 'Door to Door' || t.facilities.contains('Door to Door');
      } else if (_activeFilter == 'Shuttle Bandara') {
        return t.origin.toLowerCase().contains('kualanamu') ||
            t.destination.toLowerCase().contains('silangit') ||
            t.providerName.toLowerCase().contains('damri');
      }

      return true;
    }).toList();

    // Sort based on filter
    if (_activeFilter == 'Terpagi') {
      filteredList.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    } else if (_activeFilter == 'Termurah') {
      filteredList.sort((a, b) => a.price.compareTo(b.price));
    } else if (_activeFilter == 'Rating') {
      filteredList.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Daftar Travel Tersedia', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F52BA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            color: const Color(0xFF0F52BA),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Cari asal, tujuan, atau nama travel...',
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0F52BA)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // High Contrast Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _activeFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _activeFilter = filter);
                          },
                          selectedColor: Colors.white,
                          checkmarkColor: const Color(0xFF0F52BA),
                          backgroundColor: const Color(0xFF0A3C8A),
                          side: BorderSide(
                            color: isSelected ? Colors.white : Colors.white54,
                            width: 1.2,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF0F52BA) : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Travel Item List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_bus_filled_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Jadwal travel tidak ditemukan',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coba gunakan kata kunci pencarian yang lain.',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final travel = filteredList[index];
                      return _buildDetailedTravelCard(context, travel);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedTravelCard(BuildContext context, TravelModel travel) {
    final formattedPrice = 'Rp ${travel.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider Header & Plate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        travel.providerName,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${travel.vehicleType} • ${travel.plateNumber}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${travel.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Route & Timing Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(travel.departureTime, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA))),
                            const SizedBox(height: 2),
                            Text(travel.origin, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Icon(Icons.directions_bus, color: Colors.blue.shade400),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(travel.arrivalTime, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA))),
                            const SizedBox(height: 2),
                            Text(travel.destination, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Pool: ${travel.departurePool}',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Facilities Badges
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Text(
                    travel.serviceType,
                    style: TextStyle(fontSize: 11, color: Colors.teal.shade800, fontWeight: FontWeight.bold),
                  ),
                ),
                ...travel.facilities.map((fac) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      fac,
                      style: TextStyle(fontSize: 11, color: Colors.blue.shade800, fontWeight: FontWeight.w500),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Footer Price & Booking Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedPrice,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    Text(
                      'Tersedia ${travel.availableSeatsCount} / ${travel.totalSeats} Kursi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: travel.availableSeatsCount <= 2 ? Colors.red : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: travel.availableSeatsCount == 0
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                travel: travel,
                                onBookingCompleted: widget.onBookingSuccess,
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.event_seat_rounded, size: 18),
                  label: const Text('Pesan Kursi', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F52BA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
