import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Task
  Future<void> addTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).set(task.toJson());
    } catch (e) {
      print("Add Task Error: $e");
    }
  }

  // Update Task
  Future<void> updateTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).update(task.toJson());
    } catch (e) {
      print("Update Task Error: $e");
    }
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print("Delete Task Error: $e");
    }
  }

  // Get Tasks for Current User
  Stream<List<Task>> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId) // Fetch only user's tasks
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
  }
}
