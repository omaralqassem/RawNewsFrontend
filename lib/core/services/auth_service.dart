import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class AuthService {
  static const String _baseUrl = 'http://192.168.1.5:8000/api/auth';

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

  print('=== LOGIN DEBUG ===');
  print('URL: ${_baseUrl}/login/');
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
  print('==================');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> logout() async {
    final refresh = await StorageService.getRefreshToken();
    final access = await StorageService.getAccessToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/logout/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
      body: jsonEncode({'refresh': refresh}),
    );

    await StorageService.clearTokens();
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final access = await StorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/show_profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
  final access = await StorageService.getAccessToken();

  final response = await http.patch(
    Uri.parse('$_baseUrl/update_profile/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    },
    body: jsonEncode(data),
  );
  return jsonDecode(response.body);
}
}