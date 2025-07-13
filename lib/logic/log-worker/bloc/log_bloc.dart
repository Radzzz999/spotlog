import 'package:flutter_bloc/flutter_bloc.dart';
import 'log_event.dart';
import 'log_state.dart';
import '../../../data/repositories-log/log_repository.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final LogRepository repo;
  LogBloc(this.repo) : super(LogInitial()) {
    on<CreateLogRequested>((e, emit) async {
      emit(LogLoading());
      try {
        final log = await repo.createLog(
          token: e.token,
          taskId: e.taskId,
          description: e.description,
          photoPath: e.photoPath,
          latitude: e.latitude,
          longitude: e.longitude,
        );
        emit(LogCreated(log));
      } catch (err) {
        emit(LogFailure(err.toString()));
      }
    });

    on<FetchLogsRequested>((e, emit) async {
      emit(LogLoading());
      try {
        final logs = await repo.fetchUserLogs(e.token);
        emit(LogsLoaded(logs));
      } catch (err) {
        emit(LogFailure(err.toString()));
      }
    });

    on<SaveLogEvaluation>((event, emit) {
  if (state is LogsLoaded) {
    final currentLogs = (state as LogsLoaded).logs;
    final updatedLogs = currentLogs.map((log) {
      return log.id == event.logId
        ? log.copyWith(
            isValidated: event.isValidated,
            adminNote: event.adminNote,
          )
        : log;
    }).toList();
  }
});
  }
}
