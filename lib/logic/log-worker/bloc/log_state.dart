import 'package:equatable/equatable.dart';
import 'package:spotlog/logic/log-worker/models/log_model.dart';


abstract class LogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogInitial extends LogState {}
class LogLoading extends LogState {}
class LogCreated extends LogState {
  final LogModel log;
  LogCreated(this.log);
  @override List<Object?> get props => [log];
}
class LogsLoaded extends LogState {
  final List<LogModel> logs;
  LogsLoaded(this.logs);
  @override List<Object?> get props => [logs];
}
class LogFailure extends LogState {
  final String message;
  LogFailure(this.message);
  @override List<Object?> get props => [message];
}
