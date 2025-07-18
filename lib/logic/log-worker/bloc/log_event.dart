import 'package:equatable/equatable.dart';

abstract class LogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateLogRequested extends LogEvent {
  final String token;
  final int taskId;
  final String description;
  final String photoPath;
  final double? latitude, longitude;

  CreateLogRequested({
    required this.token,
    required this.taskId,
    required this.description,
    required this.photoPath,
    this.latitude, this.longitude,
  });

  @override
  List<Object?> get props => [token, taskId, description, photoPath];
}

class FetchLogsRequested extends LogEvent {
  final String token;
  FetchLogsRequested(this.token);
  @override
  List<Object?> get props => [token];
}

class SaveLogEvaluation extends LogEvent {
  final int logId;
  final bool isValidated;
  final String adminNote;

  SaveLogEvaluation({
    required this.logId,
    required this.isValidated,
    required this.adminNote,
  });

  @override
  List<Object?> get props => [logId, isValidated, adminNote];
}
