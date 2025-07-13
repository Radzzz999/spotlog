abstract class TaskEvent {}

class FetchTasksEvent extends TaskEvent {
  final String token;
  FetchTasksEvent({required this.token});
}

class UpdateTaskEvent extends TaskEvent {
  final int id;
  final String title;
  final String? description;
  final int assignedTo;
  final double? latitude;
  final double? longitude;
  final String token;

  UpdateTaskEvent({
    required this.id,
    required this.title,
    this.description,
    required this.assignedTo,
    this.latitude,
    this.longitude,
    required this.token,
  });
}

class DeleteTaskEvent extends TaskEvent {
  final int id;
  final String token;

  DeleteTaskEvent(this.id, this.token);
}

