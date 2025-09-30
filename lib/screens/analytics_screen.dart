import 'package:flutter/material.dart';
import '../widgets/trend_chart_painter.dart'; // Import painter dari folder widgets

class AnalyticsScreen extends StatelessWidget {
  final Map<String, dynamic> sensorData;

  const AnalyticsScreen({Key? key, required this.sensorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analitik & Laporan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          SizedBox(height: 20),
          _buildAnalyticsCards(),
          SizedBox(height: 30),
          _buildTrendChart(),
          SizedBox(height: 30),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.3,
      children: [
        _buildAnalyticsCard(
          'Rata-rata Harian',
          'Suhu: 24.2°C\nKelembaban: 62%',
          Icons.trending_up,
          Color(0xFF4CAF50),
        ),
        _buildAnalyticsCard(
          'Konsumsi Air',
          '2.3L hari ini\n↑12% dari kemarin',
          Icons.water_drop,
          Color(0xFF2196F3),
        ),
        _buildAnalyticsCard(
          'Efisiensi Energi',
          '89% efisien\nHemat 15%',
          Icons.battery_charging_full,
          Color(0xFFFFC107),
        ),
        _buildAnalyticsCard(
          'Prediksi Panen',
          '23 hari lagi\nKondisi optimal',
          Icons.eco,
          Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00695C),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tren 7 Hari Terakhir',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          SizedBox(height: 20),
          Container(
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF4DD0E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00BCD4).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          SizedBox(height: 15),
          _buildRecommendationItem(
            '💧 Tingkatkan penyiraman 10% untuk minggu depan',
            'Berdasarkan prediksi cuaca dan pola pertumbuhan',
          ),
          SizedBox(height: 10),
          _buildRecommendationItem(
            '🌡️ Tambah ventilasi saat suhu >26°C',
            'Optimalisasi sirkulasi udara untuk pertumbuhan',
          ),
          SizedBox(height: 10),
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
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
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
