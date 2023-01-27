import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends BaseBloc {
  AppBloc({
    required this.userService,
    required this.languageService,
  });

  final UserService userService;
  final LanguageService languageService;

  final BehaviorSubject<String> appStateMessageSubject =
      BehaviorSubject<String>.seeded('');
  Stream<String> get appStateStream => appStateMessageSubject.stream;
  String get getAppStateMessage => appStateMessageSubject.value;

  @override
  void dispose() {
    appStateMessageSubject.close();
    super.dispose();
  }
}

abstract class UserService {
  Future<void> saveUserInfo();
}

class UserServiceImpl extends UserService {
  @override
  Future<void> saveUserInfo() {
    throw UnimplementedError();
  }
}

abstract class LanguageService {
  Future<void> switchLanguage();
}

class LanguageServiceImpl extends LanguageService {
  @override
  Future<void> switchLanguage() {
    throw UnimplementedError();
  }
}
