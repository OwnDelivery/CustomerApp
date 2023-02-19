import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {
  @JsonKey(name: "lat")
  double lat;
  @JsonKey(name: "lon")
  double lon;
  @JsonKey(name: "full_address")
  String fullAddress;
  @JsonKey(name: "locality")
  String? locality;

  Address(this.lat, this.lon, this.fullAddress, this.locality);

  double getDeliveryCharge() {
    return (getDeliveryDistance() *
            double.parse(dotenv.env['DELIVERY_CHARGE_PER_KM'] ?? '15.0'))
        .toInt() //Rounding
        .toDouble();
  }

  double getDeliveryDistance() {
    //Increase the delivery distance by 50% considering the road is not straight line.
    return Utils.findDistance(double.parse(dotenv.env["SHOP_LAT"] ?? '0.0'),
            double.parse(dotenv.env["SHOP_LON"] ?? '0.0'), lat, lon) *
        double.parse(dotenv.env['DISTANCE_FACTOR'] ?? '1.5');
  }

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
