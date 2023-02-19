import 'package:own_delivery/models/cart.dart';

import '../core/in_memory_repository.dart';
import '../models/restaurant.dart';

class CartApi {
  Future<void> createCart(Map<FoodItem, int> items) {
    Cart cart = Cart(items: items);
    InMemoryRepository.instance.put("cart", cart);
    return Future(() => null);
  }

  Future<Cart> getCart() {
    if (InMemoryRepository.instance.contains("cart")) {
      return Future.value(InMemoryRepository.instance.get("cart") as Cart);
    } else {
      return Future.error("Cart not saved");
    }
  }
}
