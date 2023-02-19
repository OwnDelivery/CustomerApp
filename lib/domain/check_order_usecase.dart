import 'package:date_utils/date_utils.dart';
import 'package:own_delivery/api/order_api.dart';
import 'package:own_delivery/api/user_api.dart';

class CheckOrderUseCase {
  final UserApi _userApi;
  final OrderApi _orderApi;

  CheckOrderUseCase({UserApi? userApi, OrderApi? orderApi})
      : _userApi = userApi ?? UserApi(),
        _orderApi = orderApi ?? OrderApi();

  Future<bool> getOrder() async {
    final user =
        await _userApi.getUser() ?? (throw Exception("User not logged in"));
    final orderId = await _orderApi.getLastOrderId(user.uid);
    if (orderId == null) {
      return Future.value(false);
    } else {
      return _orderApi.listenToOrder(user.uid, orderId).first.then((value) =>
          value != null &&
              (DateUtils.isSameDay(
                  DateTime.fromMillisecondsSinceEpoch(value.createdAt),
                  DateTime.now())) ||
          value?.delivered != true);
    }
  }
}
