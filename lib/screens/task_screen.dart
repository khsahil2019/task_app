import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/providers/task_provider.dart';
import 'completed_tasks_screen.dart'; // Import the new screen

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController _newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.done_all),
            label: Text('Completed Tasks'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CompletedTasksScreen()), // Navigate to completed tasks screen
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTaskController,
                    decoration: InputDecoration(
                      labelText: 'New Task',
                      hintText: 'Enter task name',
                      prefixIcon: Icon(Icons.add_box),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue.shade200, // Enabled border color
                          width: 2.0, // Border width
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue, // Focused border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                    cursorColor: Colors.blue,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        final newTask =
                            Task(id: DateTime.now().toString(), title: value);
                        taskProvider.addTask(newTask);
                        _newTaskController.clear(); // Clear text field
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final newTask = Task(
                        id: DateTime.now().toString(),
                        title: _newTaskController.text);
                    taskProvider.addTask(newTask);
                    _newTaskController.clear(); // Clear text field
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Card(
                  elevation: 3.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: task.completed ? Colors.grey : Colors.black,
                        decoration:
                            task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditTaskDialog(context, taskProvider, task);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                context, taskProvider, task);
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

  Future<void> _showEditTaskDialog(
      BuildContext context, TaskProvider taskProvider, Task task) async {
    TextEditingController controller = TextEditingController(text: task.title);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new task name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  task.title = controller.text;
                  taskProvider.updateTask(task);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, TaskProvider taskProvider, Task task) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                taskProvider.deleteTask(task.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
