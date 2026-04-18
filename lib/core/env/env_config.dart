import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get msg91AuthToken => _get('MSG91_AUTH_TOKEN');
  static String get msg91WidgetId => _get('MSG91_WIDGET_ID');
  static String get msg91TemplateId => _get('MSG91_TEMPLATE_ID');

  static String _get(String key) {
    try {
      return dotenv.get(key);
    } catch (error) {
      throw StateError(
        'Missing  "$key"'
      );
    }
  }

  static bool contains(String key) {
    return dotenv.env.containsKey(key) && dotenv.env[key]!.isNotEmpty;
  }
}
