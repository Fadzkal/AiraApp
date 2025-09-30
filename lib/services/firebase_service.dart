// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sensor_history.dart';
import '../models/user_notification.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mengambil data sensor TERBARU secara real-time dari subcollection 'history'
  Stream<SensorHistory?> getLatestSensorDataStream(String deviceId) {
    return _db
        .collection('devices')
        .doc(deviceId)
        .collection('history')
        .orderBy('createdAt', descending: true) // Urutkan dari yg terbaru
        .limit(1) // Ambil 1 dokumen teratas
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null; // Kembalikan null jika tidak ada data history
      }
      return SensorHistory.fromFirestore(snapshot.docs.first);
    });
  }

  // Mengambil semua notifikasi untuk user tertentu secara real-time
  Stream<List<UserNotification>> getNotificationsStream(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId) // Filter notifikasi untuk user ini
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserNotification.fromFirestore(doc))
            .toList());
  }
}
