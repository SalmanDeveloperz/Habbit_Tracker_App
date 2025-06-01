import 'package:get/get.dart';
import '../models/habit.dart';
import '../services/firebase_service.dart';

class HabitController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var habits = <Habit>[].obs;
  var isLoading = false.obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHabits();
  }

  void fetchHabits() {
    _firebaseService.getHabits().listen((habitList) {
      habits.assignAll(habitList);
    });
  }

  Future<void> addHabit(String name, String frequency, String category) async {
    try {
      isLoading(true);
      final habit = Habit(
        name: name,
        frequency: frequency,
        category: category,
        createdAt: DateTime.now(),
      );
      await _firebaseService.addHabit(habit);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    try {
      final today = DateTime.now();
      habit.completed = !habit.completed;
      if (habit.completed) {
        habit.completionDates.add(today);
        habit.streak = _calculateStreak(habit.completionDates);
      }
      await _firebaseService.updateHabit(habit);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateHabit(Habit habit, String name, String frequency, String category) async {
    try {
      isLoading(true);
      habit.name = name;
      habit.frequency = frequency;
      habit.category = category;
      await _firebaseService.updateHabit(habit);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _firebaseService.deleteHabit(habitId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> exportHabits() async {
    try {
      final habits = await _firebaseService.exportHabits();
      Get.snackbar('Success', 'Habits exported: ${habits.length}');
      // In a real app, save to a file or share
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> importHabits(List<Habit> habits) async {
    try {
      await _firebaseService.importHabits(habits);
      Get.snackbar('Success', 'Habits imported');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  int _calculateStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;
    dates.sort((a, b) => b.compareTo(a));
    int streak = 1;
    for (int i = 1; i < dates.length; i++) {
      if (dates[i].isBefore(dates[i - 1].subtract(const Duration(days: 1)))) {
        break;
      }
      streak++;
    }
    return streak;
  }

  double getCompletionRate() {
    if (habits.isEmpty) return 0.0;
    final completed = habits.where((h) => h.completed).length;
    return (completed / habits.length) * 100;
  }

  List<String> getCategories() {
    final categories = habits.map((h) => h.category).toSet().toList();
    return ['All', ...categories];
  }
}