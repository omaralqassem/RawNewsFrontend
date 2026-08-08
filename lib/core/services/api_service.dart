import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rawnes/core/constants/api_constants.dart';
import 'package:rawnes/modules/NewsFeed/news_model.dart';
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = ApiConstants.baseUrl;
  static const String newsUrl = ApiConstants.newsUrl;

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

  Future<List<dynamic>> getAllNews({int page = 1, int pageSize = 10}) async {
    try {
      final uri = Uri.parse('$newsUrl/articles/feed').replace(
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      final response = await http.get(uri, headers: _publicHeaders);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map && decoded.containsKey('articles')) {
          return decoded['articles'];
        }
      } else {
        print("FastAPI Feed Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Flutter API Error (Feed): $e");
    }
    return [];
  }

  Future<List<ClusterModel>> searchNews(
    String query, {
    String timeWindow = '7d',
  }) async {
    try {
      final headers = await _authHeaders();
      final uri = Uri.parse(
        '$baseUrl/api/news/search/',
      ).replace(queryParameters: {'q': query, 'time_window': timeWindow});

      print("Asking AI to search: $uri");

      final response = await http.get(uri, headers: headers);

      print("Backend responded with status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is! Map<String, dynamic>) return [];

        if (decoded.containsKey('clusters') && decoded['clusters'] is List) {
          print("Found AI Clusters in JSON!");
          final List dynamicClusters = decoded['clusters'];
          final List<ClusterModel> parsedClusters = [];

          for (var c in dynamicClusters) {
            try {
              parsedClusters.add(
                ClusterModel.fromJson(c as Map<String, dynamic>),
              );
            } catch (e) {
              print(" ERROR PARSING CLUSTER: $e");
            }
          }
          return parsedClusters;
        } else if (decoded.containsKey('results') &&
            decoded['results'] is List) {
          print("Backend used old format. Auto-converting to UI Clusters...");
          final List dynamicArticles = decoded['results'];
          final List<ClusterModel> mockClusters = [];

          for (int i = 0; i < dynamicArticles.length; i++) {
            try {
              final artMap = dynamicArticles[i] as Map<String, dynamic>;
              artMap['id'] = artMap['id'] ?? i + 1;
              artMap['source_name'] =
                  artMap['source'] ?? artMap['source_name'] ?? 'Web Source';

              final article = NewsModel.fromJson(artMap);

              mockClusters.add(
                ClusterModel(
                  clusterId: i + 1000,
                  summary:
                      "AI Summary pending backend update. Showing raw article.",
                  articles: [article],
                ),
              );
            } catch (e) {
              print(" ERROR PARSING ARTICLE: $e");
            }
          }
          return mockClusters;
        } else {
          print(" JSON does not contain 'clusters' or 'results'!");
        }
      } else {
        print(" Django Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print(" Flutter API Error: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>> submitSummaryFeedback({
    required int clusterId,
    required int userRating,
    String? generatedSummary,
  }) async {
    final response = await http.post(
      Uri.parse('$newsUrl/summary_feedback'),
      headers: _publicHeaders,
      body: jsonEncode({
        'article_id': clusterId,
        'query': "Cluster Synthesis",
        'user_rating': userRating,
        'feedback_reason': userRating == 2 ? "Helpful" : "Inaccurate",
        'generated_summary': generatedSummary ?? "",
        'corrected_summary': "",
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getNewsById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/$id/'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getRelatedNews(int newsId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/$newsId/related/'),
      headers: _publicHeaders,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is Map && decoded.containsKey('articles'))
      return decoded['articles'];
    if (decoded is Map && decoded.containsKey('results'))
      return decoded['results'];
    return decoded is List ? decoded : [];
  }

  Future<Map<String, dynamic>> getNewsSources(int newsId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/$newsId/sources/'),
      headers: _publicHeaders,
    );
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/categories/'),
      headers: _publicHeaders,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    return [];
  }

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


  Future<Map<String, dynamic>> toggleFavorite(int articleId) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/favorites/toggle/'),  
      headers: headers,
      body: jsonEncode({'article_id': articleId}),
    );
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getFavorites() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/favorites/'),  
      headers: headers,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is List) return decoded;
    return [];
  }

  Future<Map<String, dynamic>> clearFavorites() async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/favorites/clear/'),  
      headers: headers,
    );
    return jsonDecode(response.body);
  }

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
