// lib/providers/monitoring_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_history.dart';
import '../models/user_notification.dart';
import '../services/firebase_service.dart';

class MonitoringProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  SensorHistory? _latestHistory;
  List<UserNotification> _notifications = [];
  bool _isLoading = true;

  SensorHistory? get latestHistory => _latestHistory;
  List<UserNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;

  StreamSubscription? _historySubscription;
  StreamSubscription? _notificationSubscription;

  void startListening(String userId, String deviceId) {
    // Hentikan listener lama jika ada untuk mencegah kebocoran memori
    _historySubscription?.cancel();
    _notificationSubscription?.cancel();

    _isLoading = true;
    notifyListeners();

    // Mulai mendengarkan stream data sensor terbaru
    _historySubscription =
        _firebaseService.getLatestSensorDataStream(deviceId).listen((history) {
      _latestHistory = history;
      if (_isLoading) {
        _isLoading = false;
      }
      notifyListeners();
    });

    // Mulai mendengarkan stream notifikasi
    _notificationSubscription =
        _firebaseService.getNotificationsStream(userId).listen((notifs) {
      _notifications = notifs;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    // Pastikan untuk membatalkan subscription saat provider tidak lagi digunakan
    _historySubscription?.cancel();
    _notificationSubscription?.cancel();
    super.dispose();
  }
}
