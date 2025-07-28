import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

import 'splash_screen.dart'; // Add this import

void main() {
  runApp(AIRAApp());
}

class AIRAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set preferred orientations to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'AIRA - Air Quality Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Color(0xFFF0F8F7),
      ),
      home: SplashScreen(), // Change this to SplashScreen
    );
  }
}

// ... rest of your existing code remains the same ...

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  bool _isVoiceActive = false;
  Timer? _dataUpdateTimer;

  // Sensor data
  Map<String, dynamic> sensorData = {
    'temperature': 24.5,
    'humidity': 65.0,
    'soilMoisture': 78.0,
    'lightIntensity': 850.0,
    'airQuality': 92.0,
    'ph': 6.8,
    'co2Level': 420.0,
    'pm25': 12.0,
    'pm10': 18.0,
    'voc': 15.0,
    'oxygenLevel': 20.8,
  };

  List<Map<String, dynamic>> notifications = [
    {
      'title': '🚨 Kualitas Udara Buruk!',
      'message': 'PM2.5 tinggi (45 μg/m³). Aktifkan air purifier segera!',
      'time': '2 menit lalu',
      'type': 'critical',
      'icon': Icons.warning,
      'priority': 'high',
    },
    {
      'title': '💨 CO2 Tinggi Terdeteksi',
      'message':
          'Level CO2 mencapai 850 ppm. Buka ventilasi untuk sirkulasi udara.',
      'time': '5 menit lalu',
      'type': 'warning',
      'icon': Icons.air,
      'priority': 'medium',
    },
    {
      'title': '✅ Kualitas Udara Sangat Baik',
      'message':
          'Semua parameter udara dalam kondisi optimal untuk kesehatan tanaman.',
      'time': '10 menit lalu',
      'type': 'success',
      'icon': Icons.check_circle,
      'priority': 'low',
    },
    {
      'title': '🌿 Oksigen Level Optimal',
      'message':
          'Kadar oksigen 20.8% - Sangat baik untuk fotosintesis tanaman.',
      'time': '12 menit lalu',
      'type': 'info',
      'icon': Icons.eco,
      'priority': 'low',
    },
    {
      'title': '⚠️ VOC Terdeteksi',
      'message':
          'Volatile Organic Compounds naik menjadi 28 ppb. Periksa sumber polutan.',
      'time': '15 menit lalu',
      'type': 'warning',
      'icon': Icons.science,
      'priority': 'medium',
    },
    {
      'title': '💧 Kelembaban Tanah Rendah',
      'message': 'Tanaman membutuhkan penyiraman',
      'time': '20 menit lalu',
      'type': 'warning',
      'icon': Icons.water_drop,
      'priority': 'medium',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Simulate real-time data updates
    _dataUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _updateSensorData();
    });
  }

  void _updateSensorData() {
    setState(() {
      final random = Random();
      sensorData['temperature'] = 20 + random.nextDouble() * 10;
      sensorData['humidity'] = 40 + random.nextDouble() * 40;
      sensorData['soilMoisture'] = 30 + random.nextDouble() * 50;
      sensorData['lightIntensity'] = 200 + random.nextDouble() * 800;
      sensorData['airQuality'] = 70 + random.nextDouble() * 30;
      sensorData['ph'] = 6.0 + random.nextDouble() * 2;
      sensorData['co2Level'] = 380 + random.nextDouble() * 400;
      sensorData['pm25'] = random.nextDouble() * 50;
      sensorData['pm10'] = random.nextDouble() * 80;
      sensorData['voc'] = random.nextDouble() * 40;
      sensorData['oxygenLevel'] = 19.5 + random.nextDouble() * 2;
    });

    // Check air quality and generate notifications
    _checkAirQualityAlerts();
  }

  void _checkAirQualityAlerts() {
    final now = DateTime.now();

    // Critical PM2.5 levels
    if (sensorData['pm25'] > 35) {
      _addAirQualityNotification(
        '🚨 BAHAYA! PM2.5 Sangat Tinggi',
        'Level PM2.5: ${sensorData['pm25'].toStringAsFixed(1)} μg/m³. SEGERA gunakan air purifier dan tutup jendela!',
        'critical',
        Icons.dangerous,
      );
    }

    // High CO2 levels
    if (sensorData['co2Level'] > 1000) {
      _addAirQualityNotification(
        '⚠️ CO2 Berbahaya!',
        'CO2: ${sensorData['co2Level'].toStringAsFixed(0)} ppm. Buka semua ventilasi SEKARANG!',
        'critical',
        Icons.warning,
      );
    }

    // High VOC levels
    if (sensorData['voc'] > 30) {
      _addAirQualityNotification(
        '🧪 VOC Tinggi Terdeteksi',
        'Senyawa organik berbahaya: ${sensorData['voc'].toStringAsFixed(1)} ppb. Periksa sumber polutan!',
        'warning',
        Icons.science,
      );
    }

    // Excellent air quality
    if (sensorData['airQuality'] > 95 &&
        sensorData['pm25'] < 10 &&
        sensorData['co2Level'] < 450) {
      _addAirQualityNotification(
        '🌟 Kualitas Udara SEMPURNA!',
        'Semua parameter udara dalam kondisi terbaik. Tanaman akan tumbuh optimal!',
        'excellent',
        Icons.star,
      );
    }
  }

  void _addAirQualityNotification(
      String title, String message, String type, IconData icon) {
    if (notifications.length > 0 &&
        notifications[0]['title'] == title &&
        DateTime.now().difference(_lastNotificationTime).inMinutes < 5) {
      return; // Prevent spam notifications
    }

    setState(() {
      notifications.insert(0, {
        'title': title,
        'message': message,
        'time': 'Baru saja',
        'type': type,
        'icon': icon,
        'priority': type == 'critical' ? 'high' : 'medium',
      });

      // Keep only last 10 notifications
      if (notifications.length > 10) {
        notifications = notifications.take(10).toList();
      }
    });

    _lastNotificationTime = DateTime.now();

    // Show popup for critical alerts
    if (type == 'critical') {
      _showCriticalAlert(title, message);
    }
  }

  DateTime _lastNotificationTime = DateTime.now().subtract(Duration(hours: 1));

  void _showCriticalAlert(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.emergency, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'PERINGATAN KRITIS!',
                  style: TextStyle(
                      color: Colors.red[800], fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange[700], size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tindakan segera diperlukan untuk kesehatan tanaman dan keselamatan ruangan!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('MENGERTI',
                  style: TextStyle(
                      color: Colors.red[700], fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _dataUpdateTimer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _toggleVoice() {
    setState(() {
      _isVoiceActive = !_isVoiceActive;
    });

    if (_isVoiceActive) {
      _showVoiceDialog();
    }
  }

  void _showVoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VoiceAssistantDialog(
          onClose: () {
            setState(() {
              _isVoiceActive = false;
            });
          },
          sensorData: sensorData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4DD0E1),
              Color(0xFF26A69A),
              Color(0xFF00695C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.eco,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AIRA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Smart Air Quality Monitor',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF0F8F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 - (_animationController.value * 0.05),
              child: _getBodyContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return MonitoringScreen(sensorData: sensorData);
      case 1:
        return NotificationScreen(notifications: notifications);
      case 2:
        return AirQualityScreen(sensorData: sensorData);
      case 3:
        return AnalyticsScreen(sensorData: sensorData);
      default:
        return MonitoringScreen(sensorData: sensorData);
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.notifications_outlined),
                  if (_hasHighPriorityNotifications())
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: Stack(
                children: [
                  Icon(Icons.notifications),
                  if (_hasHighPriorityNotifications())
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Notifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.air_outlined),
              activeIcon: Icon(Icons.air),
              label: 'Kualitas Udara',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Analitik',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF00695C),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  bool _hasHighPriorityNotifications() {
    return notifications.any((notification) =>
        notification['priority'] == 'high' ||
        notification['type'] == 'critical');
  }

  Widget _buildVoiceButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF4DD0E1).withOpacity(0.3),
                blurRadius: 20 + (10 * _pulseController.value),
                spreadRadius: _isVoiceActive ? 5 : 0,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _toggleVoice,
            backgroundColor:
                _isVoiceActive ? Color(0xFF00BCD4) : Color(0xFF4DD0E1),
            elevation: 8,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(
                _isVoiceActive ? Icons.mic : Icons.mic_none,
                key: ValueKey(_isVoiceActive),
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Monitoring Screen
class MonitoringScreen extends StatelessWidget {
  final Map<String, dynamic> sensorData;

  const MonitoringScreen({Key? key, required this.sensorData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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

// Notification Screen
class NotificationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;

  const NotificationScreen({Key? key, required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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

// Air Quality Screen
class AirQualityScreen extends StatelessWidget {
  final Map<String, dynamic> sensorData;

  const AirQualityScreen({Key? key, required this.sensorData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kualitas Udara Ruangan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C),
            ),
          ),
          SizedBox(height: 20),
          _buildAirQualityStatus(),
          SizedBox(height: 25),
          _buildAirQualityMetrics(),
          SizedBox(height: 25),
          _buildAirQualityRecommendations(),
          SizedBox(height: 25),
          _buildAirPurificationActions(),
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
      padding: EdgeInsets.all(25),
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
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(statusIcon, size: 60, color: Colors.white),
          SizedBox(height: 15),
          Text(
            'Kualitas Udara: $status',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Index: ${sensorData['airQuality'].toStringAsFixed(0)}/100',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getStatusDescription(status),
              style: TextStyle(
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
        Text(
          'Parameter Kualitas Udara',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00695C),
          ),
        ),
        SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.9,
          children: [
            _buildAirMetricCard(
              'CO₂ Level',
              '${sensorData['co2Level'].toStringAsFixed(0)} ppm',
              Icons.cloud,
              Color(0xFF9C27B0),
              _getCO2Status(sensorData['co2Level']),
              _getCO2Recommendation(sensorData['co2Level']),
            ),
            _buildAirMetricCard(
              'PM2.5',
              '${sensorData['pm25'].toStringAsFixed(1)} μg/m³',
              Icons.blur_on,
              Color(0xFFFF5722),
              _getPM25Status(sensorData['pm25']),
              _getPM25Recommendation(sensorData['pm25']),
            ),
            _buildAirMetricCard(
              'PM10',
              '${sensorData['pm10'].toStringAsFixed(1)} μg/m³',
              Icons.grain,
              Color(0xFF795548),
              _getPM10Status(sensorData['pm10']),
              _getPM10Recommendation(sensorData['pm10']),
            ),
            _buildAirMetricCard(
              'VOC',
              '${sensorData['voc'].toStringAsFixed(1)} ppb',
              Icons.science,
              Color(0xFFE91E63),
              _getVOCStatus(sensorData['voc']),
              _getVOCRecommendation(sensorData['voc']),
            ),
            _buildAirMetricCard(
              'Oksigen',
              '${sensorData['oxygenLevel'].toStringAsFixed(1)}%',
              Icons.eco,
              Color(0xFF4CAF50),
              _getOxygenStatus(sensorData['oxygenLevel']),
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
      padding: EdgeInsets.all(18),
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
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: color, size: 26),
                if (isAlarm)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isAlarm ? Colors.red[700] : color,
            ),
          ),
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          SizedBox(height: 6),
          Text(
            recommendation,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityRecommendations() {
    List<Map<String, dynamic>> recommendations =
        _getAirQualityRecommendations();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rekomendasi Peningkatan Kualitas Udara',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00695C),
          ),
        ),
        SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            var rec = recommendations[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: rec['priority'] == 'high'
                      ? Colors.red.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
                  width: rec['priority'] == 'high' ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (rec['priority'] == 'high' ? Colors.red : Colors.grey)
                            .withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: rec['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(rec['icon'], color: rec['color'], size: 22),
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
                                rec['title'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00695C),
                                ),
                              ),
                            ),
                            if (rec['priority'] == 'high')
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'URGENT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          rec['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
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
              Icon(Icons.auto_fix_high, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Aksi Cepat Pembersihan Udara',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  'Aktifkan\nAir Purifier',
                  Icons.air,
                  () {},
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildQuickAction(
                  'Buka\nVentilasi',
                  Icons.wind_power,
                  () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  'Mode\nSirkulasi',
                  Icons.autorenew,
                  () {},
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildQuickAction(
                  'Emergency\nMode',
                  Icons.emergency,
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for air quality status
  String _getOverallAirQualityStatus() {
    double airQuality = sensorData['airQuality'];
    if (airQuality >= 90) return 'Sangat Baik';
    if (airQuality >= 70) return 'Baik';
    if (airQuality >= 50) return 'Sedang';
    if (airQuality >= 30) return 'Buruk';
    return 'Sangat Buruk';
  }

  Color _getAirQualityStatusColor(String status) {
    switch (status) {
      case 'Sangat Baik':
        return Color(0xFF4CAF50);
      case 'Baik':
        return Color(0xFF8BC34A);
      case 'Sedang':
        return Color(0xFFFFC107);
      case 'Buruk':
        return Color(0xFFFF9800);
      case 'Sangat Buruk':
        return Color(0xFFFF5722);
      default:
        return Color(0xFF9E9E9E);
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
        return 'Perlu peningkatan kualitas udara';
      case 'Buruk':
        return 'Segera perbaiki sirkulasi udara';
      case 'Sangat Buruk':
        return 'TINDAKAN SEGERA DIPERLUKAN!';
      default:
        return 'Status tidak diketahui';
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
    if (status.contains('Bahaya') || status.contains('Buruk'))
      return Colors.red;
    if (status.contains('Tinggi') || status.contains('Sedang'))
      return Colors.orange;
    return Color(0xFF4CAF50);
  }

  List<Map<String, dynamic>> _getAirQualityRecommendations() {
    List<Map<String, dynamic>> recommendations = [];

    if (sensorData['pm25'] > 25) {
      recommendations.add({
        'title': 'Aktifkan Air Purifier dengan Filter HEPA',
        'description':
            'PM2.5 tinggi dapat membahayakan kesehatan tanaman dan manusia',
        'icon': Icons.air,
        'color': Colors.red,
        'priority': 'high',
      });
    }

    if (sensorData['co2Level'] > 800) {
      recommendations.add({
        'title': 'Buka Jendela dan Ventilasi',
        'description':
            'CO2 tinggi menghambat fotosintesis dan pertumbuhan tanaman',
        'icon': Icons.window,
        'color': Colors.orange,
        'priority': 'high',
      });
    }

    if (sensorData['voc'] > 25) {
      recommendations.add({
        'title': 'Identifikasi Sumber VOC',
        'description': 'Periksa cat, pembersih, atau produk kimia di sekitar',
        'icon': Icons.search,
        'color': Colors.purple,
        'priority': 'medium',
      });
    }

    recommendations.add({
      'title': 'Tambahkan Tanaman Pembersih Udara',
      'description':
          'Sansevieria, Peace Lily, dan Spider Plant efektif menyaring udara',
      'icon': Icons.eco,
      'color': Color(0xFF4CAF50),
      'priority': 'low',
    });

    recommendations.add({
      'title': 'Atur Kelembaban Optimal',
      'description': 'Kelembaban 40-60% membantu mengurangi debu dan alergen',
      'icon': Icons.opacity,
      'color': Color(0xFF2196F3),
      'priority': 'medium',
    });

    return recommendations;
  }
}

// Analytics Screen
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

// Custom Chart Painter
class TrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF4DD0E1)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Sample data points for trend line
    List<Offset> points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.5),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.45, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width * 0.9, size.height * 0.3),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint = Paint()
      ..color = Color(0xFF00BCD4)
      ..style = PaintingStyle.fill;

    for (Offset point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      double y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Voice Assistant Dialog
class VoiceAssistantDialog extends StatefulWidget {
  final VoidCallback onClose;
  final Map<String, dynamic> sensorData;

  const VoiceAssistantDialog({
    Key? key,
    required this.onClose,
    required this.sensorData,
  }) : super(key: key);

  @override
  _VoiceAssistantDialogState createState() => _VoiceAssistantDialogState();
}

class _VoiceAssistantDialogState extends State<VoiceAssistantDialog>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  bool _isListening = true;
  String _currentText = "Mendengarkan...";
  List<String> _conversation = [];

  final List<Map<String, String>> _sampleQuestions = [
    {"question": "Bagaimana kondisi suhu ruangan?", "type": "temperature"},
    {"question": "Apakah tanaman perlu disiram?", "type": "watering"},
    {"question": "Bagaimana kualitas udara hari ini?", "type": "air"},
    {"question": "Apakah ada polutan berbahaya?", "type": "pollutants"},
    {"question": "Bagaimana level CO2 saat ini?", "type": "co2"},
    {"question": "Kapan waktu terbaik untuk panen?", "type": "harvest"},
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _startListening();
  }

  void _startListening() {
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentText = "Silakan tanya tentang kondisi ruangan...";
          _isListening = false;
        });
      }
    });
  }

  void _handleQuestionTap(String question, String type) {
    setState(() {
      _conversation.add("User: $question");
      _isListening = true;
      _currentText = "Memproses...";
    });

    Timer(Duration(seconds: 1), () {
      if (mounted) {
        String response = _generateResponse(type);
        setState(() {
          _conversation.add("AIRA: $response");
          _isListening = false;
          _currentText = "Ada pertanyaan lain?";
        });
      }
    });
  }

  String _generateResponse(String type) {
    switch (type) {
      case "temperature":
        double temp = widget.sensorData['temperature'];
        return "Suhu ruangan saat ini ${temp.toStringAsFixed(1)}°C. ${temp > 26 ? 'Agak hangat, pertimbangkan untuk menambah ventilasi.' : temp < 20 ? 'Agak dingin, tanaman mungkin perlu kehangatan.' : 'Suhu dalam kondisi optimal untuk pertumbuhan tanaman.'}";

      case "watering":
        double moisture = widget.sensorData['soilMoisture'];
        return "Kelembaban tanah ${moisture.toStringAsFixed(0)}%. ${moisture < 40 ? 'Tanaman membutuhkan penyiraman segera.' : moisture > 80 ? 'Tanah cukup lembab, tunda penyiraman.' : 'Kelembaban tanah dalam kondisi baik.'}";

      case "air":
        double air = widget.sensorData['airQuality'];
        double pm25 = widget.sensorData['pm25'];
        double co2 = widget.sensorData['co2Level'];
        String airStatus = air > 90
            ? 'sangat baik'
            : air > 70
                ? 'baik'
                : air > 50
                    ? 'sedang'
                    : 'buruk';
        String additionalInfo = '';

        if (pm25 > 25)
          additionalInfo +=
              ' PM2.5 tinggi (${pm25.toStringAsFixed(1)} μg/m³), segera gunakan air purifier.';
        if (co2 > 800)
          additionalInfo +=
              ' CO2 tinggi (${co2.toStringAsFixed(0)} ppm), buka ventilasi.';

        return "Kualitas udara saat ini $airStatus dengan index ${air.toStringAsFixed(0)}%.${additionalInfo.isEmpty ? ' Kondisi udara mendukung pertumbuhan tanaman yang sehat.' : additionalInfo}";

      case "harvest":
        return "Berdasarkan kondisi saat ini, perkiraan waktu panen optimal adalah 20-25 hari lagi. Pertahankan kondisi kelembaban dan suhu yang ada.";

      default:
        return "Maaf, saya belum memahami pertanyaan tersebut. Coba tanyakan tentang suhu, kelembaban, atau kondisi tanaman.";
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00BCD4),
              Color(0xFF4DD0E1),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF00BCD4).withOpacity(0.3),
              blurRadius: 25,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildDialogHeader(),
            _buildVoiceVisualizer(),
            _buildCurrentStatus(),
            _buildConversation(),
            _buildQuickQuestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.assistant, color: Colors.white, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'AIRA Voice Assistant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.onClose();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceVisualizer() {
    return Container(
      height: 120,
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return CustomPaint(
            painter: VoiceWavePainter(
              animationValue: _waveController.value,
              isActive: _isListening,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  Widget _buildCurrentStatus() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _isListening
                      ? Colors.red
                          .withOpacity(0.7 + 0.3 * _pulseController.value)
                      : Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  _currentText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConversation() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: _conversation.isEmpty
            ? Center(
                child: Text(
                  'Tanyakan sesuatu tentang kondisi ruangan...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: _conversation.length,
                itemBuilder: (context, index) {
                  bool isUser = _conversation[index].startsWith('User:');
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _conversation[index].substring(isUser ? 6 : 6),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            isUser ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pertanyaan Cepat:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sampleQuestions.map((q) {
              return GestureDetector(
                onTap: () => _handleQuestionTap(q['question']!, q['type']!),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    q['question']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Voice Wave Painter
class VoiceWavePainter extends CustomPainter {
  final double animationValue;
  final bool isActive;

  VoiceWavePainter({required this.animationValue, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final centerX = size.width / 2;

    if (isActive) {
      // Draw animated sound waves
      for (int i = 0; i < 5; i++) {
        double waveHeight = sin((animationValue * 2 * pi) + i) * 20 + 10;
        double x = centerX + (i - 2) * 15;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(x, centerY),
              width: 4,
              height: waveHeight,
            ),
            Radius.circular(2),
          ),
          paint,
        );
      }
    } else {
      // Draw static microphone icon
      canvas.drawCircle(
        Offset(centerX, centerY),
        30,
        paint..color = Colors.white.withOpacity(0.3),
      );

      // Microphone shape
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, centerY - 5),
            width: 20,
            height: 30,
          ),
          Radius.circular(10),
        ),
        paint..color = Colors.white,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 15),
          width: 2,
          height: 15,
        ),
        paint,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 25),
          width: 20,
          height: 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(VoiceWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isActive != isActive;
  }
}
