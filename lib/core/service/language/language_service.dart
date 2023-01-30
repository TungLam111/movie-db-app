abstract class LanguageService {
  Future<void> switchLanguage();
}

class LanguageServiceImpl extends LanguageService {
  @override
  Future<void> switchLanguage() {
    throw UnimplementedError();
  }
}
