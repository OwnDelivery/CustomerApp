import 'package:own_delivery/api/restaurant_api.dart';
import 'package:own_delivery/models/restaurant.dart';

class ListenToRestaurantUseCase {
  final RestaurantApi _restaurantApi;

  ListenToRestaurantUseCase({RestaurantApi? restaurantApi})
      : _restaurantApi = restaurantApi ?? RestaurantApi();

  Stream<Restaurant> fetchRestaurant() {
    return _restaurantApi.listenToRestaurant();
  }
}
