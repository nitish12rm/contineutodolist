import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../viewmodels/auth/auth_bloc.dart';
import '../../viewmodels/auth/auth_event.dart';
import '../../viewmodels/task/task_bloc.dart';
import '../../viewmodels/task/task_event.dart';
import '../../viewmodels/task/task_state.dart';
import 'package:intl/intl.dart';

import '../auth/login_view.dart';

class TaskScreen extends StatelessWidget {
  final String userId;

  const TaskScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository: TaskRepository())..add(LoadTasksEvent(userId)),
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tasks'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());

                  // Navigate to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: "Tasks"),
                Tab(text: "Completed Tasks"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Today's Tasks Tab
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoaded) {
                    final tasks = state.tasks
                        .where((task) => !task.isCompleted) // Filter incomplete tasks
                        .toList();
                    return _buildTaskList(context, tasks);
                  } else if (state is TaskError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('No tasks found.'));
                  }
                },
              ),
              // Completed Tasks Tab
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoaded) {
                    final tasks = state.tasks
                        .where((task) => task.isCompleted) // Filter completed tasks
                        .toList();
                    return _buildTaskList(context, tasks);
                  } else if (state is TaskError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('No tasks found.'));
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTaskDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  /// Build a list of tasks
  Widget _buildTaskList(BuildContext context, List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(
            task.title,
            style: task.isCompleted
                ? const TextStyle(decoration: TextDecoration.lineThrough) // Strikethrough for completed tasks
                : null,
          ),
          subtitle: Text(DateFormat('yyyy-MM-dd – HH:mm').format(task.createdAt)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  context.read<TaskBloc>().add(
                    UpdateTaskEvent(
                      task.copyWith(isCompleted: value ?? false),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteTaskDialog(context, task.id),
              ),
            ],
          ),
          onTap: () => _showEditTaskDialog(context, task),
        );
      },
    );
  }

  /// Show a dialog to add a new task
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: _titleController,
          decoration: const InputDecoration(hintText: 'Enter task title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final title = _titleController.text.trim();
              if (title.isNotEmpty) {
                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: userId,
                  title: title,
                  isCompleted: false,
                  createdAt: DateTime.now(),
                );
                context.read<TaskBloc>().add(AddTaskEvent(task));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a task title.')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  /// Show a dialog to edit an existing task
  void _showEditTaskDialog(BuildContext context, Task task) {
    final TextEditingController _titleController = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: _titleController,
          decoration: const InputDecoration(hintText: 'Enter task title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final title = _titleController.text.trim();
              if (title.isNotEmpty) {
                final updatedTask = task.copyWith(title: title);
                context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a task title.')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Show a dialog to confirm task deletion
  void _showDeleteTaskDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}