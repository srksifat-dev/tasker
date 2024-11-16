import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchTasksByStatus(String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // Fetch tasks from the API with the given status
      final response = await ApiService.get('listTaskByStatus/$status', token: token);

      if (response['status'] == 'success') {
        // Map the 'data' field to a list of TaskModel instances
        final taskList = List<TaskModel>.from(
          response['data'].map((taskJson) => TaskModel.fromJson(taskJson)),
        );

        print('Fetched Tasks for Status "$status": ${taskList.map((task) => task.id).toList()}');

        // Now you can store the list of tasks in a state variable
        tasks.value = taskList;  // Assuming tasks is an RxList<TaskModel>
      } else {
        Get.snackbar('Error', 'Failed to fetch tasks');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'Something went wrong');
    }
  }



  Future<void> createTask(Map<String, dynamic> taskData) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await ApiService.post('createTask', taskData, token: token);

      // Debug log
      print('API Response: $response');

      if (response['status'] == 'success') {
        Get.snackbar('Success', 'Task created successfully!');
        fetchTasksByStatus('New'); // Refresh task list
      }
    } catch (e) {
      print('Error: $e'); // Log the error
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteTask(String taskId) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        Get.snackbar('Error', 'Authentication failed. Please log in again.');
        Get.offAllNamed('/login');
        return;
      }

      // Debugging: Log the taskId and token
      print('Deleting Task ID: $taskId');
      print('Token: $token');

      final response = await ApiService.delete('deleteTask/$taskId', token: token);

      // Log the response
      print('Delete Response: $response');

      if (response['status'] == 'success') {
        Get.snackbar('Success', 'Task deleted successfully!');
        fetchTasksByStatus('New'); // Refresh the task list
      } else {
        Get.snackbar('Error', 'Failed to delete task.');
      }
    } catch (e) {
      print('Error: $e'); // Log the error
      Get.snackbar('Error', 'Unable to delete task. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateTaskStatus(String taskId, String status) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await ApiService.get('updateTaskStatus/$taskId/$status', token: token);
      if (response['status'] == 'success') {
        Get.snackbar('Success', 'Task status updated!');
        fetchTasksByStatus('New'); // Refresh task list
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
