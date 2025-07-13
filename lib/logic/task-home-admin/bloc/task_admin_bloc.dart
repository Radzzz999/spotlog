import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/data/repositories-dash-admin/task_dashboard_admin_repository.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_event.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_state.dart';


class TaskBlocAdmin extends Bloc<TaskEvent, TaskState> {
  final TaskDashboardAdminRepository repository;

  TaskBlocAdmin(this.repository) : super(TaskInitial()) {
    on<FetchTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await repository.fetchAdminDashboardTasks(event.token);
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
  }
}
