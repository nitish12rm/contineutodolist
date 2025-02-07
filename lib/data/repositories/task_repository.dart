import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  // Check Internet Connectivity
  Future<bool> isOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Add Task (Offline First)
  Future<void> addTask(Task task) async {
    _taskBox.put(task.id, task); // Store task locally first

    if (await isOnline()) {
      await _firestore.collection('tasks').doc(task.id).set(task.toJson());
    }
  }

  // Update Task (Offline First)
  Future<void> updateTask(Task task) async {
    _taskBox.put(task.id, task); // Update local storage

    if (await isOnline()) {
      await _firestore.collection('tasks').doc(task.id).update(task.toJson());
    }
  }

  // Delete Task (Offline First)
  Future<void> deleteTask(String taskId) async {
    _taskBox.delete(taskId); // Remove from local storage

    if (await isOnline()) {
      await _firestore.collection('tasks').doc(taskId).delete();
    }
  }

  // Get Tasks (Offline-First)
  Stream<List<Task>> getTasks(String userId) async* {
    yield _taskBox.values.where((task) => task.userId == userId).toList();

    if (await isOnline()) {
      _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        final tasks = snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
        for (var task in tasks) {
          _taskBox.put(task.id, task); // Sync to Hive
        }
      });
    }
  }
}
