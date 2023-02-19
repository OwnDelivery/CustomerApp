import 'package:firebase_auth/firebase_auth.dart';

class UserApi {
  Future<User?> getUser() {
    return FirebaseAuth.instance.authStateChanges().first;
  }

  Future<ConfirmationResult> requestOTP(String name, String phoneNumber) {
    return FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
  }

  Future<User?> verifyOTP(
    String name,
    String verificationId,
    String otp,
  ) {
    final credentials = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    return FirebaseAuth.instance.signInWithCredential(credentials).then(
        (userCredential) => setName(userCredential.user, name)
            .then((value) => userCredential.user));
  }

  Future<bool> setName(User? user, String name) {
    if (user != null) {
      return user
          .updateDisplayName(name)
          .then((value) => true)
          .onError((error, stackTrace) => false);
    } else {
      return Future.value(false);
    }
  }

  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}
