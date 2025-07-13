import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/data/repositories-dash-admin/task_dashboard_admin_repository.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_event.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_state.dart';


class TaskBlocAdmin extends Bloc<TaskEvent, TaskState> {
  final TaskDashboardAdminRepository repository;

  TaskBlocAdmin(this.repository) : super(TaskInitial()) {
  on<FetchTasksEvent>(_onFetchTasks);
  on<UpdateTaskEvent>(_onUpdateTask);
  on<DeleteTaskEvent>(_onDeleteTask);
}

Future<void> _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {
  emit(TaskLoading());
  try {
    final tasks = await repository.fetchAdminDashboardTasks(event.token);
    emit(TaskLoaded(tasks));
  } catch (e) {
    emit(TaskError(e.toString()));
  }
}

Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
  try {
    await repository.updateTask(
      id: event.id,
      title: event.title,
      description: event.description,
      assignedTo: event.assignedTo,
      latitude: event.latitude,
      longitude: event.longitude,
      token: event.token,
    );
    final tasks = await repository.fetchAdminDashboardTasks(event.token);
    emit(TaskLoaded(tasks));
  } catch (e) {
    emit(TaskError('Gagal update: $e'));
  }
}

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await repository.deleteTask(event.id, event.token);
      final tasks = await repository.fetchAdminDashboardTasks(event.token);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Gagal hapus: $e'));
    }
  }

}

