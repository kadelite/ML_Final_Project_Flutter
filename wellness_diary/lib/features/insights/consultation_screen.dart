import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _result;
  bool _loading = false;

  Future<void> _getAdvice() async {
    setState(() => _loading = true);
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/consult'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': _controller.text}),
      );
      setState(() => _result = jsonDecode(response.body));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("AI Brain Offline")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GnG AI Consultation")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText:
                    "Describe how you feel (e.g., 'I have a bad headache')",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _getAdvice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Ask GnG AI",
                style: TextStyle(color: Color(0xFFFFD700)),
              ),
            ),
            const SizedBox(height: 30),
            if (_result != null) ...[
              _adviceCard(
                "Analysis",
                _result!['advice'],
                Icons.health_and_safety,
                Colors.blue,
              ),
              _adviceCard(
                "Medication",
                _result!['medication'],
                Icons.medication,
                Colors.red,
              ),
              _adviceCard(
                "When to Take",
                _result!['schedule'],
                Icons.timer,
                Colors.orange,
              ),
              _adviceCard(
                "Precautions",
                _result!['precautions'],
                Icons.warning,
                Colors.amber,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _adviceCard(String title, String content, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}
