import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      isDarkMode.value = box.read('isDarkMode') ?? false;
    } catch (e) {
      isDarkMode.value = false;
      Get.snackbar('Error', 'Failed to load theme: $e');
    }
  }

  Future<void> toggleTheme() async {
    try {
      isDarkMode.value = !isDarkMode.value;
      await box.write('isDarkMode', isDarkMode.value);
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save theme: $e');
    }
  }
}