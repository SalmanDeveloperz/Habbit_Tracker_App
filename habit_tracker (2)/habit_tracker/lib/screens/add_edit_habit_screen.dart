import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/habit_controller.dart';
import '../models/habit.dart';

class AddEditHabitScreen extends StatelessWidget {
  AddEditHabitScreen({super.key});
  final HabitController controller = Get.find();
  final Habit? habit = Get.arguments;
  final TextEditingController nameController = TextEditingController();
  final RxString frequency = 'Daily'.obs;
  final RxString category = 'General'.obs;

  @override
  Widget build(BuildContext context) {
    if (habit != null) {
      nameController.text = habit!.name;
      frequency.value = habit!.frequency;
      category.value = habit!.category;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          habit == null ? 'Add Habit' : 'Edit Habit',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Habit Name',
                prefixIcon: const Icon(Icons.task),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
              value: frequency.value,
              decoration: InputDecoration(
                labelText: 'Frequency',
                prefixIcon: const Icon(Icons.repeat),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ['Daily', 'Weekly', 'Monthly']
                  .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
                  .toList(),
              onChanged: (value) => frequency.value = value!,
            )),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
              value: category.value,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ['General', 'Health', 'Productivity', 'Personal']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) => category.value = value!,
            )),
            const SizedBox(height: 24),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  if (habit == null) {
                    controller.addHabit(nameController.text, frequency.value, category.value);
                  } else {
                    controller.updateHabit(habit!, nameController.text, frequency.value, category.value);
                  }
                } else {
                  Get.snackbar('Error', 'Habit name is required');
                }
              },
              child: Text(
                habit == null ? 'Add Habit' : 'Update Habit',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )),
          ],
        ),
      ),
    );
  }
}