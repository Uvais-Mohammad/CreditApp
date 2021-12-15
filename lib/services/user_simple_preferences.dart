import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;
  static const keyLoggedIn = 'isLoggedIn';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setLoggedIn() async {
    await _preferences!.setBool(keyLoggedIn, true);
  }

  static Future<bool> isLoggedIn() async {
    return _preferences!.getBool(keyLoggedIn) ?? false;
  }

  static Future setLoggedOut() async {
    await _preferences!.setBool(keyLoggedIn, false);
  }
}
