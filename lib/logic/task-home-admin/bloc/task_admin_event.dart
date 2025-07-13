abstract class TaskEvent {}

class FetchTasksEvent extends TaskEvent {
  final String token;
  FetchTasksEvent({required this.token});
}
