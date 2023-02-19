import 'package:json_annotation/json_annotation.dart';

part 'ordered_food_item.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderedFoodItem {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "food_type")
  String foodType;
  @JsonKey(name: "price")
  double price;
  @JsonKey(name: "qty")
  int qty;

  OrderedFoodItem(this.name, this.foodType, this.price, this.qty);

  factory OrderedFoodItem.fromJson(Map<String, dynamic> json) =>
      _$OrderedFoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderedFoodItemToJson(this);
}
