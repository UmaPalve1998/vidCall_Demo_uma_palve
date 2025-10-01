import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/auth/models/auth_model.dart';


class SPManager {
  // Singleton pattern
  static final SPManager _instance = SPManager._internal();

  // Private constructor
  SPManager._internal();

  // Public factory to access the singleton instance
  static SPManager get instance => _instance;

  late SharedPreferences _prefs;

  // SharedPreferences keys
  static const String _spTokenKey = "sid";
  static const String _spUserKey = "user";
  static const String _spLoginDetailsKey = "loginDetails";
  static const String _savedUserIdKey = "savedUserId";
  static const String _savedPasswordKey = "savedPassword";
  static const String _rememberMeKey = "rememberMe";

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Set login details
  Future<bool> setLoginDetails(String loginDetails) async {
    await _initPrefs();
    return await _prefs.setString(_spLoginDetailsKey, loginDetails);
  }

  // Get login details
  Future<LoginResponse?> getLoginDetails() async {
    await _initPrefs();
    String? jsonString = _prefs.getString(_spLoginDetailsKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap =
        jsonDecode(jsonString); // Convert to Map
    return LoginResponse.fromJson(jsonMap); // Deserialize into LoginDetails
  }

  Future<bool> setStringList(List<String> checkpoint, key) async {
    await _initPrefs();

    return await _prefs.setStringList(key, checkpoint);
  }

  Future<List<String>?> getStringList(key) async {
    await _initPrefs();

    return await _prefs.getStringList(key);
  }

  // Set token
  Future<bool> setToken(String token) async {
    await _initPrefs();
    await _prefs.setString(_spTokenKey, token);
    return true;
  }

  // Get token
  Future<String?> getToken() async {
    await _initPrefs();
    return _prefs.getString(_spTokenKey);
  }

  // Set a string item
  Future<bool> setStringItem(String key, String? value) async {
    await _initPrefs();
    if (value != null) {
      return await _prefs.setString(key, value);
    }
    return false; // Return false if value is null
  }

  // Get a string item
  Future<String> getStringItem(String key) async {
    await _initPrefs();
    return _prefs.getString(key) ?? '';
  }

  // Set a int item
  Future<bool> setIntItem(String key, int? value) async {
    await _initPrefs();
    if (value != null) {
      return await _prefs.setInt(key, value);
    }
    return false; // Return false if value is null
  }

  // Get a int item
  Future<int?> getIntItem(String key) async {
    await _initPrefs();
    return _prefs.getInt(key) ?? null;
  }

  // remove a int item
  Future<bool?> remove(String key) async {
    await _initPrefs();
    return _prefs.remove(key);
  }

  // Set a boolean item
  Future<bool> setBoolItem(String key, bool value) async {
    await _initPrefs();
    return await _prefs.setBool(key, value);
  }

  // Get a boolean item
  Future<bool?> getBoolItem(String key) async {
    await _initPrefs();
    return _prefs.getBool(key);
  }

  // Logout by removing the token
  Future<bool> logout() async {
    await _initPrefs();
    return await _prefs.remove(_spTokenKey);
  }

  // Clear all login-related SharedPreferences
  Future<bool> clearLoginPreferences() async {
    await _initPrefs();
    await _prefs.remove(_spTokenKey);
    await _prefs.remove(_spUserKey);
    return true;
  }

  Future<bool> clearLoginSp() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.remove(_spTokenKey);
    return true;
  }

  Future<bool> clearList(key) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.remove(key);
    return true;
  }

  // Save credentials
  Future<bool> saveCredentials(
      String userId, String password, bool rememberMe) async {
    await _initPrefs();
    if (rememberMe) {
      await _prefs.setString(_savedUserIdKey, userId);
      await _prefs.setString(_savedPasswordKey, password);
      await _prefs.setBool(_rememberMeKey, true);
      return true;
    } else {
      await clearSavedCredentials();
      return false;
    }
  }

  // Get saved credentials
  Future<Map<String, dynamic>> getSavedCredentials() async {
    await _initPrefs();
    return {
      'userId': _prefs.getString(_savedUserIdKey),
      'password': _prefs.getString(_savedPasswordKey),
      'rememberMe': _prefs.getBool(_rememberMeKey) ?? false,
    };
  }

  // Clear saved credentials
  Future<bool> clearSavedCredentials() async {
    await _initPrefs();
    await _prefs.remove(_savedUserIdKey);
    await _prefs.remove(_savedPasswordKey);
    await _prefs.remove(_rememberMeKey);
    return true;
  }
}
