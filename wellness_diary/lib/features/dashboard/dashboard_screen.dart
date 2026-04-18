import '../meds/meds_screen.dart';
import '../vitals/vitals_screen.dart';
import '../mood/mood_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GnG Wellness Diary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers everything vertically
          children: [
            // A big heart icon
            const Icon(Icons.monitor_heart, color: Colors.redAccent, size: 100),
            const SizedBox(
              height: 20,
            ), // Empty space so things don't squish together
            // Welcome text
            const Text(
              'Welcome to your Health Hub',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Our first button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Button color
                foregroundColor: const Color(0xFFFFD700), // Text color (Gold)
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () {
  // This is how Flutter opens a new screen!
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const VitalsScreen()),
  );
},
              child: const Text(
                'Log Daily Vitals',
                style: TextStyle(fontSize: 18),
              ),
            ),

            // Our SECOND button (Mood)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background
                foregroundColor: Colors.black, // Black text
                side: const BorderSide(
                  color: Colors.black,
                  width: 2,
                ), // Black border
                padding: const EdgeInsets.symmetric(
                  horizontal: 55,
                  vertical: 15,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MoodScreen()),
                );
              },
              child: const Text('Log My Mood', style: TextStyle(fontSize: 18)),
            ),
            // Our THIRD button (Meds)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700), // Gold background!
                foregroundColor: Colors.black, // Black text
                padding: const EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 15,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MedsScreen()),
                );
              },
              child: const Text(
                'Add Medication',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
