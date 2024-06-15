import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/providers/task_provider.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _newTaskController,
              decoration: const InputDecoration(labelText: 'New Task'),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  final newTask =
                      Task(id: DateTime.now().toString(), title: value);
                  taskProvider.addTask(newTask);
                  _newTaskController.clear();
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          taskProvider.deleteTask(task.id);
                        },
                      ),
                      Checkbox(
                        value: task.completed,
                        onChanged: (bool? value) {
                          taskProvider.toggleTaskCompletion(task);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newTaskController.dispose(); // Dispose the text controller
    super.dispose();
  }
}
