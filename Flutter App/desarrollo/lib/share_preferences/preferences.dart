import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  
  // Tus preferencias existentes...
  static bool _isDarkMode = true;

  // Nuevas preferencias para las alertas de stock
  static bool _notificationsEnabled = true;
  static double _stockThreshold = 10;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Preferencias existentes...
  static bool get isDarkMode {
    return _prefs.getBool('isDarkMode') ?? _isDarkMode;
  }

  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool('isDarkMode', value);
  }

  // Nuevas preferencias para las alertas de stock
  static bool get notificationsEnabled {
    return _prefs.getBool('notificationsEnabled') ?? _notificationsEnabled;
  }

  static set notificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _prefs.setBool('notificationsEnabled', value);
  }

  static double get stockThreshold {
    return _prefs.getDouble('stockThreshold') ?? _stockThreshold;
  }

  static set stockThreshold(double value) {
    _stockThreshold = value;
    _prefs.setDouble('stockThreshold', value);
  }
}
