import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:own_delivery/core/presenter.dart';
import 'package:own_delivery/core/single_event.dart';
import 'package:own_delivery/domain/request_otp_usecase.dart';

class LoginPagePresenter extends Presenter<LoginPageViewState> {
  final RequestOTPUseCase requestOTPUseCase;

  LoginPagePresenter({RequestOTPUseCase? requestOTPUseCase})
      : requestOTPUseCase = requestOTPUseCase ?? RequestOTPUseCase();

  LoginPageViewState viewState = LoginPageViewState();

  void onNameChanged(String text) async {
    viewState.name = text;
    getSink().add(viewState);
  }

  void onPhoneChanged(String text) async {
    viewState.phone = text;
    getSink().add(viewState);
  }

  void login() {
    viewState.requestingOTP = true;
    getSink().add(viewState);
    requestOTPUseCase
        .requestOTP(name: viewState.name, phoneNumber: viewState.phone)
        .then((value) {
      viewState.requestingOTP = false;
      viewState.verificationId = value.verificationId;
      viewState.requestOTPSuccess = SingleEvent(true);
      getSink().add(viewState);
      FirebaseAnalytics.instance.logEvent(
          name: "otp_request_success", parameters: {"phone": viewState.phone});
    }).catchError((e) {
      viewState.requestingOTP = false;
      viewState.error = SingleEvent("Request OTP Failed");
      getSink().add(viewState);
      FirebaseAnalytics.instance.logEvent(
          name: "otp_request_failed",
          parameters: {
            "phone": viewState.phone,
            "verification_id": viewState.verificationId
          });
    });
  }

  void clearError() {
    getSink().add(viewState);
  }
}

class LoginPageViewState {
  String name = "";
  String phone = "";
  String verificationId = "";
  bool requestingOTP = false;
  SingleEvent<bool>? requestOTPSuccess;
  SingleEvent<String>? error;

  bool isValid() {
    return name.isNotEmpty && phone.length == 10 && num.tryParse(phone) != null;
  }
}
