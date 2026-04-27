import '../insights/insights_screen.dart';
import 'package:flutter/material.dart';
import '../vitals/vitals_screen.dart';
import '../mood/mood_screen.dart';
import '../meds/meds_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. RESPONSIVENESS: We ask the phone "How wide are you?"
    double screenWidth = MediaQuery.of(context).size.width;

    // If it's a wide screen (like PC or Tablet), use 3 or 4 columns. If phone, use 2.
    int gridColumns = screenWidth > 600 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GnG Wellness Hub',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
        elevation: 0, // Makes the header look modern and flat
      ),
      // SafeArea prevents our app from hiding under the iPhone notch or Android camera hole!
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back, Adekunle',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'What would you like to track today?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // 2. MATURE UI: A beautiful, automatically adjusting Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: gridColumns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildDashboardCard(
                      context,
                      title: 'Vitals',
                      icon: Icons.favorite,
                      color: Colors.redAccent,
                      targetScreen: const VitalsScreen(),
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Mood',
                      icon: Icons.emoji_emotions,
                      color: Colors.orangeAccent,
                      targetScreen: const MoodScreen(),
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Medications',
                      icon: Icons.medication,
                      color: Colors.blueAccent,
                      targetScreen: const MedsScreen(),
                    ),
                    _buildDashboardCard(
                      context,
                      title: 'Insights (AI)',
                      icon: Icons.auto_graph,
                      color: const Color(0xFFFFD700),
                      targetScreen: const InsightsScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. CLEAN CODE: We build a "Lego Blueprint" for our Cards so we don't repeat code
  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget? targetScreen,
  }) {
    return InkWell(
      // InkWell gives it that professional "ripple" effect when tapped
      onTap: () {
        if (targetScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI Insights coming soon!')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
