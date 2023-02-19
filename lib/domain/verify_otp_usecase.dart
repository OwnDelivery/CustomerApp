import 'package:firebase_auth/firebase_auth.dart';
import 'package:own_delivery/api/user_api.dart';

class VerifyOTPUseCase {
  final UserApi _userApi;

  VerifyOTPUseCase({UserApi? userApi}) : _userApi = userApi ?? UserApi();

  Future<User> verifyOTP(
      {required String name,
      required String verificationId,
      required String otp}) {
    return _userApi
        .verifyOTP(name, verificationId, otp)
        .then((user) => user ?? (throw Exception("Unable to Login")));
  }
}
