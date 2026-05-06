import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_screen.dart'; // Ensure path is correct

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GnGApp());
}

class GnGApp extends StatelessWidget {
  const GnGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GnG Wellness Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFD4AF37),
      ),
      // Remove the StreamBuilder and go straight to Dashboard
      home: const DashboardScreen(),
    );
  }
}
