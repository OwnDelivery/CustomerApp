import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:own_delivery/core/presenter.dart';
import 'package:own_delivery/core/single_event.dart';
import 'package:own_delivery/domain/check_order_usecase.dart';

class HomePagePresenter extends Presenter<HomePageViewState> {
  final CheckOrderUseCase _checkOrderUseCase;
  final HomePageViewState _viewState = HomePageViewState();

  HomePagePresenter({CheckOrderUseCase? checkOrderUseCase})
      : _checkOrderUseCase = checkOrderUseCase ?? CheckOrderUseCase();

  void checkStatus() {
    _checkOrderUseCase.getOrder().then((value) {
      _viewState.isOrderAvailable = SingleEvent(value);
      getSink().add(_viewState);
    }).catchError((e) {
      _viewState.error = SingleEvent("Something went wrong");
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logEvent(name: "home_check_failed");
    });
  }
}

class HomePageViewState {
  SingleEvent<bool>? isOrderAvailable;
  SingleEvent<String>? error;
}
