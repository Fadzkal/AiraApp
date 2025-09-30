import 'package:flutter/material.dart';
import '../models/sensor_history.dart';

class MonitoringScreen extends StatelessWidget {
  // Tipe data diubah menjadi SensorHistory
  final SensorHistory sensorData;

  const MonitoringScreen({Key? key, required this.sensorData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Kondisi Ruangan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          const SizedBox(height: 20),
          _buildStatusCards(),
          const SizedBox(height: 30),
          const Text(
            'Data Sensor Real-time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00695C),
            ),
          ),
          const SizedBox(height: 15),
          _buildSensorGrid(),
          const SizedBox(height: 30),
          _buildPlantHealthCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            'Tanaman Sehat',
            '92%', // Placeholder
            Icons.eco,
            const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatusCard(
            'Kualitas Udara',
            '${sensorData.airQuality}', // Mengakses dari objek
            Icons.air,
            const Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSensorGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _buildSensorCard(
          'Suhu',
          '${sensorData.temperature.toStringAsFixed(1)}°C',
          Icons.thermostat,
          const Color(0xFFFF5722),
          _getTemperatureStatus(sensorData.temperature),
        ),
        _buildSensorCard(
          'Kelembaban Udara',
          '${sensorData.humidity.toStringAsFixed(0)}%',
          Icons.water_drop,
          const Color(0xFF2196F3),
          _getHumidityStatus(sensorData.humidity),
        ),
        // Placeholder untuk data yang mungkin belum ada di model SensorHistory
        _buildSensorCard(
          'Kelembaban Tanah',
          '78%',
          Icons.grass,
          const Color(0xFF4CAF50),
          _getSoilMoistureStatus(78.0),
        ),
        _buildSensorCard(
          'Intensitas Cahaya',
          '850 lux',
          Icons.wb_sunny,
          const Color(0xFFFFC107),
          _getLightStatus(850.0),
        ),
        _buildSensorCard(
          'Kualitas Udara',
          '${sensorData.airQuality}',
          Icons.air,
          const Color(0xFF00BCD4),
          _getAirQualityStatus(sensorData.airQuality.toDouble()),
        ),
        _buildSensorCard(
          'PPM (VOC)',
          '${sensorData.ppmVOC} ppm',
          Icons.science,
          const Color(0xFF9C27B0),
          _getVOCStatus(sensorData.ppmVOC.toDouble()),
        ),
      ],
    );
  }

  Widget _buildSensorCard(
      String title, String value, IconData icon, Color color, String status) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: _getStatusColor(status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantHealthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.eco,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          const Text(
            'Kesehatan Tanaman Optimal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Semua parameter dalam kondisi ideal untuk pertumbuhan tanaman yang sehat',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getTemperatureStatus(double temp) {
    if (temp < 18) return 'Dingin';
    if (temp > 28) return 'Panas';
    return 'Optimal';
  }

  String _getVOCStatus(double voc) {
    if (voc > 30) return 'Tinggi';
    if (voc > 20) return 'Sedang';
    return 'Rendah';
  }

  String _getHumidityStatus(double humidity) {
    if (humidity < 40) return 'Kering';
    if (humidity > 70) return 'Lembab';
    return 'Ideal';
  }

  String _getSoilMoistureStatus(double moisture) {
    if (moisture < 30) return 'Kering';
    if (moisture > 80) return 'Basah';
    return 'Baik';
  }

  String _getLightStatus(double light) {
    if (light < 200) return 'Gelap';
    if (light > 800) return 'Terang';
    return 'Cukup';
  }

  String _getAirQualityStatus(double quality) {
    if (quality < 50) return 'Buruk';
    if (quality < 80) return 'Sedang';
    return 'Baik';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Optimal':
      case 'Ideal':
      case 'Baik':
      case 'Cukup':
      case 'Netral':
        return const Color(0xFF4CAF50);
      case 'Sedang':
        return const Color(0xFFFFC107);
      default:
        return const Color(0xFFFF5722);
    }
  }
}
