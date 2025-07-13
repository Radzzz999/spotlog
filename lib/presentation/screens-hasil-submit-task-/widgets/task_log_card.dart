import 'package:flutter/material.dart';
import 'package:spotlog/logic/log-worker/models/log_model.dart';
import 'package:spotlog/logic/task-worker/models/task_worker_model.dart';


class TaskLogCard extends StatelessWidget {
  final WorkerTaskModel task;
  final LogModel? log;
  final VoidCallback onTap;

  const TaskLogCard({required this.task, this.log, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(log != null
          ? 'Status: ${log!.status}'
          : (task.description ?? 'Belum ada log')),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
