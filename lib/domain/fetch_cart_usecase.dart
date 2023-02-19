import 'package:own_delivery/api/cart_api.dart';

import '../models/cart.dart';

class FetchCartUseCase {
  final CartApi _cartApi;

  FetchCartUseCase({CartApi? cartApi}) : _cartApi = cartApi ?? CartApi();

  Future<Cart> fetchCart() {
    return _cartApi.getCart();
  }
}
