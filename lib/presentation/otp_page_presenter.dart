import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:own_delivery/core/presenter.dart';
import 'package:own_delivery/core/single_event.dart';
import 'package:own_delivery/domain/verify_otp_usecase.dart';

class OTPPagePresenter extends Presenter<OTPPageViewState> {
  final VerifyOTPUseCase verifyOTPUseCase;

  OTPPagePresenter({VerifyOTPUseCase? verifyOTPUseCase})
      : verifyOTPUseCase = verifyOTPUseCase ?? VerifyOTPUseCase();

  final OTPPageViewState _viewState = OTPPageViewState();

  void onOTPChanged(String text) {
    _viewState.otp = text;
    getSink().add(_viewState);
  }

  void verifyOTP(String name, String verificationId) {
    _viewState.verifyingOTP = true;
    getSink().add(_viewState);
    verifyOTPUseCase
        .verifyOTP(
            name: name, otp: _viewState.otp, verificationId: verificationId)
        .then((value) {
      _viewState.loginSuccess = SingleEvent(true);
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logLogin(loginMethod: "phone");
      FirebaseAnalytics.instance.logEvent(
          name: "otp_verify_success", parameters: {"phone": value.phoneNumber});
      FirebaseAnalytics.instance.setUserId(id: value.uid);
    }).catchError((error) {
      _viewState.verifyingOTP = false;
      _viewState.error = SingleEvent("Verify OTP Failed");
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logEvent(name: "otp_verify_failed");
    });
  }

  void clearError() {
    getSink().add(_viewState);
  }
}

class OTPPageViewState {
  String otp = "";
  bool verifyingOTP = false;
  SingleEvent<bool>? loginSuccess;
  SingleEvent<String>? error;

  bool isValid() {
    return otp.isNotEmpty && otp.length == 6;
  }
}
