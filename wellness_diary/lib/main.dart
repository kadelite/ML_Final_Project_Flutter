import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  runApp(const WellnessDiaryApp());
}

class WellnessDiaryApp extends StatelessWidget {
  const WellnessDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the little "DEBUG" banner
      title: 'Wellness Diary',
      theme: ThemeData(
        // Grit and Grace Colors! Black and Gold.
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color(0xFFFFD700), // This is the hex code for Gold!
        ),
      ),
      home:
          const DashboardScreen(), // This tells the app which screen to show first
    );
  }
}
