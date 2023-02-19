// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      json['is_open'] as bool,
      json['timing'] as String,
      Menu.fromJson(json['menu'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'is_open': instance.isOpen,
      'timing': instance.timing,
      'menu': instance.menu.toJson(),
    };

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      (json['sections'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Section.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'sections': instance.sections.map((k, e) => MapEntry(k, e.toJson())),
    };

Section _$SectionFromJson(Map<String, dynamic> json) => Section(
      json['name'] as String,
      json['rank'] as int,
      (json['items'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, FoodItem.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'name': instance.name,
      'rank': instance.rank,
      'items': instance.items.map((k, e) => MapEntry(k, e.toJson())),
    };

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => FoodItem(
      name: json['name'] as String,
      foodType: json['food_type'] as String,
      price: (json['price'] as num).toDouble(),
      available: json['available'] as bool,
      rank: json['rank'] as int,
    );

Map<String, dynamic> _$FoodItemToJson(FoodItem instance) => <String, dynamic>{
      'name': instance.name,
      'food_type': instance.foodType,
      'price': instance.price,
      'available': instance.available,
      'rank': instance.rank,
    };
