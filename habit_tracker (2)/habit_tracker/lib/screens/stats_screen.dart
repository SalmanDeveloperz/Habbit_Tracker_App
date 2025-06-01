import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/habit_controller.dart';
import '../widgets/stats_card.dart';

class StatsScreen extends StatelessWidget {
  StatsScreen({super.key});
  final HabitController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Habit Stats',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.tealAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StatsCard(
              title: 'Completion Rate',
              value: controller.getCompletionRate(),
              subtitle: 'Percentage of habits completed today',
            ),
            const SizedBox(height: 16),
            StatsCard(
              title: 'Average Streak',
              value: controller.habits.isEmpty
                  ? 0
                  : controller.habits.map((h) => h.streak).reduce((a, b) => a + b) /
                  controller.habits.length,
              subtitle: 'Average streak across all habits',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.exportHabits(),
              child: Text('Export Habits', style: GoogleFonts.poppins(fontSize: 16)),
            ),
          ],
        ),
      )),
    );
  }
}