import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';

class MedsScreen extends StatefulWidget {
  const MedsScreen({super.key});

  @override
  State<MedsScreen> createState() => _MedsScreenState();
}

class _MedsScreenState extends State<MedsScreen> {
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final timeController = TextEditingController();

  void saveMedication() async {
    final db = await DatabaseHelper.instance.database;

    // Save to the meds_table drawer
    await db.insert('meds_table', {
      'drug_name': nameController.text,
      'dosage': dosageController.text,
      'time_to_take': timeController.text,
      'status': 0, // 0 means "Not Taken Yet", 1 will mean "Taken"
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medication Added! 💊'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medication')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Drug Name (e.g., Amlodipine)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: dosageController,
              decoration: const InputDecoration(
                labelText: 'Dosage (e.g., 5mg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time to take (e.g., Morning or 8:00 AM)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: const Color(0xFFFFD700), // GnG Gold
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              onPressed: saveMedication,
              child: const Text(
                'Save Medication',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
