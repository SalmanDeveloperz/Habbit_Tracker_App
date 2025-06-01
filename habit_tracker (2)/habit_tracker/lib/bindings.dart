import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/habit_controller.dart';
import 'controllers/theme_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HabitController>(() => HabitController());
    Get.lazyPut<ThemeController>(() => ThemeController());
  }
}