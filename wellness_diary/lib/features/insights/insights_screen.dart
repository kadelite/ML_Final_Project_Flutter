import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/database/database_helper.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String aiPrediction = "Select a category and tap 'Run AI Analysis'";
  Color statusColor = Colors.grey;
  bool isLoading = false;

  // Categories for your different datasets
  String selectedCategory = "Hypertension";
  final List<String> categories = ["Hypertension", "Heart Health", "Diabetes"];

  Future<void> runMultiExpertAI() async {
    setState(() => isLoading = true);

    try {
      final db = await DatabaseHelper.instance.database;
      final vitals = await db.query(
        'vitals_table',
        orderBy: 'id DESC',
        limit: 1,
      );

      if (vitals.isEmpty) {
        setState(() {
          aiPrediction = "Please log your Vitals first!";
          isLoading = false;
        });
        return;
      }

      // Prepare the data to send to your Python Service
      // We send the category name so the Python Brain knows which model to use
      final response = await http
          .post(
            Uri.parse('http://127.0.0.1:5000/predict'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'category': selectedCategory,
              'vitals': {
                'systolic': vitals.first['systolic'],
                'diastolic': vitals.first['diastolic'],
                'pulse': vitals.first['pulse'],
              },
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        int risk = result['risk_level'];

        setState(() {
          if (risk == 2) {
            aiPrediction = "High $selectedCategory Risk Detected!";
            statusColor = Colors.red;
          } else if (risk == 1) {
            aiPrediction = "Elevated Risk. Monitor closely.";
            statusColor = Colors.orange;
          } else {
            aiPrediction = "Your $selectedCategory levels are Normal.";
            statusColor = Colors.green;
          }
        });
      }
    } catch (e) {
      setState(() {
        aiPrediction =
            "Python Brain is Offline.\nStart 'brain_service.py' to analyze.";
        statusColor = Colors.red;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GnG Multi-Expert AI')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text(
              "Select Health Domain",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),

            // Category Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() => selectedCategory = newValue!);
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Result Display
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : Icon(Icons.analytics, size: 80, color: statusColor),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      aiPrediction,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: isLoading ? null : runMultiExpertAI,
                child: const Text(
                  "Run AI Analysis",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
