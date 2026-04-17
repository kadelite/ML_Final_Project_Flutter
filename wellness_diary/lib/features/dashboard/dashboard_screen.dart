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
                // We will tell this button where to go in the next step!
                print("Time to log some data!");
              },
              child: const Text(
                'Log Daily Vitals',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
