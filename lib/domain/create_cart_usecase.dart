import 'package:own_delivery/api/cart_api.dart';

import '../models/restaurant.dart';

class CreateCartUseCase {
  final CartApi _cartApi;

  CreateCartUseCase({CartApi? cartApi}) : _cartApi = cartApi ?? CartApi();

  Future<void> createCart(Map<FoodItem, int> items) {
    return _cartApi.createCart(items);
  }
}
