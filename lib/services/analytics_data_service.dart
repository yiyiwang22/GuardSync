// lib/services/analytics_data_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/analytics_models.dart';

class AnalyticsDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Singleton pattern
  static final AnalyticsDataService _instance = AnalyticsDataService._internal();
  factory AnalyticsDataService() => _instance;
  AnalyticsDataService._internal();

  // Fetches data from Cloud Firestore based on range (30min, 1hr, etc.)
  Future<Map<String, dynamic>> getAnalyticsData(String range) async {
    try {
      // Accessing path: athletes/john_smith/history/{range}
      DocumentSnapshot doc = await _db
          .collection('athletes')
          .doc('john_smith')
          .collection('history')
          .doc(range)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'bundle': AnalyticsBundle.fromMap(data),
          'alertCount': data['alertCount'] ?? 0,
        };
      } else {
        throw Exception("Document $range not found in Firebase!");
      }
    } catch (e) {
      print("Firebase Error: $e");
      rethrow;
    }
  }
}