import 'package:get_it/get_it.dart';
import 'package:mock_bloc_stream/core/base/app_bloc.dart';
import 'package:mock_bloc_stream/core/config/env/network_config.dart';
import 'package:mock_bloc_stream/core/service/language/language_service.dart';
import 'package:mock_bloc_stream/core/service/user/user_service.dart';
import 'package:mock_bloc_stream/injection/di_bloc.dart';
import 'package:mock_bloc_stream/injection/di_datasource.dart';
import 'package:mock_bloc_stream/injection/di_repository.dart';
import 'package:mock_bloc_stream/injection/di_service.dart';
import 'package:mock_bloc_stream/injection/di_shared_prefs.dart';
import 'package:mock_bloc_stream/injection/di_usecase.dart';

final GetIt locator = GetIt.instance;

Future<void> initDependency({required BuildMode buildMode}) async {
  await SharedPrefDI.init(locator);

  await ServiceDI.init(locator, buildMode);
  await DatasourceDI.init(locator);
  await RepositoryDI.init(locator);
  await UsecaseDI.init(locator);
  await BlocDI.init(locator);

  locator.registerFactory<AppBloc>(
    () => AppBloc(
      userService: locator<UserService>(),
      languageService: locator<LanguageService>(),
    ),
  );
}
