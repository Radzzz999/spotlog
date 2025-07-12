import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssignTaskEvent extends TaskEvent {
  final String token;
  final String title;
  final String description;
  final int assignedTo;
  final double? latitude;
  final double? longitude;

  AssignTaskEvent({
    required this.token,
    required this.title,
    required this.description,
    required this.assignedTo,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [token, title, description, assignedTo, latitude, longitude];
}
