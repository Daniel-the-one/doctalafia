import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // static + underscore pour que ce soit une constante de classe
  static const String _keyIsRegistered = 'is_registered';
  static const String _keyIsLoggedIn   = 'is_logged_in';
  static const String _keyEmail = 'email';
  static const String _keyMotDePasse = 'mot_de_passe';

  static Future<bool> isUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsRegistered) ?? false;
  }
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }


  static Future<void> saveUserRegistration( String email, String motDePasse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsRegistered, true);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyMotDePasse, motDePasse);
  }

  static Future<void> saveUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
  }
  static Future<void> saveUserLoggedOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  static Future<bool> veriferConnexion(String email, String motDePasse) async {
    final prefs = await SharedPreferences.getInstance();
    final emailSauvegarde = prefs.getString(_keyEmail);
    final mdpSauvegarde = prefs.getString(_keyMotDePasse);
    return email == emailSauvegarde && motDePasse == mdpSauvegarde;
  }
}