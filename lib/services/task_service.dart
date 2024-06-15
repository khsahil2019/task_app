import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/models/task.dart';

class TaskService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<List<Task>> getTasks() {
    return _tasksCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Task(
                id: doc.id,
                title: data['title'],
                completed: data['completed'] ?? false,
              );
            }).toList());
  }

  Future<void> addTask(Task task) async {
    await _tasksCollection.add(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String id) async {
    await _tasksCollection.doc(id).delete();
  }
}
