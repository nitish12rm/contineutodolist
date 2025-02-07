import 'package:equatable/equatable.dart';

import '../../data/models/task_model.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  final String userId;
  LoadTasksEvent(this.userId);
}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  DeleteTaskEvent(this.taskId);
}
