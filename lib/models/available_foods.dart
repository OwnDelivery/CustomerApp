import 'package:json_annotation/json_annotation.dart';

part 'available_foods.g.dart';

@JsonSerializable(explicitToJson: true)
class AvailableFoods {
  @JsonKey(name: "foods")
  List<String> foods;

  AvailableFoods(this.foods);

  factory AvailableFoods.fromJson(Map<String, dynamic> json) =>
      _$AvailableFoodsFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableFoodsToJson(this);
}
