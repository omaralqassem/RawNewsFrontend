import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rawnes/core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = ApiConstants.baseUrl; // Auth, Favorites, Notifications
  static const String newsUrl = ApiConstants.newsUrl; // News, Feedback

  // HELPERS

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

  // Auth  -->  port 8000

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

  Future<Map<String, dynamic>> getProfile() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/show_profile/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final headers = await _authHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/api/auth/update_profile/'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // News  -->  port 8002 (FastAPI)

  // GET /articles/feed
  Future<List<dynamic>> getAllNews({int page = 1, int pageSize = 10}) async {
    final uri = Uri.parse('$newsUrl/articles/feed').replace(
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );
    final response = await http.get(uri, headers: _publicHeaders);
    final decoded = jsonDecode(response.body);
    if (decoded is Map && decoded.containsKey('articles')) {
      return decoded['articles'];
    }
    return [];
  }

  // GET /articles/search?q=كلمة
  Future<List<dynamic>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse('$newsUrl/articles/search?q=${Uri.encodeComponent(query)}'),
      headers: _publicHeaders,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is Map && decoded.containsKey('articles')) {
      return decoded['articles'];
    }
    return [];
  }

  // GET /articles/<id>
  Future<Map<String, dynamic>> getNewsById(int id) async {
    final response = await http.get(
      Uri.parse('$newsUrl/articles/$id'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }

  // GET /articles/<id>/sources
  Future<Map<String, dynamic>> getNewsSources(int newsId) async {
    final response = await http.get(
      Uri.parse('$newsUrl/articles/$newsId/sources'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }

  // GET /articles/<id>/related
  Future<List<dynamic>> getRelatedNews(int newsId) async {
    final response = await http.get(
      Uri.parse('$newsUrl/articles/$newsId/related'),
      headers: _publicHeaders,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is Map && decoded.containsKey('articles')) {
      return decoded['articles'];
    }
    return [];
  }

  // GET /api/news/categories/
  Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/categories/'),
      headers: _publicHeaders,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    return [];
  }

  // GET /api/news/?category=1
  Future<List<dynamic>> getNewsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse('$newsUrl/api/news/?category=$categoryId'),
      headers: _publicHeaders,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    if (decoded is Map && decoded.containsKey('results')) {
      return decoded['results'];
    }
    return [];
  }

  // GET /api/news/?source=1
  Future<List<dynamic>> getNewsBySource(int sourceId) async {
    final response = await http.get(
      Uri.parse('$newsUrl/api/news/?source=$sourceId'),
      headers: _publicHeaders,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    if (decoded is Map && decoded.containsKey('results')) {
      return decoded['results'];
    }
    return [];
  }

  // Favorites  -->  port 8000

  Future<List<dynamic>> getFavorites() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/favorites/'),
      headers: headers,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    if (decoded is Map && decoded.containsKey('results')) {
      return decoded['results'];
    }
    if (decoded is Map && decoded.containsKey('favorites')) {
      return decoded['favorites'];
    }
    return [];
  }

  Future<Map<String, dynamic>> toggleFavorite(int newsId) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/favorites/toggle/'),
      headers: headers,
      body: jsonEncode({'news_id': newsId}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> removeFavorite(int newsId) async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/favorites/remove/$newsId/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> clearFavorites() async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/favorites/clear/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  // Notifications  -->  port 8000

  Future<Map<String, dynamic>> getNotificationPreferences() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/notifications/preferences/'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateNotificationPreferences(
    Map<String, dynamic> data,
  ) async {
    final headers = await _authHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/api/notifications/preferences/update/'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // Feedback  -->  port 8002

  /// POST /article-feedback
  Future<Map<String, dynamic>> submitFeedback({
    required int articleId,
    required bool propagandaCorrect,
    String? correctedPropaganda,
    required bool statementCorrect,
    String? correctedStatement,
    required bool attributionCorrect,
    String? correctedAttribution,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$newsUrl/article-feedback'),
      headers: _publicHeaders,
      body: jsonEncode({
        'article_id': articleId,
        'propaganda_correct': propagandaCorrect,
        'corrected_propaganda': correctedPropaganda,
        'statement_correct': statementCorrect,
        'corrected_statement': correctedStatement,
        'attribution_correct': attributionCorrect,
        'corrected_attribution': correctedAttribution,
        'notes': notes,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getFeedbackDetails(int articleId) async {
    final response = await http.get(
      Uri.parse('$newsUrl/api/feedback/article/$articleId/feedback/'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }
}
