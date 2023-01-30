abstract class UserService {
  Future<void> saveUserInfo();
}

class UserServiceImpl extends UserService {
  @override
  Future<void> saveUserInfo() {
    throw UnimplementedError();
  }
}
