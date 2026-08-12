import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/passenger_profile_model.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PassengerProfileModel _profile = const PassengerProfileModel(
    name: 'Penumpang',
    email: '-',
    phoneNumber: '-',
  );

  Future<void> _navigateToEditProfile(
    PassengerProfileModel currentProfile,
  ) async {
    final updatedProfile = await Navigator.push<PassengerProfileModel>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          profile: currentProfile,
        ),
      ),
    );

    if (updatedProfile != null) {
      setState(() {
        _profile = updatedProfile;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Konfirmasi Keluar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun TravelTrack?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog

              try {
                await FirebaseAuth.instance.signOut();
              } on FirebaseException catch (e) {
                // Hanya diabaikan saat Firebase tidak tersedia di widget test.
                if (e.code != 'no-app') {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Gagal keluar dari akun. Silakan coba lagi.'),
                      backgroundColor: Colors.red,
                    ),
                  );

                  return;
                }
              }

              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? _getUserStream() {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots();
      }
    } on FirebaseException catch (e) {
      if (e.code != 'no-app') {
        debugPrint('Error accessing user stream: ${e.message}');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userStream = _getUserStream();

    if (userStream == null) {
      return _buildProfileBody(context, _profile);
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              title: const Text('Profil Penumpang',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: const Color(0xFF0F52BA),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: Color(0xFF0F52BA)),
            ),
          );
        }

        final currentUser = FirebaseAuth.instance.currentUser;
        PassengerProfileModel displayProfile = PassengerProfileModel(
          name: currentUser?.displayName ?? 'Penumpang',
          email: currentUser?.email ?? '-',
          phoneNumber: '-',
        );

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() ?? {};
          displayProfile = PassengerProfileModel(
            name: data['name']?.toString() ??
                currentUser?.displayName ??
                'Penumpang',
            email: data['email']?.toString() ?? currentUser?.email ?? '-',
            phoneNumber: data['phone']?.toString() ??
                data['phoneNumber']?.toString() ??
                '-',
          );
        }

        return _buildProfileBody(context, displayProfile);
      },
    );
  }

  Widget _buildProfileBody(
      BuildContext context, PassengerProfileModel displayProfile) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profil Penumpang',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                    backgroundColor:
                        const Color(0xFF0F52BA).withValues(alpha: 0.15),
                    child: const Icon(Icons.person,
                        size: 56, color: Color(0xFF0F52BA)),
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
                      child: const Icon(Icons.check,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              displayProfile.name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            Text(
              '${displayProfile.email} • ${displayProfile.phoneNumber}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // Profile menu card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_outlined,
                        color: Color(0xFF0F52BA)),
                    title: const Text('Edit Profil'),
                    subtitle: const Text('Ubah nama dan nomor telepon'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      // Pass the active displayProfile to edit screen
                      _profile = displayProfile;
                      _navigateToEditProfile(displayProfile);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.badge_outlined,
                        color: Color(0xFF0F52BA)),
                    title: const Text('Peran Aplikasi'),
                    subtitle: const Text('Frontend Penumpang (K1 - Posman)'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('K1',
                          style: TextStyle(
                              color: Color(0xFF0F52BA),
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded,
                        color: Colors.teal),
                    title: const Text('Bantuan & Tentang Aplikasi'),
                    subtitle: const Text('TravelTrack Penumpang v1.0.0'),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'TravelTrack Penumpang',
                        applicationVersion: 'v1.0.0',
                        applicationIcon: const Icon(Icons.directions_bus,
                            color: Color(0xFF0F52BA), size: 40),
                        children: const [
                          Text(
                              'Aplikasi pemesanan dan pelacakan travel antar kota Sumatera Utara.'),
                        ],
                      );
                    },
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
                onPressed: _showLogoutConfirmationDialog,
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                label: const Text(
                  'Keluar Akun',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
