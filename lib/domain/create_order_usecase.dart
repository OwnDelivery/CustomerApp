import 'package:own_delivery/api/order_api.dart';
import 'package:own_delivery/api/user_api.dart';
import 'package:own_delivery/models/order.dart';
import 'package:own_delivery/models/ordered_food_item.dart';

import '../models/address.dart';
import '../models/restaurant.dart';
import '../utils/utils.dart';

class CreateOrderUseCase {
  final UserApi _userApi;
  final OrderApi _orderApi;

  CreateOrderUseCase({UserApi? userApi, OrderApi? orderApi})
      : _userApi = userApi ?? UserApi(),
        _orderApi = orderApi ?? OrderApi();

  Future<void> createOrder(Map<FoodItem, int> items, Address address) async {
    final user = await _userApi.getUser() ??
        (throw Exception("Unable to fetch user info"));

    final orderItems = List<OrderedFoodItem>.empty(growable: true);
    items.forEach((key, value) {
      orderItems.add(OrderedFoodItem(key.name, key.foodType, key.price, value));
    });

    final order = Order(
        refId: Utils.getRandomRefNo().toString() +
            user.uid +
            Utils.getCurrentTime().toString(),
        foods: orderItems,
        address: address,
        orderedBy: user.displayName ?? "",
        contactNumber: user.phoneNumber ?? "",
        contactUid: user.uid,
        createdAt: Utils.getCurrentTime());

    return _orderApi.createOrder(user.uid, order);
  }
}
