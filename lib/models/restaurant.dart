import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  @JsonKey(name: "is_open")
  bool isOpen;
  @JsonKey(name: "timing")
  String timing;
  @JsonKey(name: "menu")
  Menu menu;

  Restaurant(this.isOpen, this.timing, this.menu);

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Menu {
  @JsonKey(name: "sections")
  Map<String, Section> sections;

  Menu(this.sections);

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Section {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "rank")
  int rank;
  @JsonKey(name: "items")
  Map<String, FoodItem> items;

  Section(this.name, this.rank, this.items);

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FoodItem {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "food_type")
  String foodType;
  @JsonKey(name: "price")
  double price;
  @JsonKey(name: "available")
  bool available;
  @JsonKey(name: "rank")
  int rank;

  FoodItem(
      {required this.name,
      required this.foodType,
      required this.price,
      required this.available,
      required this.rank});

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemToJson(this);
}
