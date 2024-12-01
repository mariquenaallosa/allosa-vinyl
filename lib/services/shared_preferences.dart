import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Obtener una instancia de SharedPreferences
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Guardar un valor de tipo String
  Future<void> saveString(String key, String value) async {
    SharedPreferences prefs = await _getPrefs();
    prefs.setString(key, value);
  }

  // Obtener un valor de tipo String
  Future<String?> getString(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.getString(key);
  }

  // Guardar un valor de tipo int
  Future<void> saveInt(String key, int value) async {
    SharedPreferences prefs = await _getPrefs();
    prefs.setInt(key, value);
  }

  // Obtener un valor de tipo int
  Future<int?> getInt(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.getInt(key);
  }

  // Guardar un valor de tipo bool
  Future<void> saveBool(String key, bool value) async {
    SharedPreferences prefs = await _getPrefs();
    prefs.setBool(key, value);
  }

  // Obtener un valor de tipo bool
  Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.getBool(key);
  }

  // Eliminar un valor
  Future<void> remove(String key) async {
    SharedPreferences prefs = await _getPrefs();
    prefs.remove(key);
  }

  // Limpiar todos los datos
  Future<void> clear() async {
    SharedPreferences prefs = await _getPrefs();
    prefs.clear();
  }

  // Verificar si una clave existe
  Future<bool> containsKey(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.containsKey(key);
  }
}
