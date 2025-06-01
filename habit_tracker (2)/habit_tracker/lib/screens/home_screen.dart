import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../controllers/habit_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HabitController controller = Get.find();
  final AuthController authController = Get.find();
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Habits',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Get.toNamed('/stats'),
            color: Colors.white,
          ),
          Obx(() => IconButton(
            icon: Icon(
              themeController.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => themeController.toggleTheme(),
          )),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
            color: Colors.white,
          ),
        ],
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
      body: Column(
        children: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: controller.selectedCategory.value,
              items: controller.getCategories()
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) => controller.selectedCategory.value = value!,
            ),
          )),
          Expanded(
            child: Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.habits.isEmpty
                ? Center(
              child: Text(
                'No habits yet. Add one!',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: controller.habits
                  .where((h) =>
              controller.selectedCategory.value == 'All' ||
                  h.category == controller.selectedCategory.value)
                  .length,
              itemBuilder: (context, index) {
                final filteredHabits = controller.habits
                    .where((h) =>
                controller.selectedCategory.value == 'All' ||
                    h.category == controller.selectedCategory.value)
                    .toList();
                return HabitTile(habit: filteredHabits[index]);
              },
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () => Get.toNamed('/add_edit_habit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}