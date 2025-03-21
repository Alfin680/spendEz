import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Singleton instance
  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;
  SharedPrefs._internal();

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user login status
  Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool('isLoggedIn', value);
  }

  // Get user login status
  bool getLoggedIn() {
    return _prefs?.getBool('isLoggedIn') ?? false;
  }

  // Save user ID (optional)
  Future<void> setUserId(int userId) async {
    await _prefs?.setInt('userId', userId);
  }

  // Get user ID as int
  int getUserId() {
    return _prefs?.getInt('userId') ??
        0; // Default to 0 or any other default value
  }

  // Clear all data (for logout)
  Future<void> clear() async {
    await _prefs?.clear();
  }
}
