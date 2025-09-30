import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;

  const NotificationScreen({Key? key, required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Salin-tempel seluruh isi widget NotificationScreen dari main.dart lama ke sini
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pemberitahuan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, index) {
              return _buildNotificationCard(notifications[index]);
            },
          ),
        ],
      ),
    );
  }

  // Pindahkan semua method helper (_buildNotificationCard, _getNotificationColor) ke sini
  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    Color typeColor = _getNotificationColor(notification['type']);
    bool isHighPriority = notification['priority'] == 'high' ||
        notification['type'] == 'critical';

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isHighPriority ? Border.all(color: Colors.red, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: typeColor.withOpacity(isHighPriority ? 0.3 : 0.1),
            blurRadius: isHighPriority ? 20 : 15,
            offset: Offset(0, 5),
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  notification['icon'],
                  color: typeColor,
                  size: 26,
                ),
                if (isHighPriority)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.priority_high,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isHighPriority
                              ? Colors.red[700]
                              : Color(0xFF00695C),
                        ),
                      ),
                    ),
                    if (isHighPriority)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'URGENT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  notification['message'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      notification['time'],
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

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Color(0xFFFFC107);
      case 'success':
        return Color(0xFF4CAF50);
      case 'excellent':
        return Color(0xFF4CAF50);
      case 'info':
        return Color(0xFF2196F3);
      default:
        return Color(0xFF00695C);
    }
  }
}
