import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/data/repositories-task-worker/task_worker_repository.dart.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_event.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_state.dart';


class WorkerTaskBloc extends Bloc<WorkerTaskEvent, WorkerTaskState> {
  final WorkerTaskRepository repo;

  WorkerTaskBloc(this.repo) : super(WorkerTaskInitial()) {
    on<FetchWorkerTasksRequested>((event, emit) async {
      emit(WorkerTaskLoading());
      try {
        final tasks = await repo.fetchWorkerTasks(event.token);
        emit(WorkerTaskLoaded(tasks));
      } catch (e) {
        emit(WorkerTaskFailure(e.toString()));
      }
    });
  }
}
