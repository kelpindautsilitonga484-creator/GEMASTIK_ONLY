import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> updateDriverLocation({
    required String driverId,
    required String travelId,
    required Position position,
    required bool isActive,
  }) async {
    await _firestore.collection('travel_locations').doc(driverId).set({
      'driverId': driverId,
      'travelId': travelId,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'speed': position.speed,
      'heading': position.heading,
      'isActive': isActive,
      'status': isActive ? 'active' : 'inactive',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> listenToDriverLocation(
      String driverId) {
    return _firestore.collection('travel_locations').doc(driverId).snapshots();
  }
}
