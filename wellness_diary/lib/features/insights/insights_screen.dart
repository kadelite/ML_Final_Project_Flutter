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
  String aiPrediction = "Select an Expert and tap 'Analyze'";
  Color statusColor = Colors.grey;
  bool isLoading = false;

  // All 6 experts we trained in Colab
  String selectedCategory = "Hypertension";
  final List<String> categories = [
    "Hypertension",
    "Diabetes",
    "Heart Disease",
    "Cardio Risk",
    "Mental Health",
    "Hematology",
  ];

  Future<void> runExpertAnalysis() async {
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
          aiPrediction =
              "Log your Vitals first to provide a baseline for the AI.";
          isLoading = false;
        });
        return;
      }

      // We send the category to the Python Service so it picks the right .h5 model
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
                'age': 45, // Placeholder - usually pulled from user profile
              },
            }),
          )
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        int risk = result['risk_level'];

        setState(() {
          if (risk == 2) {
            aiPrediction =
                "CAUTION: High $selectedCategory Risk detected. Consult your physician.";
            statusColor = Colors.red;
          } else if (risk == 1) {
            aiPrediction =
                "MODERATE: $selectedCategory levels are slightly elevated.";
            statusColor = Colors.orange;
          } else {
            aiPrediction =
                "NORMAL: Your $selectedCategory assessment looks healthy.";
            statusColor = Colors.green;
          }
        });
      }
    } catch (e) {
      setState(() {
        aiPrediction =
            "Connection Failed.\nEnsure Python Brain Service is running on Port 5000.";
        statusColor = Colors.red;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GnG AI Intelligence Hub'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Specialty Expert",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Dropdown Selector with Premium Styling
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.black,
                  ),
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) =>
                      setState(() => selectedCategory = newValue!),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // AI Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: statusColor.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Icon(
                          selectedCategory == "Mental Health"
                              ? Icons.psychology
                              : Icons.verified_user,
                          size: 70,
                          color: statusColor,
                        ),
                  const SizedBox(height: 20),
                  Text(
                    aiPrediction,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor == Colors.grey
                          ? Colors.black54
                          : statusColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Primary Action Button
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: const Color(0xFFFFD700), // GnG Gold
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 5,
                ),
                onPressed: isLoading ? null : runExpertAnalysis,
                child: const Text(
                  "RUN AI DIAGNOSTICS",
                  style: TextStyle(fontSize: 18, letterSpacing: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
