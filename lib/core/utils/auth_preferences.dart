import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _phoneKey = 'user_phone';
  static const String _authTokenKey = 'auth_token';
  static const String _loginTimestampKey = 'login_timestamp';
  static const String _lastOtpStatusKey = 'last_otp_status';
  static const String _lastOtpTypeKey = 'last_otp_type';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLoginSession(
    String phone, {
    String? authToken,
  }) async {
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_phoneKey, phone);
    if (authToken != null) {
      await _prefs.setString(_authTokenKey, authToken);
    } else {
      await _prefs.setString(
        _authTokenKey,
        'session_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
    await _prefs.setInt(
      _loginTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<void> clearLoginSession() async {
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_phoneKey);
    await _prefs.remove(_authTokenKey);
    await _prefs.remove(_loginTimestampKey);
    await _prefs.remove(_lastOtpStatusKey);
    await _prefs.remove(_lastOtpTypeKey);
  }

  static Future<void> saveLastOtpResponse(int statusCode, String type) async {
    await _prefs.setInt(_lastOtpStatusKey, statusCode);
    await _prefs.setString(_lastOtpTypeKey, type);
  }

  static Future<void> setIsLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  static int? getLastOtpStatus() {
    return _prefs.getInt(_lastOtpStatusKey);
  }

  static String? getLastOtpType() {
    return _prefs.getString(_lastOtpTypeKey);
  }

  static String? getAuthToken() {
    return _prefs.getString(_authTokenKey);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  static String? getUserPhone() {
    return _prefs.getString(_phoneKey);
  }

  static int? getLoginTimestamp() {
    return _prefs.getInt(_loginTimestampKey);
  }
}
