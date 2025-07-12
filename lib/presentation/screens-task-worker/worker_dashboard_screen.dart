import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_bloc.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_event.dart';
import 'package:spotlog/logic/task-worker/bloc/task_worker_state.dart';
import 'package:spotlog/presentation/screens-log/create_log_screen.dart';
import 'worker_task_detail_screen.dart';

class WorkerDashboardScreen extends StatefulWidget {
  final String token;

  const WorkerDashboardScreen({super.key, required this.token});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    
    context.read<WorkerTaskBloc>().add(FetchWorkerTasksRequested(widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worker Dashboard')),
      body: BlocBuilder<WorkerTaskBloc, WorkerTaskState>(
        builder: (context, state) {
          if (state is WorkerTaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkerTaskLoaded) {
            final tasks = state.tasks;

            if (tasks.isEmpty) {
              return const Center(child: Text('No tasks available'));
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description ?? 'No description'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailScreen(task: task),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.assignment_turned_in),
                          tooltip: 'Kerjakan',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateLogScreen(
                                  token: widget.token,
                                  taskId: task.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is WorkerTaskFailure) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No tasks available'));
          }
        },
      ),
    );
  }
}
