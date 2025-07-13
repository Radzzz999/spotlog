import 'package:flutter/material.dart';
import 'package:spotlog/logic/log-worker/models/log_model.dart';
import 'package:spotlog/logic/task-worker/models/task_worker_model.dart';

class TaskLogCard extends StatelessWidget {
  final WorkerTaskModel task;
  final LogModel? log;
  final VoidCallback onTap;

  const TaskLogCard({
    required this.task,
    this.log,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String subtitleText;

    if (log != null) {
      subtitleText = 'Status: ${log!.status}';

      if (log!.isValidated != null) {
        subtitleText +=
            ' • Evaluasi: ${log!.isValidated! ? "✅ Valid" : "❌ Tidak Valid"}';

        if (log!.adminNote?.isNotEmpty == true) {
          subtitleText += '\nCatatan: ${log!.adminNote}';
        }
      }
    } else {
      subtitleText = task.description ?? 'Belum ada log';
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                subtitleText,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}