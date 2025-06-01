import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/habit_controller.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  const HabitTile({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController controller = Get.find();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardColor.withOpacity(isDarkMode ? 0.8 : 1.0),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          habit.name,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequency: ${habit.frequency}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            Text(
              'Streak: ${habit.streak} days',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            Text(
              'Category: ${habit.category}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ],
        ),
        leading: Checkbox(
          value: habit.completed,
          onChanged: (value) => controller.toggleHabitCompletion(habit),
          activeColor: Colors.teal,
          checkColor: isDarkMode ? Colors.black : Colors.white,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: isDarkMode ? Colors.tealAccent : Colors.teal),
              onPressed: () => Get.toNamed('/add_edit_habit', arguments: habit),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: isDarkMode ? Colors.redAccent : Colors.red),
              onPressed: () => controller.deleteHabit(habit.id!),
            ),
          ],
        ),
      ),
    );
  }
}