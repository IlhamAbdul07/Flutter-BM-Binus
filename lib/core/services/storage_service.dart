import 'package:get_storage/get_storage.dart';
import 'package:universal_html/html.dart' as html;

class StorageService {

  static void setToken(String token) {
    final expires = DateTime.now().add(const Duration(days: 365 * 100)).toUtc();
    html.document.cookie = 'token=$token; expires=${expires.toIso8601String()}; path=/';
  }

  static void clearToken() {
    html.document.cookie = 'token=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/';
  }

  static String? getToken() {
    final cookies = html.document.cookie?.split('; ') ?? [];
    for (var cookie in cookies) {
      if (cookie.startsWith('token=')) {
        return cookie.substring('token='.length);
      }
    }
    return null;
  }

  static final _box = GetStorage();
  static const _themeKey = 'isDarkMode';

  static bool loadTheme() {
    return _box.read(_themeKey) ?? false;
  }

  static void saveTheme(bool isDarkMode) {
    _box.write(_themeKey, isDarkMode);
  }
}
