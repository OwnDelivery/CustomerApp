import 'package:firebase_auth/firebase_auth.dart';
import 'package:own_delivery/api/user_api.dart';

class RequestOTPUseCase {
  final UserApi _userApi;

  RequestOTPUseCase({UserApi? userApi}) : _userApi = userApi ?? UserApi();

  Future<ConfirmationResult> requestOTP(
      {required String name, required String phoneNumber}) {
    return _userApi.requestOTP(name, "+91$phoneNumber");
  }
}
