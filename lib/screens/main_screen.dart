import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/monitoring_provider.dart';
import '../models/user_notification.dart'; // Model notifikasi dibutuhkan untuk pengecekan prioritas

// Import semua layar dan widget yang dibutuhkan
import 'monitoring_screen.dart';
import 'notification_screen.dart';
import 'air_quality_screen.dart';
import 'analytics_screen.dart';
import 'community_screen.dart'; // Ditambahkan
import '../widgets/voice_assistant_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  bool _isVoiceActive = false;

  final String _currentUserId = "kDMu3d3LpiXysVTxBkSLUz6qG0W2";
  final String _currentDeviceId = "DEV-001";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MonitoringProvider>(context, listen: false)
          .startListening(_currentUserId, _currentDeviceId);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
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

  void _toggleVoice(BuildContext context) {
    setState(() {
      _isVoiceActive = !_isVoiceActive;
    });

    if (_isVoiceActive) {
      final provider = Provider.of<MonitoringProvider>(context, listen: false);
      _showVoiceDialog(provider);
    }
  }

  void _showVoiceDialog(MonitoringProvider provider) {
    final sensorDataMap = {
      'temperature': provider.latestHistory?.temperature ?? 0.0,
      'humidity': provider.latestHistory?.humidity ?? 0.0,
      'soilMoisture': 78.0,
      'lightIntensity': 850.0,
      'airQuality': provider.latestHistory?.airQuality ?? 0.0,
      'ph': 6.8,
      'co2Level': provider.latestHistory?.co2Level ?? 0.0,
      'pm25': provider.latestHistory?.pm25 ?? 0.0,
      'pm10': provider.latestHistory?.pm10 ?? 0.0,
      'voc': provider.latestHistory?.ppmVOC ?? 0.0,
      'oxygenLevel': provider.latestHistory?.oxygenLevel ?? 0.0,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VoiceAssistantDialog(
          onClose: () {
            setState(() {
              _isVoiceActive = false;
            });
          },
          sensorData: sensorDataMap,
        );
      },
    );
  }

  bool _hasHighPriorityNotifications(List<UserNotification> notifications) {
    return notifications.any((notification) =>
        notification.severity.toLowerCase() == 'high' ||
        notification.severity.toLowerCase() == 'critical');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MonitoringProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF0F8F7),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00695C),
              ),
            ),
          );
        }

        if (provider.latestHistory == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF0F8F7),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Tidak dapat memuat data sensor untuk perangkat $_currentDeviceId.\nPastikan perangkat mengirim data.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
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
                    child: _buildBody(provider),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar:
              _buildBottomNavigationBar(provider.notifications),
          floatingActionButton: _buildVoiceButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat, // Diubah
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(
                8), // Padding agar gambar tidak terlalu mepet
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.2), // Warna latar bisa disesuaikan
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            // === PERUBAHAN DI SINI ===
            child: Image.asset(
              'assets/images/ICON AIRA.png', // Path ke gambar logo Anda
              fit: BoxFit.contain, // Memastikan gambar pas di dalam container
            ),
            // === AKHIR PERUBAHAN ===
          ),
          const SizedBox(width: 15),
          const Expanded(
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
                    color: Colors.white70,
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
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(MonitoringProvider provider) {
    Widget currentPage;
    switch (_selectedIndex) {
      case 0:
        currentPage = MonitoringScreen(sensorData: provider.latestHistory!);
        break;
      case 1:
        currentPage = NotificationScreen(notifications: provider.notifications);
        break;
      case 2:
        currentPage = AirQualityScreen(sensorData: provider.latestHistory!);
        break;
      case 3:
        currentPage = AnalyticsScreen(sensorData: provider.latestHistory!);
        break;
      case 4: // Ditambahkan
        currentPage = const CommunityScreen();
        break;
      default:
        currentPage = MonitoringScreen(sensorData: provider.latestHistory!);
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8F7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 - (_animationController.value * 0.05),
              child: child,
            );
          },
          child: currentPage,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(List<UserNotification> notifications) {
    final hasHighPriority = _hasHighPriorityNotifications(notifications);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_outlined),
                  if (hasHighPriority)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.notifications),
              label: 'Notifikasi',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.air_outlined),
              activeIcon: Icon(Icons.air),
              label: 'Kualitas Udara',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Analitik',
            ),
            const BottomNavigationBarItem(
              // Ditambahkan
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Komunitas',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF00695C),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
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
                color: const Color(0xFF4DD0E1).withOpacity(0.3),
                blurRadius: 10 + (10 * _pulseController.value),
                spreadRadius: 5 + (5 * _pulseController.value),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _toggleVoice(context),
            backgroundColor: _isVoiceActive
                ? const Color(0xFF00BCD4)
                : const Color(0xFF4DD0E1),
            elevation: 8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                _isVoiceActive ? Icons.mic : Icons.mic_none,
                key: ValueKey<bool>(_isVoiceActive),
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        );
      },
    );
  }
}
