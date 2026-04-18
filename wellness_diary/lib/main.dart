import 'package:flutter/material.dart';
import 'dart:io'; // Lets the app know if it's on a phone or computer
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // The computer translator
import 'features/dashboard/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // --- THE SMART SWITCH ---
  // If we are testing on a computer (Windows, Mac, or Linux), turn on the translator!
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // -------------------------

  runApp(const WellnessDiaryApp());
}

class WellnessDiaryApp extends StatelessWidget {
  const WellnessDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wellness Diary',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color(0xFFFFD700),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
