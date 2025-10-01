import 'package:flutter/material.dart';
import '../models/sensor_history.dart';
import '../widgets/trend_chart_painter.dart';

class AnalyticsScreen extends StatelessWidget {
  // Tipe data diubah menjadi SensorHistory
  final SensorHistory sensorData;

  const AnalyticsScreen({Key? key, required this.sensorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analitik & Laporan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          const SizedBox(height: 20),
          _buildAnalyticsCards(),
          const SizedBox(height: 30),
          _buildTrendChart(),
          const SizedBox(height: 30),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio:
          1.1, // Diubah dari 1.3 untuk memberi lebih banyak tinggi
      children: [
        // Kartu untuk Suhu
        _buildAnalyticsCard(
          'Suhu Udara',
          '${sensorData.temperature.toStringAsFixed(1)}°C',
          Icons.thermostat,
          const Color(0xFFFF5722),
        ),
        // Kartu untuk Kelembapan Udara
        _buildAnalyticsCard(
          'Kelembapan Udara',
          '${sensorData.humidity.toStringAsFixed(0)}%',
          Icons.water_drop,
          const Color(0xFF2196F3),
        ),
        // Kartu untuk Kualitas Udara
        _buildAnalyticsCard(
          'Kualitas Udara',
          '${sensorData.airQuality}',
          Icons.air,
          const Color(0xFF00BCD4),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00695C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tren 7 Hari Terakhir',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: CustomPaint(
              painter: TrendChartPainter(),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF4DD0E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BCD4).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Rekomendasi AI',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildRecommendationItem(
            '💧 Tingkatkan penyiraman 10% untuk minggu depan',
            'Berdasarkan prediksi cuaca dan pola pertumbuhan',
          ),
          const SizedBox(height: 10),
          _buildRecommendationItem(
            '🌡️ Tambah ventilasi saat suhu >26°C',
            'Optimalisasi sirkulasi udara untuk pertumbuhan',
          ),
          const SizedBox(height: 10),
          _buildRecommendationItem(
            '💡 Perpanjang pencahayaan 2 jam di musim hujan',
            'Kompensasi kurangnya sinar matahari alami',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
