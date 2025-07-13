abstract class WorkerTaskEvent {}

class FetchWorkerTasksRequested extends WorkerTaskEvent {
  final String token;
  final bool isAdmin;

  FetchWorkerTasksRequested(this.token, {this.isAdmin = false});
}
