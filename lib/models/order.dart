import 'package:json_annotation/json_annotation.dart';
import 'package:own_delivery/models/address.dart';
import 'package:own_delivery/models/delivery_partner.dart';
import 'package:own_delivery/models/ordered_food_item.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  @JsonKey(name: "ref_id")
  String refId; //For referring the orders
  @JsonKey(name: "foods")
  List<OrderedFoodItem> foods;
  @JsonKey(name: "address")
  Address address;
  @JsonKey(name: "ordered_by")
  String orderedBy;
  @JsonKey(name: "contact_number")
  String contactNumber;
  @JsonKey(name: "contact_uid")
  String contactUid;
  @JsonKey(name: "confirmed")
  bool confirmed;
  @JsonKey(name: "payment_done")
  bool paymentDone;
  @JsonKey(name: "food_ready")
  bool foodReady;
  @JsonKey(name: "assigned_delivery_partner")
  DeliveryPartner? assignedDeliveryPartner;
  @JsonKey(name: "picked_up")
  bool pickedUp;
  @JsonKey(name: "delivered")
  bool delivered;
  @JsonKey(name: "created_at")
  int createdAt;

  Order(
      {required this.refId,
      required this.foods,
      required this.address,
      required this.orderedBy,
      required this.contactNumber,
      required this.contactUid,
      this.confirmed = false,
      this.paymentDone = false,
      this.foodReady = false,
      this.assignedDeliveryPartner,
      this.pickedUp = false,
      this.delivered = false,
      required this.createdAt});

  double getTotalAmount() {
    double amount = 0.0;

    for (var value in foods) {
      amount += value.price * value.qty;
    }
    amount += address.getDeliveryCharge();

    return amount;
  }

  String getReadableId() {
    return refId.length >= 4 ? refId.substring(0, 4) : refId;
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
