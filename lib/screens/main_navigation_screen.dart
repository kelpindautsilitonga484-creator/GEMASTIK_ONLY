import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'travel_list_screen.dart';
import 'booking_status_screen.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  String _activeSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index, {String search = ''}) {
    setState(() {
      _currentIndex = index;
      _activeSearchQuery = search;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onNavigateToTravelList: (search) => _onTabTapped(1, search: search),
        onNavigateToBookings: () => _onTabTapped(2),
      ),
      TravelListScreen(
        key: ValueKey(_activeSearchQuery),
        initialOrigin: _activeSearchQuery,
        onBookingSuccess: () => _onTabTapped(2),
      ),
      const BookingStatusScreen(),
      _buildProfileScreen(context),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0F52BA),
          unselectedItemColor: Colors.grey.shade500,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, color: Color(0xFF0F52BA)),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus_rounded),
              activeIcon: Icon(Icons.directions_bus_rounded, color: Color(0xFF0F52BA)),
              label: 'Cari Travel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_rounded),
              activeIcon: Icon(Icons.confirmation_number_rounded, color: Color(0xFF0F52BA)),
              label: 'Tiket Saya',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded, color: Color(0xFF0F52BA)),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profil Penumpang', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F52BA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: const Color(0xFF0F52BA).withValues(alpha: 0.15),
                    child: const Icon(Icons.person, size: 56, color: Color(0xFF0F52BA)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Posman Penumpang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            Text(
              'penumpang@traveltrack.com • 081234567890',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // Profile menu card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge_outlined, color: Color(0xFF0F52BA)),
                    title: const Text('Peran Aplikasi'),
                    subtitle: const Text('Frontend Penumpang (K1 - Posman)'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('K1', style: TextStyle(color: Color(0xFF0F52BA), fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.favorite_outline_rounded, color: Colors.redAccent),
                    title: const Text('Rute Favorit'),
                    subtitle: const Text('Medan ↔ Parapat (Danau Toba)'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_none_rounded, color: Colors.amber),
                    title: const Text('Notifikasi Pemesanan'),
                    subtitle: const Text('Aktif'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                label: const Text(
                  'Keluar Akun',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
