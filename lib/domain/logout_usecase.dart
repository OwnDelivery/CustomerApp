import 'package:own_delivery/api/user_api.dart';

class LogoutUseCase {
  final UserApi _userApi;

  LogoutUseCase({UserApi? userApi}) : _userApi = userApi ?? UserApi();

  Future<void> logout() {
    return _userApi.logout();
  }
}
