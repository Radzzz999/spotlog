import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/logic/log-worker/bloc/log_bloc.dart';
import 'package:spotlog/logic/log-worker/bloc/log_event.dart';
import 'package:spotlog/logic/log-worker/bloc/log_state.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_bloc.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_event.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_state.dart';
import 'package:spotlog/presentation/screens-hasil-submit-task-/widgets/task_log_card.dart';
import 'package:spotlog/presentation/screens-hasil-submit-task-/worker_task_detail_screen.dart';

class TasksCombinedScreen extends StatefulWidget {
  final String token;
  const TasksCombinedScreen({required this.token, super.key});

  @override
  State<TasksCombinedScreen> createState() => _TasksCombinedScreenState();
}

class _TasksCombinedScreenState extends State<TasksCombinedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkerTaskBloc>().add(FetchWorkerTasksRequested(widget.token));
    context.read<LogBloc>().add(FetchLogsRequested(widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas yang Sudah Dikerjakan')),
      body: BlocBuilder<WorkerTaskBloc, WorkerTaskState>(
        builder: (context, taskState) {
          return BlocBuilder<LogBloc, LogState>(
            builder: (context, logState) {
              if (taskState is WorkerTaskLoading || logState is LogLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (taskState is WorkerTaskFailure) {
                return Center(child: Text('Error task: ${taskState.message}'));
              }

              if (logState is LogFailure) {
                return Center(child: Text('Error log: ${logState.message}'));
              }

              if (taskState is WorkerTaskLoaded && logState is LogsLoaded) {
                final logsMap = {
                  for (var log in logState.logs) log.taskId: log
                };

                
                final tasksWithLog = taskState.tasks
                    .where((task) => logsMap.containsKey(task.id))
                    .toList();

                if (tasksWithLog.isEmpty) {
                  return const Center(child: Text('Belum ada tugas yang dikerjakan.'));
                }

                return ListView.builder(
                  itemCount: tasksWithLog.length,
                  itemBuilder: (context, index) {
                    final task = tasksWithLog[index];
                    final log = logsMap[task.id];

                    return TaskLogCard(
                      task: task,
                      log: log,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WorkerTaskDetailScreen(task: task, log: log),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              return const Center(child: Text('Tidak ada data'));
            },
          );
        },
      ),
    );
  }
}
