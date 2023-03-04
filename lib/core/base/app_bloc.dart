import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/service/language/language_service.dart';
import 'package:mock_bloc_stream/core/service/user/user_service.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends BaseBloc {
  AppBloc({
    required this.userService,
    required this.languageService,
  });

  final UserService userService;
  final LanguageService languageService;

  final PublishSubject<String> appStateMessageSubject =
      PublishSubject<String>();
  Stream<String> get appStateStream => appStateMessageSubject.stream;

  @override
  void dispose() {
    appStateMessageSubject.close();
    super.dispose();
  }
}
