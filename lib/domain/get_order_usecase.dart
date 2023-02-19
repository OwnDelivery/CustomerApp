import 'package:own_delivery/api/order_api.dart';
import 'package:own_delivery/api/user_api.dart';
import 'package:own_delivery/models/order.dart';

class GetOrderUseCase {
  final UserApi _userApi;
  final OrderApi _orderApi;

  GetOrderUseCase({UserApi? userApi, OrderApi? orderApi})
      : _userApi = userApi ?? UserApi(),
        _orderApi = orderApi ?? OrderApi();

  Stream<Order?> listenToLastOrder() async* {
    final user =
        await _userApi.getUser() ?? (throw Exception("User not logged in"));
    final lastOrderId = await _orderApi.getLastOrderId(user.uid) ??
        (throw Exception("No Last orders"));
    yield* _orderApi.listenToOrder(user.uid, lastOrderId);
  }

  Future<Order?> getOrder(String orderId) async {
    final user =
        await _userApi.getUser() ?? (throw Exception("User not logged in"));
    return _orderApi.getOrder(user.uid, orderId);
  }
}
