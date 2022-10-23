import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// provider stores the instance SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  return throw UnimplementedError();
});

// provider to work with AppTheme
final appThemeProvider = ChangeNotifierProvider((ref) {
  return ThemeServices(ref.watch(sharedPreferencesProvider));
});

class ThemeServices extends ChangeNotifier {
  ThemeServices(this._prefs);

  final SharedPreferences _prefs;

  /// Get the current value from SharedPreferences.
  bool getTheme() => _prefs.getBool('isDarkMode') ?? false;

  /// Store the current value in SharedPreferences.
  void setTheme(bool isDarkMode) {
    _prefs.setBool('isDarkMode', isDarkMode);

    notifyListeners();
  }
}
