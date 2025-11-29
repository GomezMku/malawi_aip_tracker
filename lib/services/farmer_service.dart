import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Added for debugPrint
import '../model/farmer.dart';
// Removed unused import: '../config/app_constants.dart'

class FarmerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createFarmerProfile(FarmerModel farmer) async {
    try {
      await _firestore
          .collection('farmers')
          .doc(farmer.uid)
          .set(farmer.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error creating farmer profile: $e');
      }
      return false;
    }
  }

  Future<FarmerModel?> getFarmerProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection('farmers')
          .doc(uid)
          .get();

      if (doc.exists) {
        return FarmerModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting farmer profile: $e');
      }
      return null;
    }
  }

  Future<bool> updateFarmerProfile(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection('farmers')
          .doc(uid)
          .update(updates);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating farmer profile: $e');
      }
      return false;
    }
  }

  Stream<List<FarmerModel>> getFarmersByVillage(String village) {
    return _firestore
        .collection('farmers')
        .where('village', isEqualTo: village)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FarmerModel.fromMap(doc.data()))
          .toList();
    });
  }
}