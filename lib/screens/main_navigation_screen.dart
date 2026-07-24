import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'travel_list_screen.dart';
import 'booking_status_screen.dart';
import 'profile_screen.dart';

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
      const ProfileScreen(),
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
              activeIcon:
                  Icon(Icons.directions_bus_rounded, color: Color(0xFF0F52BA)),
              label: 'Cari Travel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_rounded),
              activeIcon: Icon(Icons.confirmation_number_rounded,
                  color: Color(0xFF0F52BA)),
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
}
