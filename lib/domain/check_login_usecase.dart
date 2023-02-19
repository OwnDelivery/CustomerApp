import 'package:own_delivery/api/user_api.dart';

class CheckLoginUseCase {
  final UserApi _userApi;

  CheckLoginUseCase({UserApi? userApi}) : _userApi = userApi ?? UserApi();

  Future<bool> checkUser() {
    return _userApi.getUser().then((value) => value != null);
  }
}
