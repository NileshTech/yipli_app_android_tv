import 'package:shared_preferences/shared_preferences.dart';

class YipliAppLocalStorage {
  // singleton

  SharedPreferences _sharedPreferences;

  static final YipliAppLocalStorage _singleton =
      YipliAppLocalStorage._internal();
  factory YipliAppLocalStorage() => _singleton;

  static initialize(SharedPreferences sharedPreferences) =>
      YipliAppLocalStorage._singleton._sharedPreferences = sharedPreferences;

  YipliAppLocalStorage._internal();
  //static YipliAppLocalStorage get shared => _singleton;

  //static get data => YipliAppLocalStorage._singleton._sharedPreferences;

  static Future<bool> putData(String key, String encodedData) =>
      YipliAppLocalStorage._singleton._sharedPreferences
          .setString(key, encodedData);

  static Future<void> reset() {
    return YipliAppLocalStorage._singleton._sharedPreferences.clear();
  }

  static String getData(String key) =>
      YipliAppLocalStorage._singleton._sharedPreferences.getString(key);
}
