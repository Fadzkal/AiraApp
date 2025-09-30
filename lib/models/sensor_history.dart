import 'package:cloud_firestore/cloud_firestore.dart';

class SensorHistory {
  final int airQuality;
  final double humidity;
  final double temperature;
  final int ppmVOC;
  final Timestamp createdAt;
  final double co2Level;
  final double pm25;
  final double pm10;
  final double oxygenLevel;

  SensorHistory({
    required this.airQuality,
    required this.humidity,
    required this.temperature,
    required this.ppmVOC,
    required this.createdAt,
    required this.co2Level,
    required this.pm25,
    required this.pm10,
    required this.oxygenLevel,
  });

  factory SensorHistory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SensorHistory(
      airQuality: data['airQuality'] ?? 0,
      humidity: (data['humidity'] ?? 0.0).toDouble(),
      temperature: (data['temperature'] ?? 0.0).toDouble(),
      ppmVOC: data['ppmVOC'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      co2Level: (data['co2Level'] ?? 400.0).toDouble(),
      pm25: (data['pm25'] ?? 0.0).toDouble(),
      pm10: (data['pm10'] ?? 0.0).toDouble(),
      oxygenLevel: (data['oxygenLevel'] ?? 20.9).toDouble(),
    );
  }
}
