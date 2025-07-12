import 'package:spotlog/logic/task-worker/models/task_worker_model.dart';


abstract class WorkerTaskState {}

class WorkerTaskInitial extends WorkerTaskState {}

class WorkerTaskLoading extends WorkerTaskState {}

class WorkerTaskLoaded extends WorkerTaskState {
  final List<WorkerTaskModel> tasks;
  WorkerTaskLoaded(this.tasks);
}

class WorkerTaskFailure extends WorkerTaskState {
  final String message;

  WorkerTaskFailure(this.message);
}
