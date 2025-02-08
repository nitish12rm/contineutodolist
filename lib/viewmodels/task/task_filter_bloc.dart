import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum TaskFilter { all, open, closed }

class TaskFilterEvent extends Equatable {
  final TaskFilter filter;

  const TaskFilterEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

class TaskFilterState extends Equatable {
  final TaskFilter selectedFilter;

  const TaskFilterState(this.selectedFilter);

  @override
  List<Object> get props => [selectedFilter];
}

class TaskFilterBloc extends Bloc<TaskFilterEvent, TaskFilterState> {
  TaskFilterBloc() : super(const TaskFilterState(TaskFilter.all)) {
    on<TaskFilterEvent>((event, emit) {
      emit(TaskFilterState(event.filter));
    });
  }
}
