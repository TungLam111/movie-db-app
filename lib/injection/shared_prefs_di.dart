import 'package:get_it/get_it.dart';
import 'package:mock_bloc_stream/core/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefDI {
  SharedPrefDI._();

  static Future<void> init(GetIt injector) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    final SharedPreferenceService sharedPrefsService =
        SharedPreferenceService.init(sharedPref);

    injector.registerLazySingleton(() => sharedPrefsService);
  }
}
