import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> register(Map<String, dynamic> userData) async {
    isLoading.value = true;
    try {
      final response = await ApiService.post('Registration', userData);
      if (response['status'] == 'success') {
        await saveToken(response['data']['_id']); // Save user ID or token
        Get.offNamed('/task'); // Navigate to task screen
      } else {
        Get.snackbar('Error', 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(Map<String, dynamic> loginData) async {
    isLoading.value = true;
    try {
      final response = await ApiService.post('Login', loginData);
      if (response['status'] == 'success') {
        token.value = response['token'];
        await saveToken(response['token']); // Save token locally
        Get.offNamed('/task'); // Navigate to task screen
      } else {
        Get.snackbar('Error', 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveToken(String authToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', authToken);
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedToken = prefs.getString('auth_token');
    if (savedToken != null) {
      token.value = savedToken;
      Get.offNamed('/task'); // User is logged in, go to task screen
    } else {
      Get.offNamed('/login'); // User is not logged in, go to login screen
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    token.value = '';
    Get.offAllNamed('/login'); // Clear navigation stack and go to login screen
  }
}
