import 'package:shared_preferences/shared_preferences.dart';

class AuthData {
  static bool _isLoggedIn = false;
  static bool _isAdmin = false;

  static String? _currentUserName;
  static String? _currentUserRole;

  static bool get isLoggedIn => _isLoggedIn;
  static bool get isAdmin => _isAdmin;
  static String? get currentUserName => _currentUserName;
  static String? get currentUserRole => _currentUserRole;

  // Call this when user logs in
  static Future<void> loginAsAdmin(String name) async {
    _isLoggedIn = true;
    _isAdmin = true;
    _currentUserName = name;
    _currentUserRole = 'admin';
    await _saveSession(name, 'admin');
  }

  static Future<void> loginAsUser(String name, String role) async {
    _isLoggedIn = true;
    _isAdmin = role == 'admin';
    _currentUserName = name;
    _currentUserRole = role;
    await _saveSession(name, role);
  }

  static Future<void> logout() async {
    _isLoggedIn = false;
    _isAdmin = false;
    _currentUserName = null;
    _currentUserRole = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    await prefs.remove('name');
  }

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    final name = prefs.getString('name');
    if (role != null && name != null) {
      _isLoggedIn = true;
      _isAdmin = role == 'admin';
      _currentUserRole = role;
      _currentUserName = name;
    }
  }

  static Future<void> _saveSession(String name, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
    await prefs.setString('name', name);
  }
}
