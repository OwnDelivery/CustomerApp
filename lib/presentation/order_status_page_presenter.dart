import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:own_delivery/core/presenter.dart';
import 'package:own_delivery/core/single_event.dart';
import 'package:own_delivery/domain/get_order_usecase.dart';
import 'package:own_delivery/domain/logout_usecase.dart';
import 'package:own_delivery/models/order.dart';

class OrderStatusPagePresenter extends Presenter<OrderStatusPageViewState> {
  final GetOrderUseCase _getOrderUseCase;
  final LogoutUseCase _logoutUseCase;
  final OrderStatusPageViewState _viewState = OrderStatusPageViewState();

  OrderStatusPagePresenter(
      {GetOrderUseCase? getOrderUseCase, LogoutUseCase? logoutUseCase})
      : _getOrderUseCase = getOrderUseCase ?? GetOrderUseCase(),
        _logoutUseCase = logoutUseCase ?? LogoutUseCase();

  void getOrders() {
    _viewState.isFetching = true;
    getSink().add(_viewState);
    _getOrderUseCase.listenToLastOrder().listen((value) {
      _viewState.isFetching = false;
      _viewState.order = value;
      getSink().add(_viewState);
    }).onError((error) {
      _viewState.isFetching = false;
      _viewState.error = SingleEvent('Fetch orders failed');
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logEvent(name: 'order_fetch_failed');
    });
  }

  void logout() {
    _logoutUseCase.logout().then((value) {
      _viewState.isLoggedOut = SingleEvent(true);
      getSink().add(_viewState);
    }).catchError((error) {
      getSink().addError(error);
    });
  }
}

class OrderStatusPageViewState {
  Order? order;
  bool isFetching = false;
  SingleEvent<bool>? isLoggedOut;
  SingleEvent<String>? error;
}
