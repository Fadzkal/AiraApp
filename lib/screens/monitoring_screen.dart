import 'package:flutter/material.dart';

class MonitoringScreen extends StatelessWidget {
  final Map<String, dynamic> sensorData;

  const MonitoringScreen({Key? key, required this.sensorData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Salin-tempel seluruh isi widget MonitoringScreen dari main.dart lama ke sini
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Kondisi Ruangan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          SizedBox(height: 20),
          _buildStatusCards(),
          SizedBox(height: 30),
          Text(
            'Data Sensor Real-time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00695C),
            ),
          ),
          SizedBox(height: 15),
          _buildSensorGrid(),
          SizedBox(height: 30),
          _buildPlantHealthCard(),
        ],
      ),
    );
  }

  // Pindahkan semua method helper (_buildStatusCards, _buildSensorGrid, dll) ke sini
  Widget _buildStatusCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            'Tanaman Sehat',
            '92%',
            Icons.eco,
            Color(0xFF4CAF50),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildStatusCard(
            'Kualitas Udara',
            '${sensorData['airQuality'].toStringAsFixed(0)}%',
            Icons.air,
            Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 8),
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
          SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 5),
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
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _buildSensorCard(
          'Suhu',
          '${sensorData['temperature'].toStringAsFixed(1)}°C',
          Icons.thermostat,
          Color(0xFFFF5722),
          _getTemperatureStatus(sensorData['temperature']),
        ),
        _buildSensorCard(
          'Kelembaban Udara',
          '${sensorData['humidity'].toStringAsFixed(0)}%',
          Icons.water_drop,
          Color(0xFF2196F3),
          _getHumidityStatus(sensorData['humidity']),
        ),
        _buildSensorCard(
          'Kelembaban Tanah',
          '${sensorData['soilMoisture'].toStringAsFixed(0)}%',
          Icons.grass,
          Color(0xFF4CAF50),
          _getSoilMoistureStatus(sensorData['soilMoisture']),
        ),
        _buildSensorCard(
          'Intensitas Cahaya',
          '${sensorData['lightIntensity'].toStringAsFixed(0)} lux',
          Icons.wb_sunny,
          Color(0xFFFFC107),
          _getLightStatus(sensorData['lightIntensity']),
        ),
        _buildSensorCard(
          'pH Tanah',
          '${sensorData['ph'].toStringAsFixed(1)}',
          Icons.science,
          Color(0xFF9C27B0),
          _getPHStatus(sensorData['ph']),
        ),
        _buildSensorCard(
          'Kualitas Udara',
          '${sensorData['airQuality'].toStringAsFixed(0)}%',
          Icons.air,
          Color(0xFF00BCD4),
          _getAirQualityStatus(sensorData['airQuality']),
        ),
      ],
    );
  }

  Widget _buildSensorCard(
      String title, String value, IconData icon, Color color, String status) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
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
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
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
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.eco,
            size: 50,
            color: Colors.white,
          ),
          SizedBox(height: 15),
          Text(
            'Kesehatan Tanaman Optimal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
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

  String _getPHStatus(double ph) {
    if (ph < 6.0) return 'Asam';
    if (ph > 7.5) return 'Basa';
    return 'Netral';
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
        return Color(0xFF4CAF50);
      case 'Sedang':
        return Color(0xFFFFC107);
      default:
        return Color(0xFFFF5722);
    }
  }
}
