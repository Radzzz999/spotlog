abstract class WorkerTaskEvent {}

class FetchWorkerTasksRequested extends WorkerTaskEvent {
  final String token;
  FetchWorkerTasksRequested(this.token);
}
