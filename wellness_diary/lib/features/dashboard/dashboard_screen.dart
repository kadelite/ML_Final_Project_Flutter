import 'package:flutter/material.dart';
import '../vitals/vitals_screen.dart';
import '../mood/mood_screen.dart';
import '../meds/meds_screen.dart';
import '../insights/insights_screen.dart';
import '../insights/consultation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Soft professional grey-white
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine grid columns based on window width
            int crossAxisCount = constraints.maxWidth > 1200
                ? 4
                : (constraints.maxWidth > 800 ? 3 : 2);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 48.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 48),

                  // Main Action Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.0, // Perfect squares for a sleek look
                    children: [
                      _buildActionCard(
                        context,
                        title: "Health Vitals",
                        icon: Icons.favorite_rounded,
                        accentColor: Colors.redAccent,
                        screen: const VitalsScreen(),
                      ),
                      _buildActionCard(
                        context,
                        title: "Mood Tracker",
                        icon: Icons.face_retouching_natural_rounded,
                        accentColor: Colors.orangeAccent,
                        screen: const MoodScreen(),
                      ),
                      _buildActionCard(
                        context,
                        title: "Medications",
                        icon: Icons.medication_liquid_rounded,
                        accentColor: Colors.blueAccent,
                        screen: const MedsScreen(),
                      ),
                      _buildActionCard(
                        context,
                        title: "AI Insights",
                        icon: Icons.query_stats_rounded,
                        accentColor: const Color(0xFFD4AF37), // GnG Gold
                        screen: const InsightsScreen(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Featured Wide Card for Consultation
                  _buildConsultationBanner(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back, Adekunle",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: Colors.black.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color accentColor,
    required Widget screen,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConsultationScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF333333)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFD4AF37),
              child: Icon(
                Icons.support_agent_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "AI Clinical Consultation",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Speak with your virtual expert for real-time health advice.",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFFD4AF37),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
