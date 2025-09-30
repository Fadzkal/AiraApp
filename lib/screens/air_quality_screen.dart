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
          _buildAirQualityMetrics(),
          const SizedBox(height: 25),
          _buildAirQualityRecommendations(),
          const SizedBox(height: 25),
          _buildAirPurificationActions(),
        ],
      ),
    );
  }

  // --- SEMUA METHOD HELPER YANG HILANG DITAMBAHKAN DI SINI ---

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

  Widget _buildAirQualityMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Parameter Kualitas Udara',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00695C),
          ),
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.9,
          children: [
            _buildAirMetricCard(
              'CO₂ Level',
              '${sensorData.co2Level.toStringAsFixed(0)} ppm',
              Icons.cloud,
              const Color(0xFF9C27B0),
              _getCO2Status(sensorData.co2Level),
              _getCO2Recommendation(sensorData.co2Level),
            ),
            _buildAirMetricCard(
              'PM2.5',
              '${sensorData.pm25.toStringAsFixed(1)} μg/m³',
              Icons.blur_on,
              const Color(0xFFFF5722),
              _getPM25Status(sensorData.pm25),
              _getPM25Recommendation(sensorData.pm25),
            ),
            _buildAirMetricCard(
              'PM10',
              '${sensorData.pm10.toStringAsFixed(1)} μg/m³',
              Icons.grain,
              const Color(0xFF795548),
              _getPM10Status(sensorData.pm10),
              _getPM10Recommendation(sensorData.pm10),
            ),
            _buildAirMetricCard(
              'VOC',
              '${sensorData.ppmVOC} ppm',
              Icons.science,
              const Color(0xFFE91E63),
              _getVOCStatus(sensorData.ppmVOC.toDouble()),
              _getVOCRecommendation(sensorData.ppmVOC.toDouble()),
            ),
            _buildAirMetricCard(
              'Oksigen',
              '${sensorData.oxygenLevel.toStringAsFixed(1)}%',
              Icons.eco,
              const Color(0xFF4CAF50),
              _getOxygenStatus(sensorData.oxygenLevel),
              'Level oksigen untuk fotosintesis',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAirMetricCard(String title, String value, IconData icon,
      Color color, String status, String recommendation) {
    bool isAlarm = status.contains('Bahaya') ||
        status.contains('Tinggi') ||
        status.contains('Buruk');

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isAlarm
            ? Border.all(color: Colors.red.withOpacity(0.5), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isAlarm ? 0.2 : 0.08),
            blurRadius: isAlarm ? 18 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isAlarm ? Colors.red[700] : color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColorForMetric(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                color: _getStatusColorForMetric(status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityRecommendations() {
    List<Map<String, dynamic>> recommendations = _getAirQualityRecommendations();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi Peningkatan Kualitas Udara',
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
                boxShadow: [
                  BoxShadow(
                    color: (rec['priority'] == 'high' ? Colors.red : Colors.grey)
                        .withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ... (konten rekomendasi)
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildAirPurificationActions() {
    return Container(
      // ... (kode untuk purification actions)
    );
  }


  // --- Helper Methods ---

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
      case 'Sangat Baik': return const Color(0xFF4CAF50);
      case 'Baik': return const Color(0xFF8BC34A);
      case 'Sedang': return const Color(0xFFFFC107);
      case 'Buruk': return const Color(0xFFFF9800);
      case 'Sangat Buruk': return const Color(0xFFFF5722);
      default: return const Color(0xFF9E9E9E);
    }
  }

  IconData _getAirQualityStatusIcon(String status) {
    switch (status) {
      case 'Sangat Baik': return Icons.sentiment_very_satisfied;
      case 'Baik': return Icons.sentiment_satisfied;
      case 'Sedang': return Icons.sentiment_neutral;
      case 'Buruk': return Icons.sentiment_dissatisfied;
      case 'Sangat Buruk': return Icons.sentiment_very_dissatisfied;
      default: return Icons.help;
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'Sangat Baik': return 'Udara sangat bersih dan sehat untuk tanaman';
      case 'Baik': return 'Kualitas udara baik untuk pertumbuhan optimal';
      case 'Sedang': return 'Perlu peningkatan kualitas udara';
      case 'Buruk': return 'Segera perbaiki sirkulasi udara';
      case 'Sangat Buruk': return 'TINDAKAN SEGERA DIPERLUKAN!';
      default: return 'Status tidak diketahui';
    }
  }

  String _getCO2Status(double co2) {
    if (co2 > 1000) return 'Bahaya';
    if (co2 > 700) return 'Tinggi';
    if (co2 > 500) return 'Sedang';
    return 'Baik';
  }

  String _getCO2Recommendation(double co2) {
    if (co2 > 1000) return 'Buka ventilasi segera!';
    if (co2 > 700) return 'Tingkatkan sirkulasi';
    return 'Ventilasi cukup baik';
  }

  String _getPM25Status(double pm25) {
    if (pm25 > 35) return 'Bahaya';
    if (pm25 > 25) return 'Buruk';
    if (pm25 > 15) return 'Sedang';
    return 'Baik';
  }

  String _getPM25Recommendation(double pm25) {
    if (pm25 > 35) return 'Gunakan air purifier!';
    if (pm25 > 25) return 'Tutup jendela';
    return 'Kualitas udara baik';
  }

  String _getPM10Status(double pm10) {
    if (pm10 > 50) return 'Bahaya';
    if (pm10 > 35) return 'Buruk';
    if (pm10 > 20) return 'Sedang';
    return 'Baik';
  }

  String _getPM10Recommendation(double pm10) {
    if (pm10 > 50) return 'Filter udara wajib!';
    if (pm10 > 35) return 'Hindari debu masuk';
    return 'Partikulat rendah';
  }

  String _getVOCStatus(double voc) {
    if (voc > 30) return 'Tinggi';
    if (voc > 20) return 'Sedang';
    return 'Rendah';
  }

  String _getVOCRecommendation(double voc) {
    if (voc > 30) return 'Cari sumber polutan!';
    if (voc > 20) return 'Ventilasi lebih';
    return 'VOC dalam batas aman';
  }

  String _getOxygenStatus(double oxygen) {
    if (oxygen < 19) return 'Rendah';
    if (oxygen > 23) return 'Tinggi';
    return 'Optimal';
  }

  Color _getStatusColorForMetric(String status) {
    if (status.contains('Bahaya') || status.contains('Buruk')) return Colors.red;
    if (status.contains('Tinggi') || status.contains('Sedang')) return Colors.orange;
    return const Color(0xFF4CAF50);
  }

  List<Map<String, dynamic>> _getAirQualityRecommendations() {
    List<Map<String, dynamic>> recommendations = [];

    if (sensorData.pm25 > 25) {
      recommendations.add({
        'title': 'Aktifkan Air Purifier dengan Filter HEPA',
        'description': 'PM2.5 tinggi dapat membahayakan kesehatan',
        'icon': Icons.air,
        'color': Colors.red,
        'priority': 'high',
      });
    }

    if (sensorData.co2Level > 800) {
      recommendations.add({
        'title': 'Buka Jendela dan Ventilasi',
        'description': 'CO2 tinggi menghambat fokus dan pernapasan',
        'icon': Icons.window,
        'color': Colors.orange,
        'priority': 'high',
      });
    }
    
    // Kamu bisa menambahkan lebih banyak rekomendasi
    return recommendations;
  }
}