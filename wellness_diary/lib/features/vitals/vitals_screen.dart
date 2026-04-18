import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  // These "Controllers" act like little hands that grab the numbers the user types
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final pulseController = TextEditingController();

  // This is the magic function that saves data to your phone's memory
  void saveVitals() async {
    // 1. Open the filing cabinet
    final db = await DatabaseHelper.instance.database;

    // 2. Slide a new piece of paper (data) into the 'vitals_table' drawer
    await db.insert('vitals_table', {
      'systolic': int.parse(systolicController.text),
      'diastolic': int.parse(diastolicController.text),
      'pulse': int.parse(pulseController.text),
      'date': DateTime.now().toString(), // Stamps today's date and time
    });

    // 3. Show a success message at the bottom of the screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vitals Saved Successfully! 🩺'),
        backgroundColor: Colors.green,
      ),
    );

    // 4. Close this room and go back to the Dashboard
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Your Vitals')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Box 1: Systolic
            TextField(
              controller: systolicController,
              keyboardType:
                  TextInputType.number, // Forces the number keyboard to pop up
              decoration: const InputDecoration(
                labelText: 'Systolic (Top Number e.g., 120)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Box 2: Diastolic
            TextField(
              controller: diastolicController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Diastolic (Bottom Number e.g., 80)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Box 3: Pulse
            TextField(
              controller: pulseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pulse (Heart Rate e.g., 72)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),

            // The big save button!
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: const Color(0xFFFFD700),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              onPressed:
                  saveVitals, // When clicked, run our magic save function
              child: const Text(
                'Save to Diary',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
