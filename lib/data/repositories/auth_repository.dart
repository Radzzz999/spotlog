import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';

class AuthRepository {
  Future<Map<String, String>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final role = data['user']['role'];
      return {
        'token': token,
        'role': role,
      };
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> register(String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'role': role,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Register failed: ${response.body}');
    }
  }

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Logout failed: ${response.body}');
    }
  }
}
