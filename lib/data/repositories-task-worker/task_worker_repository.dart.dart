import 'package:http/http.dart' as http;
import 'package:spotlog/logic/task-worker/models/task_worker_model.dart';
import 'dart:convert';


class WorkerTaskRepository {
  Future<List<WorkerTaskModel>> fetchWorkerTasks(String token) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/worker/tasks'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tasks = data['tasks'] as List;
      return tasks.map((t) => WorkerTaskModel.fromJson(t)).toList();
    } else {
      throw Exception('Failed to load worker tasks');
    }
  }
  Future<List<WorkerTaskModel>> fetchWorkerTasksAsAdmin(String token) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/admin/worker-tasks'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tasks = data['tasks'] as List;
      return tasks.map((t) => WorkerTaskModel.fromJson(t)).toList();
    } else {
      throw Exception('Failed to load tasks for admin');
    }
  }
}
