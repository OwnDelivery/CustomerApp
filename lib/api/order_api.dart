import 'package:firebase_database/firebase_database.dart';
import 'package:own_delivery/models/order.dart';

class OrderApi {
  Future<void> createOrder(String userId, Order order) {
    final ref = FirebaseDatabase.instance
        .ref("users")
        .child(userId)
        .child("orders")
        .push();
    return ref.set(order.toJson()).then((value) => FirebaseDatabase.instance
        .ref("users")
        .child(userId)
        .child("last_order")
        .set(ref.key)
        .then((value) => value));
  }

  Stream<Order?> listenToOrder(String userId, String orderId) {
    return FirebaseDatabase.instance
        .ref("users")
        .child(userId)
        .child("orders")
        .child(orderId)
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        return Order.fromJson(event.snapshot.value as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Future<Order?> getOrder(String userId, String orderId) {
    return FirebaseDatabase.instance
        .ref("users")
        .child(userId)
        .child("orders")
        .orderByChild("ref_id")
        .equalTo(orderId)
        .limitToFirst(1)
        .get()
        .then((value) {
      if (value.value != null) {
        final map = value.value as Map<String, dynamic>;
        return Order.fromJson(map.values.first as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Future<String?> getLastOrderId(String userId) {
    return FirebaseDatabase.instance
        .ref("users")
        .child(userId)
        .child("last_order")
        .get()
        .then((value) => value.value as String?);
  }
}
