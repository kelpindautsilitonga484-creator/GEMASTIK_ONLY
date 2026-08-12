import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/travel_model.dart';

class TravelService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'travels';

  static Future<List<TravelModel>> getTravels() async {
    final snapshot = await _firestore.collection(_collectionPath).get();

    return snapshot.docs.map((doc) {
      return TravelModel.fromMap(
        doc.data(),
        documentId: doc.id,
      );
    }).toList();
  }

  static Future<List<TravelModel>> getPopularTravels({int limit = 3}) async {
    final snapshot = await _firestore
        .collection(_collectionPath)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return TravelModel.fromMap(
        doc.data(),
        documentId: doc.id,
      );
    }).toList();
  }
}
