import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  SharedPrefManager._internal();
  static SharedPrefManager get instance => _prefManager;
  static final SharedPrefManager _prefManager = SharedPrefManager._internal();
  static const String token = "_Token";

  Future<String?> getStringAsync(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(type);
  }

  Future<bool> setStringAsync(String type, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(type, value);
  }

  Future<bool?> getBoolAsync(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(type);
  }

  Future<bool> setBoolAsync(String type, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(type, value);
  }
}
