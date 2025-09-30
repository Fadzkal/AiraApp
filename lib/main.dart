// lib/main.dart
import 'package:aira/providers/monitoring_provider.dart'; // Nanti kita buat file ini
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:provider/provider.dart'; // Import Provider
import 'firebase_options.dart'; // File ini dibuat otomatis oleh FlutterFire CLI

// Ubah main menjadi async
void main() async {
  // Baris ini wajib ada
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AIRAApp());
}

class AIRAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Bungkus MaterialApp dengan ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (context) => MonitoringProvider(),
      child: MaterialApp(
        title: 'AIRA - Air Quality Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Color(0xFFF0F8F7),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
