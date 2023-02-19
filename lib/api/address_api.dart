import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:own_delivery/models/address.dart';

class AddressApi {
  Stream<Address?> getAddress(String userId) {
    return FirebaseDatabase.instance
        .ref("users")
        .child(userId)
        .child("address")
        .onValue
        .map((value) {
      return value.snapshot.value != null
          ? Address.fromJson(value.snapshot.value as Map<String, dynamic>)
          : null;
    });
  }

  Future<void> updateAddress(String userId, Address address) {
    return FirebaseDatabase.instance
        .ref("users")
        .child(userId)
        .child("address")
        .set(address.toJson());
  }

  Future<String?> getLocality(double lat, double lon) async {
    var geoCodingService = ReverseGeoCoding(
      apiKey: dotenv.env["MAPBOX_API_KEY"] ?? "",
      types: PlaceType.locality,
      limit: 1,
    );

    return geoCodingService
        .getAddress(Location(
      lat: lat,
      lng: lon,
    ))
        .then((value) {
      if (value?.isNotEmpty == true) {
        return value?.first.text;
      }
      return null;
    });
  }
}
