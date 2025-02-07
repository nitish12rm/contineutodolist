import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await for (var tasks in taskRepository.getTasks(event.userId)) {
        emit(TaskLoaded(tasks));
      }
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.addTask(event.task);
      add(LoadTasksEvent(event.task.userId)); // Reload tasks after adding
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  void _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.updateTask(event.task);
      add(LoadTasksEvent(event.task.userId)); // Reload tasks after updating
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.taskId);
      add(LoadTasksEvent('')); // Reload tasks after deleting
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }
}