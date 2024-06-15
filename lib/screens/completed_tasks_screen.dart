import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/providers/task_provider.dart';

class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Filter tasks to show only completed tasks
    List<Task> completedTasks =
        taskProvider.tasks.where((task) => task.completed).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Completed Tasks')),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              trailing: IconButton(
                icon: Icon(Icons.undo),
                onPressed: () {
                  taskProvider
                      .toggleTaskCompletion(task); // Mark task as incomplete
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
