import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/data/repositories-log/log_repository.dart';
import 'package:spotlog/data/repositories-task-worker/task_worker_repository.dart.dart';
import 'package:spotlog/data/repositories-task/task_repository.dart';
import 'package:spotlog/logic/log-worker/bloc/log_bloc.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_bloc.dart';
import 'package:spotlog/logic/task/bloc/task_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'logic/bloc/auth_bloc.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  final TaskRepository taskRepository = TaskRepository();
  final WorkerTaskRepository workerTaskRepository = WorkerTaskRepository();
  final LogRepository logRepo = LogRepository();

@override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => TaskBloc(taskRepository)),
        BlocProvider(create: (_) => WorkerTaskBloc(workerTaskRepository)),
        BlocProvider(create: (_) => LogBloc(logRepo)),
      ],
      child: MaterialApp(
        title: 'Spotlog App',
        home: LoginScreen(),
      ),
    );
  }
}