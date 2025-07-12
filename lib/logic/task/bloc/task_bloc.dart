import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/data/repositories-task/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<AssignTaskEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        await repository.createTask(
          event.token,
          event.title,
          event.description,
          event.assignedTo,
          event.latitude,
          event.longitude,
        );
        emit(TaskSuccess());
      } catch (e) {
        emit(TaskFailure(e.toString()));
      }
    });
  }
}
