import 'package:get/get.dart';
import '../services/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs;

  Future<void> signIn(String email, String password) async {
    try {
      isLoading(true);
      await _firebaseService.signIn(email, password);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading(true);
      await _firebaseService.signUp(email, password);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    Get.offAllNamed('/login');
  }
}