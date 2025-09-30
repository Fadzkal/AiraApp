import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'monitoring_screen.dart';
import 'notification_screen.dart';
import 'air_quality_screen.dart';
import 'analytics_screen.dart';
import '../widgets/voice_assistant_dialog.dart';

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
    //... tambahkan notifikasi lainnya jika ada
  ];

  DateTime _lastNotificationTime = DateTime.now().subtract(Duration(hours: 1));

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

    // ... (sisa logika _checkAirQualityAlerts)
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
              // ... sisa content AlertDialog
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

  bool _hasHighPriorityNotifications() {
    return notifications.any((notification) =>
        notification['priority'] == 'high' ||
        notification['type'] == 'critical');
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
