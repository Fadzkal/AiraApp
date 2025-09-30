import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  final String message;
  final String severity;
  final String type;
  final Timestamp createdAt;
  final bool dismissed;

  UserNotification({
    required this.message,
    required this.severity,
    required this.type,
    required this.createdAt,
    required this.dismissed,
  });

  factory UserNotification.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserNotification(
      message: data['message'] ?? '',
      severity: data['severity'] ?? 'low',
      type: data['type'] ?? 'Info',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      dismissed: data['dismissed'] ?? false,
    );
  }
}
