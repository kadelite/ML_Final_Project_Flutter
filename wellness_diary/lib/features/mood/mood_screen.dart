import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  // This variable remembers which emoji the user clicked. (0 means none selected yet)
  int selectedMoodScore = 0;

  // The save function
  void saveMood() async {
    if (selectedMoodScore == 0) {
      // If they didn't click an emoji, tell them!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a mood first!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 1. Open the filing cabinet
    final db = await DatabaseHelper.instance.database;

    // 2. Slide the mood number into the 'mood_table' drawer
    await db.insert('mood_table', {
      'mood_score': selectedMoodScore,
      'date': DateTime.now().toString(),
    });

    // 3. Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood Saved! 🧠'),
        backgroundColor: Colors.green,
      ),
    );

    // 4. Go back to Dashboard
    Navigator.pop(context);
  }

  // A little helper tool to draw our emoji buttons
  Widget moodButton(String emoji, int score, String label) {
    bool isSelected =
        selectedMoodScore == score; // Check if this is the chosen one

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMoodScore = score; // Update the chosen score
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFD700)
              : Colors.white, // Turns Gold if selected!
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: isSelected ? 3 : 1),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How are you feeling?')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select your current mood:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // A row of our emoji buttons!
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                moodButton('😫', 1, 'Awful'),
                moodButton('🙁', 2, 'Bad'),
                moodButton('😐', 3, 'Okay'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                moodButton('🙂', 4, 'Good'),
                moodButton('😁', 5, 'Great'),
              ],
            ),

            const SizedBox(height: 50),

            // The Save Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: const Color(0xFFFFD700),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              onPressed: saveMood,
              child: const Text('Save Mood', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
