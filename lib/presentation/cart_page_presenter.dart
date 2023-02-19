import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:own_delivery/core/presenter.dart';
import 'package:own_delivery/core/single_event.dart';
import 'package:own_delivery/domain/create_order_usecase.dart';
import 'package:own_delivery/domain/fetch_address_usecase.dart';
import 'package:own_delivery/domain/fetch_cart_usecase.dart';

import '../models/address.dart';
import '../models/restaurant.dart';

class CartPagePresenter extends Presenter<CartPageViewState> {
  final FetchCartUseCase _fetchCartUseCase;
  final CreateOrderUseCase _createOrderUseCase;
  final FetchAddressUseCase _fetchAddressUseCase;
  final CartPageViewState _viewState = CartPageViewState();

  CartPagePresenter(
      {FetchCartUseCase? fetchCartUseCase,
      CreateOrderUseCase? createOrderUseCase,
      FetchAddressUseCase? fetchAddressUseCase})
      : _fetchCartUseCase = fetchCartUseCase ?? FetchCartUseCase(),
        _createOrderUseCase = createOrderUseCase ?? CreateOrderUseCase(),
        _fetchAddressUseCase = fetchAddressUseCase ?? FetchAddressUseCase();

  void getItems() {
    _fetchCartUseCase.fetchCart().then((value) {
      _viewState.selectedFoods = value.items;
      getSink().add(_viewState);
    });

    _fetchAddressUseCase.fetchAddress().listen((event) {
      _viewState.address = event;
      getSink().add(_viewState);
    }).onError((error) {
      _viewState.error = SingleEvent("Unable to fetch address");
      getSink().add(_viewState);
    });
  }

  createOrder() {
    final address = _viewState.address;
    if (address != null) {
      _viewState.creatingOrder = true;
      getSink().add(_viewState);
      _createOrderUseCase
          .createOrder(_viewState.selectedFoods, address)
          .then((value) {
        _viewState.creatingOrder = false;
        _viewState.creatingOrderSuccess = SingleEvent(true);
        getSink().add(_viewState);
        FirebaseAnalytics.instance.logPurchase(
            items: _viewState.selectedFoods.keys
                .map((e) => AnalyticsEventItem(
                    itemName: e.name, price: e.price, currency: 'INR'))
                .toList(),
            value: _viewState.getPrice(),
            currency: 'INR');
      }).catchError((error) {
        _viewState.creatingOrder = false;
        _viewState.error = SingleEvent("Create order failed");
        getSink().add(_viewState);
        FirebaseAnalytics.instance.logEvent(name: 'create_order_failed');
      });
    }
  }

  void clearError() {
    getSink().add(_viewState);
  }
}

class CartPageViewState {
  Address? address;
  SingleEvent<bool>? creatingOrderSuccess;
  bool creatingOrder = false;
  SingleEvent<String>? error;
  Map<FoodItem, int> selectedFoods = {};

  int getQty() {
    return selectedFoods.values.reduce((value, element) => value + element);
  }

  double getPrice() {
    double price = 0;
    selectedFoods.forEach((key, value) {
      price += key.price * value;
    });
    price += address?.getDeliveryCharge() ?? 0;
    return price;
  }
}
