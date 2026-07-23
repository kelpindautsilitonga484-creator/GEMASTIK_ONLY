import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TravelTrackApp());
}

class TravelTrackApp extends StatelessWidget {
  const TravelTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelTrack - Penumpang (K1)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F52BA),
          primary: const Color(0xFF0F52BA),
          secondary: Colors.teal,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}