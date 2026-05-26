import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();

  static const String _themeKey = 'isDarkMode';

  static bool getDarkMode() => _box.read(_themeKey) ?? true;
  static Future<void> setDarkMode(bool value) async =>
      await _box.write(_themeKey, value);

  static Future<void> clearAll() async => await _box.erase();
}
