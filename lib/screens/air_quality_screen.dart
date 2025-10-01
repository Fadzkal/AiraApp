import 'package:flutter/material.dart';
import '../models/sensor_history.dart';

class AirQualityScreen extends StatelessWidget {
  final SensorHistory sensorData;

  const AirQualityScreen({Key? key, required this.sensorData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kualitas Udara Ruangan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          const SizedBox(height: 20),
          _buildAirQualityStatus(),
          const SizedBox(height: 25),
          // Widget _buildAirQualityMetrics() telah dihapus.
          _buildAirQualityRecommendations(),
          const SizedBox(height: 25),
          // Anda dapat mengimplementasikan widget ini jika diperlukan
          // _buildAirPurificationActions(),
        ],
      ),
    );
  }

  Widget _buildAirQualityStatus() {
    String status = _getOverallAirQualityStatus();
    Color statusColor = _getAirQualityStatusColor(status);
    IconData statusIcon = _getAirQualityStatusIcon(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.8), statusColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(statusIcon, size: 60, color: Colors.white),
          const SizedBox(height: 15),
          Text(
            'Kualitas Udara: $status',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Index: ${sensorData.airQuality}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getStatusDescription(status),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // DIHAPUS: Widget _buildAirQualityMetrics() dan _buildAirMetricCard()
  // beserta semua helper method terkait (getCO2Status, getPM25Status, dll.)

  Widget _buildAirQualityRecommendations() {
    List<Map<String, dynamic>> recommendations =
        _getAirQualityRecommendations();

    // Jika tidak ada rekomendasi (misal, udara sangat baik), tampilkan pesan
    if (recommendations.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 40),
            const SizedBox(height: 10),
            Text(
              'Kualitas udara sudah optimal.\nTidak ada rekomendasi khusus saat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi Untuk Anda',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00695C),
          ),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            var rec = recommendations[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: (rec['priority'] == 'high'
                      ? Colors.red.withOpacity(0.5)
                      : Colors.transparent),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (rec['color'] as Color).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: (rec['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(rec['icon'], color: rec['color'], size: 24),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF333333)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rec['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // --- Helper Methods yang Tersisa dan Diperbarui ---

  String _getOverallAirQualityStatus() {
    double airQuality = sensorData.airQuality.toDouble();
    if (airQuality <= 50) return 'Sangat Baik';
    if (airQuality <= 100) return 'Baik';
    if (airQuality <= 150) return 'Sedang';
    if (airQuality <= 200) return 'Buruk';
    return 'Sangat Buruk';
  }

  Color _getAirQualityStatusColor(String status) {
    switch (status) {
      case 'Sangat Baik':
        return const Color(0xFF4CAF50);
      case 'Baik':
        return const Color(0xFF8BC34A);
      case 'Sedang':
        return const Color(0xFFFFC107);
      case 'Buruk':
        return const Color(0xFFFF9800);
      case 'Sangat Buruk':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData _getAirQualityStatusIcon(String status) {
    switch (status) {
      case 'Sangat Baik':
        return Icons.sentiment_very_satisfied;
      case 'Baik':
        return Icons.sentiment_satisfied;
      case 'Sedang':
        return Icons.sentiment_neutral;
      case 'Buruk':
        return Icons.sentiment_dissatisfied;
      case 'Sangat Buruk':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help;
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'Sangat Baik':
        return 'Udara sangat bersih dan sehat untuk tanaman';
      case 'Baik':
        return 'Kualitas udara baik untuk pertumbuhan optimal';
      case 'Sedang':
        return 'Perlu sedikit peningkatan kualitas udara';
      case 'Buruk':
        return 'Segera perbaiki sirkulasi udara di ruangan';
      case 'Sangat Buruk':
        return 'TINDAKAN SEGERA DIPERLUKAN!';
      default:
        return 'Status tidak diketahui';
    }
  }

  // DIPERBARUI: Logika rekomendasi kini berdasarkan status kualitas udara keseluruhan
  List<Map<String, dynamic>> _getAirQualityRecommendations() {
    String status = _getOverallAirQualityStatus();
    List<Map<String, dynamic>> recommendations = [];

    switch (status) {
      case 'Sangat Baik':
      case 'Baik':
        // Tidak ada rekomendasi, biarkan kosong agar tampil pesan optimal.
        break;
      case 'Sedang':
        recommendations.add({
          'title': 'Tingkatkan Sirkulasi Udara',
          'description':
              'Buka jendela atau nyalakan kipas angin secara berkala.',
          'icon': Icons.window,
          'color': Colors.blue,
          'priority': 'low',
        });
        recommendations.add({
          'title': 'Periksa Tanaman Penyaring Udara',
          'description':
              'Pastikan tanaman seperti Lidah Mertua atau Peace Lily dalam kondisi sehat.',
          'icon': Icons.eco,
          'color': Colors.green,
          'priority': 'low',
        });
        break;
      case 'Buruk':
        recommendations.add({
          'title': 'Aktifkan Air Purifier',
          'description':
              'Jika tersedia, nyalakan pembersih udara untuk menyaring polutan.',
          'icon': Icons.air,
          'color': Colors.orange,
          'priority': 'high',
        });
        recommendations.add({
          'title': 'Batasi Sumber Polusi',
          'description':
              'Hindari penggunaan aerosol atau aktivitas yang menimbulkan asap di dalam ruangan.',
          'icon': Icons.smoke_free,
          'color': Colors.deepOrange,
          'priority': 'high',
        });
        break;
      case 'Sangat Buruk':
        recommendations.add({
          'title': 'SEGERA Buka Semua Ventilasi',
          'description':
              'Buka semua jendela dan pintu untuk mengganti udara secepatnya.',
          'icon': Icons.warning_amber_rounded,
          'color': Colors.red[700],
          'priority': 'high',
        });
        recommendations.add({
          'title': 'Identifikasi Sumber Polutan Utama',
          'description':
              'Cari tahu penyebab utama kualitas udara yang sangat buruk di ruangan.',
          'icon': Icons.search,
          'color': Colors.red[900],
          'priority': 'high',
        });
        break;
    }
    return recommendations;
  }
}
