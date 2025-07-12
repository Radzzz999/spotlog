import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {}

class TaskFailure extends TaskState {
  final String error;

  TaskFailure(this.error);

  @override
  List<Object?> get props => [error];
}
