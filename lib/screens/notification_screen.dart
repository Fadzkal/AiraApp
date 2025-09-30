import 'package:flutter/material.dart';
import '../models/user_notification.dart'; // Import model
import 'package:intl/intl.dart'; // Import package untuk format tanggal

class NotificationScreen extends StatelessWidget {
  // DIPERBARUI: Tipe data diubah menjadi List<UserNotification>
  final List<UserNotification> notifications;

  const NotificationScreen({Key? key, required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return notifications.isEmpty
        ? const Center(
            child: Text(
              "Tidak ada notifikasi.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              return _buildNotificationCard(notifications[index]);
            },
          );
  }

  Widget _buildNotificationCard(UserNotification notification) {
    Color typeColor = _getNotificationColor(notification.severity);
    IconData icon = _getNotificationIcon(notification.type);
    bool isHighPriority = notification.severity.toLowerCase() == 'high' ||
        notification.severity.toLowerCase() == 'critical';

    // Format tanggal agar lebih mudah dibaca
    String formattedTime =
        DateFormat('d MMM yyyy, HH:mm').format(notification.createdAt.toDate());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isHighPriority ? Border.all(color: Colors.red, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: typeColor.withOpacity(isHighPriority ? 0.3 : 0.1),
            blurRadius: isHighPriority ? 20 : 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: typeColor, size: 26),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.type, // Judul dari tipe notifikasi
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isHighPriority
                        ? Colors.red[700]
                        : const Color(0xFF00695C),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  notification.message, // Pesan notifikasi
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedTime, // Waktu yang sudah diformat
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
      default:
        return Colors.green;
    }
  }

  IconData _getNotificationIcon(String type) {
    if (type.toLowerCase().contains('suhu')) {
      return Icons.thermostat;
    }
    if (type.toLowerCase().contains('lembab')) {
      return Icons.water_drop;
    }
    return Icons.notifications;
  }
}
