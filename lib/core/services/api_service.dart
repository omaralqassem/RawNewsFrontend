import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rawnes/core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  // ← غيّر هاد حسب الـ IP تبعك
  static const String baseUrl = ApiConstants.baseUrl;

  // ============================================================
  // HELPERS
  // ============================================================

  static Future<Map<String, String>> _authHeaders() async {
    final access = await StorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $access',
    };
  }

  static const Map<String, String> _publicHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ============================================================
  // AUTH  →  /api/auth/
  // ============================================================

  /// POST /api/auth/register/
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register/'),
      headers: _publicHeaders,
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  /// POST /api/auth/login/
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login/'),
      headers: _publicHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  /// POST /api/auth/logout/
  Future<Map<String, dynamic>> logout() async {
    final refresh = await StorageService.getRefreshToken();
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/logout/'),
      headers: headers,
      body: jsonEncode({'refresh': refresh}),
    );
    await StorageService.clearTokens();
    return jsonDecode(response.body);
  }

  /// GET /api/auth/show_profile/
  Future<Map<String, dynamic>> getProfile() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/show_profile/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  /// PATCH /api/auth/update_profile/
  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> data) async {
    final headers = await _authHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/api/auth/update_profile/'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // ============================================================
  // NEWS  →  /api/news/
  // ============================================================

  /// GET /api/news/  — كل الأخبار (مع filters اختيارية)
  /// [category] id الفئة   [source] id المصدر   [search] كلمة البحث
  Future<List<dynamic>> getAllNews({
    int? category,
    int? source,
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category.toString();
    if (source != null) queryParams['source'] = source.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri.parse('$baseUrl/api/news/')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await http.get(uri, headers: _publicHeaders);
    return jsonDecode(response.body);
  }

  /// GET /api/news/<id>/  — خبر واحد
  Future<Map<String, dynamic>> getNewsById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/$id/'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }

  /// GET /api/news/categories/
  Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/categories/'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }

  /// GET /api/news/sources/
  Future<List<dynamic>> getSources() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/sources/'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }

  // ============================================================
  // FAVORITES  →  /api/favorites/
  // ============================================================

  /// GET /api/favorites/  — كل المفضلة
  Future<List<dynamic>> getFavorites() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/favorites/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  /// POST /api/favorites/toggle/  — إضافة أو إزالة من المفضلة
  Future<Map<String, dynamic>> toggleFavorite(int newsId) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/favorites/toggle/'),
      headers: headers,
      body: jsonEncode({'news_id': newsId}),
    );
    return jsonDecode(response.body);
  }

  /// DELETE /api/favorites/remove/<id>/  — إزالة خبر واحد
  Future<Map<String, dynamic>> removeFavorite(int newsId) async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/favorites/remove/$newsId/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  /// DELETE /api/favorites/clear/  — مسح كل المفضلة
  Future<Map<String, dynamic>> clearFavorites() async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/favorites/clear/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  // ============================================================
  // NOTIFICATIONS  →  /api/notifications/
  // ============================================================

  /// GET /api/notifications/preferences/
  Future<Map<String, dynamic>> getNotificationPreferences() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/notifications/preferences/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  /// PATCH /api/notifications/preferences/update/
  Future<Map<String, dynamic>> updateNotificationPreferences(
      Map<String, dynamic> data) async {
    final headers = await _authHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/api/notifications/preferences/update/'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // ============================================================
  // FEEDBACK  →  /api/feedback/  (port 8002)
  // ============================================================

  static const String _feedbackUrl = 'http://192.168.1.7:8002';

  /// POST /api/feedback/article/
  Future<Map<String, dynamic>> submitFeedback(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_feedbackUrl/api/feedback/article/'),
      headers: _publicHeaders,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  /// GET /api/feedback/article/<id>/feedback/
  Future<Map<String, dynamic>> getFeedbackDetails(int articleId) async {
    final response = await http.get(
      Uri.parse('$_feedbackUrl/api/feedback/article/$articleId/feedback/'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }
}