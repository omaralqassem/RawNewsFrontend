import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  static Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshKey);
  }

  static Future<void> saveSources({
    required List<String> muted,
    required List<String> fav,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('mutedSorces', muted);
    await prefs.setStringList('favSources', fav);
  }

  static Future<List<String>?> getMutedSources() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('mutedSorces');
  }

  static Future<List<String>?> getFavSources() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favSources');
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }
}
