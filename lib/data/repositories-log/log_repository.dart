import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotlog/logic/log-worker/models/log_model.dart';
import '../../core/constants.dart';


class LogRepository {
  Future<LogModel> createLog({
    required String token,
    required int taskId,
    required String description,
    required String photoPath,
    double? latitude,
    double? longitude,
  }) async {
    final uri = Uri.parse('$baseUrl/logs');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['task_id'] = taskId.toString();
    request.fields['description'] = description;
    if (latitude != null) request.fields['latitude'] = latitude.toString();
    if (longitude != null) request.fields['longitude'] = longitude.toString();
    request.files.add(await http.MultipartFile.fromPath('photo', photoPath));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final json = jsonDecode(body);
      return LogModel.fromJson(json['data']);
    }
    throw Exception('Failed to create log: $body');
  }

  Future<List<LogModel>> fetchUserLogs(String token) async {
    final resp = await http.get(
      Uri.parse('$baseUrl/logs'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (resp.statusCode == 200) {
    final parsed = jsonDecode(resp.body);
    final List<dynamic> data = parsed['data'];
    return data.map((j) => LogModel.fromJson(j)).toList();
  }
    throw Exception('Failed to load logs: ${resp.body}');
  }
}
