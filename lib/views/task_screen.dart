import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasker/controllers/auth_controller.dart';
import '../controllers/task_controller.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String currentStatus = 'New'; // Track the selected index (0 for New, 1 for Completed)

  @override
  void initState() {
    super.initState();
    taskController.fetchTasksByStatus(currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        actions: [
          IconButton(
            onPressed: () {
              authController.logout(); // Call logout function
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          // Segmented Control (ToggleButtons) to choose task status
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: currentStatus,
              onChanged: (String? newValue) {
                setState(() {
                  currentStatus = newValue!;
                });
                taskController.fetchTasksByStatus(currentStatus);  // Fetch tasks for the selected status
              },
              items: <String>['New', 'Completed'] // Status options
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // Task list
          Expanded(
            child: Obx(() {
              if (taskController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: taskController.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskController.tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            taskController.deleteTask(task.id);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.check_circle),
                          onPressed: () {
                            taskController.updateTaskStatus(task.id, 'Completed');
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                taskController.createTask({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'status': 'New',
                });
                titleController.clear();
                descriptionController.clear();
                Get.back();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
