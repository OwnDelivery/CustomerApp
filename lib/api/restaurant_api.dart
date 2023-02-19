import 'package:firebase_database/firebase_database.dart';
import 'package:own_delivery/models/restaurant.dart';

class RestaurantApi {
  Stream<Restaurant> listenToRestaurant() {
    return FirebaseDatabase.instance.ref("restaurant").onValue.map((event) =>
        Restaurant.fromJson(event.snapshot.value as Map<String, dynamic>));
  }
}
