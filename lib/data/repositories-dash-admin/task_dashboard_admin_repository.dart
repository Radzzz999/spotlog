import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotlog/logic/task-home-admin/models/task.dart';
import '../../../core/constants.dart';

class TaskDashboardAdminRepository {
  Future<List<TaskModel>> fetchAdminDashboardTasks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/tasks'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      final List<dynamic> data = parsed['data'];

      return data.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      throw Exception('Failed to load admin tasks: ${response.body}');
    }
  }

Future<void> updateTask({
  required int id,
  required String title,
  String? description,
  required int assignedTo,
  double? latitude,
  double? longitude,
  required String token,
}) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/tasks/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': title,
      'description': description,
      'assigned_to': assignedTo,
      'latitude': latitude,
      'longitude': longitude,
    }),
  );

  if (response.statusCode != 200) {
    print('Update error ${response.statusCode}: ${response.body}');
    throw Exception('Failed to update task: ${response.body}');
  }
}

Future<void> deleteTask(int id, String token) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/admin/tasks/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    print('Delete error ${response.statusCode}: ${response.body}');
    throw Exception('Failed to delete task: ${response.body}');
  }
}
}

