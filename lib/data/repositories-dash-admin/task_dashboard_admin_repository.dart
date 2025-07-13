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
}