import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:own_delivery/core/presenter.dart';
import 'package:own_delivery/core/single_event.dart';
import 'package:own_delivery/domain/create_cart_usecase.dart';
import 'package:own_delivery/domain/fetch_address_usecase.dart';
import 'package:own_delivery/domain/listen_to_restaurant_usecase.dart';
import 'package:own_delivery/domain/logout_usecase.dart';

import '../models/restaurant.dart';

class MenuPagePresenter extends Presenter<MenuPageViewState> {
  final CreateCartUseCase _createCartUseCase;
  final ListenToRestaurantUseCase _listenToRestaurantUseCase;
  final LogoutUseCase _logoutUseCase;
  final MenuPageViewState _viewState = MenuPageViewState();

  MenuPagePresenter(
      {FetchAddressUseCase? fetchAddressUseCase,
      CreateCartUseCase? createCartUseCase,
      ListenToRestaurantUseCase? listenToRestaurantUseCase,
      LogoutUseCase? logoutUseCase})
      : _createCartUseCase = createCartUseCase ?? CreateCartUseCase(),
        _listenToRestaurantUseCase =
            listenToRestaurantUseCase ?? ListenToRestaurantUseCase(),
        _logoutUseCase = logoutUseCase ?? LogoutUseCase();

  void fetch() {
    _listenToRestaurantUseCase.fetchRestaurant().listen((event) {
      _viewState.isRestaurantOpen = event.isOpen;
      _viewState.timing = event.timing;
      _viewState._menuDto = event.menu;
      getSink().add(_viewState);
    }).onError((error) {
      _viewState.error = SingleEvent("Unable to fetch restaurant status");
      getSink().add(_viewState);
      FirebaseAnalytics.instance
          .logEvent(name: "fetch_restaurant_status_failed");
    });
  }

  void toggleSelection(String sectionId, String foodId, int qty) {
    if (_viewState.selectedFoods[sectionId] == null) {
      _viewState.selectedFoods[sectionId] = {};
    }
    _viewState.selectedFoods[sectionId]?[foodId] = qty;
    getSink().add(_viewState);
  }

  addToCart() {
    final Map<FoodItem, int> foods = {};
    _viewState.getItems().forEach((element) {
      if (element is FoodVo && element.qty > 0) {
        foods[FoodItem(
            name: element.name,
            foodType: element.type,
            price: element.price,
            available: true,
            rank: element.rank)] = element.qty;
      }
    });
    _createCartUseCase.createCart(foods).then((value) {
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logAddToCart(
          items: _viewState.selectedFoods.keys
              .map((e) => AnalyticsEventItem(itemName: e))
              .toList(),
          value: _viewState.getPrice(),
          currency: 'INR');
    });
  }

  void logout() {
    _logoutUseCase.logout().then((value) {
      _viewState.isLoggedOut = SingleEvent(true);
      getSink().add(_viewState);
    }).catchError((error) {
      _viewState.error = SingleEvent("Unable to logout");
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logEvent(name: "logout_failed");
    });
  }

  void clearError() {
    getSink().add(_viewState);
  }
}

class MenuPageViewState {
  Menu _menuDto = Menu(Map.identity());
  final Map<String, Map<String, int>> selectedFoods = {};
  bool isFetching = false;
  SingleEvent<bool>? isLoggedOut;
  bool isRestaurantOpen = false;
  String timing = "";
  SingleEvent<String>? error;

  MenuPageViewState();

  List<dynamic> getItems() {
    final items = List.empty(growable: true);

    List<MapEntry<String, Section>> sections =
        _menuDto.sections.entries.toList();
    sections.sort((a, b) => a.value.rank.compareTo(b.value.rank));
    for (var section in sections) {
      if (section.value.items.values.any((element) => element.available)) {
        items.add(SectionVo(section.key, section.value.name));
        List<MapEntry<String, FoodItem>> foodItems =
            section.value.items.entries.toList();
        foodItems.sort((a, b) => a.value.rank.compareTo(b.value.rank));
        for (var food in foodItems) {
          if (food.value.available) {
            items.add(FoodVo(
                sectionId: section.key,
                foodId: food.key,
                name: food.value.name,
                type: food.value.foodType,
                price: food.value.price,
                rank: food.value.rank,
                qty: selectedFoods[section.key]?[food.key] ?? 0));
          }
        }
      }
    }

    return items;
  }

  int getQty() {
    return getItems()
        .map((e) => e is FoodVo ? e.qty : 0)
        .reduce((value, element) => value + element);
  }

  double getPrice() {
    return getItems()
        .map((e) => e is FoodVo ? e.price * e.qty : 0.0)
        .reduce((value, element) => value + element);
  }
}

class SectionVo {
  String id;
  String name;

  SectionVo(this.id, this.name);
}

class FoodVo {
  String sectionId;
  String foodId;
  String name;
  String type;
  double price;
  int qty;
  int rank;

  FoodVo(
      {required this.sectionId,
      required this.foodId,
      required this.name,
      required this.type,
      required this.price,
      required this.qty,
      required this.rank});
}
