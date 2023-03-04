import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  factory SharedPreferenceService.init(SharedPreferences param) {
    return SharedPreferenceService(
      param,
    );
  }

  SharedPreferenceService(this._pref);
  SharedPreferences _pref;

  SharedPreferences get getInstance => _pref;

  Future<bool> setUserToken(String token) =>
      _pref.setString('request_token', token);

  String? getUserToken() => _pref.getString('request_token');
}
