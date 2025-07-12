import 'package:http/http.dart' as http;
import '../../core/constants.dart';

class TaskRepository {
  Future<void> createTask(
    String token,
    String title,
    String description,
    int assignedTo,
    double? latitude,
    double? longitude,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/tasks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
      body: {
        'title': title,
        'description': description,
        'assigned_to': assignedTo.toString(),
        'latitude': latitude?.toString() ?? '',
        'longitude': longitude?.toString() ?? '',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create task: ${response.body}');
    }
  }
}
