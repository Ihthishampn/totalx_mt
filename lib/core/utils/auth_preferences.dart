import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _authTokenKey = 'auth_token';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLoginSession(
    String phone, {
    String? authToken,
  }) async {
    await _prefs.setBool(_isLoggedInKey, true);
    if (authToken != null) {
      await _prefs.setString(_authTokenKey, authToken);
    } else {
      await _prefs.setString(
        _authTokenKey,
        'session_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
 
  }

  // clear   ithu  for sign out ippo no use
  static Future<void> clearLoginSession() async {
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_authTokenKey);
  }

  // login flag
  static Future<void> setIsLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  static String? getAuthToken() {
    return _prefs.getString(_authTokenKey);
  }

  // login flag get
  static bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  
  
}
