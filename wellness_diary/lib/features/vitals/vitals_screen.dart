import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  // 1. THE SAFETY LOCK: We create a key for our form
  final _formKey = GlobalKey<FormState>();

  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final pulseController = TextEditingController();

  void saveVitals() async {
    // 2. THE CHECKER: Before we talk to the database, we check if the form is valid!
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper.instance.database;

      await db.insert('vitals_table', {
        'systolic': int.parse(systolicController.text),
        'diastolic': int.parse(diastolicController.text),
        'pulse': int.parse(pulseController.text),
        'date': DateTime.now().toString(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vitals Saved Successfully! 🩺'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Your Vitals')),
      body: SafeArea(
        child: SingleChildScrollView(
          // SingleChildScrollView prevents the keyboard from squishing the screen!
          padding: const EdgeInsets.all(20.0),
          // 3. THE FORM: We wrap our TextFields inside a Form
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Upgraded to TextFormField for validation
                TextFormField(
                  controller: systolicController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Systolic (e.g., 120)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a number';
                    if (int.tryParse(value) == null)
                      return 'Must be a valid number';
                    return null; // Null means it passed the test!
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: diastolicController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Diastolic (e.g., 80)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a number';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: pulseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Pulse (e.g., 72)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a number';
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double
                      .infinity, // Makes the button stretch the whole width
                  height: 55, // Makes the button taller and easier to tap
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: const Color(0xFFFFD700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ), // Rounded corners!
                    ),
                    onPressed: saveVitals,
                    child: const Text(
                      'Save to Diary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
