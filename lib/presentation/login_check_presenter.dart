import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:own_delivery/core/presenter.dart';
import 'package:own_delivery/core/single_event.dart';
import 'package:own_delivery/domain/check_login_usecase.dart';

class LoginCheckPresenter extends Presenter<LoginCheckPageViewState> {
  final CheckLoginUseCase checkLoginUseCase;
  final LoginCheckPageViewState _viewState = LoginCheckPageViewState();

  LoginCheckPresenter({CheckLoginUseCase? checkLoginUseCase})
      : checkLoginUseCase = checkLoginUseCase ?? CheckLoginUseCase();

  void checkStatus() {
    getSink().add(_viewState);
    checkLoginUseCase.checkUser().then((value) {
      _viewState.isLoggedIn = SingleEvent(value);
      getSink().add(_viewState);
    }).catchError((e) {
      _viewState.error = SingleEvent("Unable to process");
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logEvent(name: 'check_status_failed');
    });
  }
}

class LoginCheckPageViewState {
  SingleEvent<bool>? isLoggedIn;
  SingleEvent<String>? error;
}
