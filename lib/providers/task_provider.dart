import 'package:flutter/foundation.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  String _newTaskTitle = '';

  TaskProvider() {
    _taskService.getTasks().listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
  }

  List<Task> get tasks => _tasks;
  String get newTaskTitle => _newTaskTitle;

  set newTaskTitle(String value) {
    _newTaskTitle = value;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskService.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _taskService.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
  }

  void toggleTaskCompletion(Task task) {
    task.completed = !task.completed;
    updateTask(task); // Update task in Firestore
    notifyListeners();
  }
}
