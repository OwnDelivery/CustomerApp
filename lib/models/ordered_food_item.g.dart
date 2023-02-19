// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordered_food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderedFoodItem _$OrderedFoodItemFromJson(Map<String, dynamic> json) =>
    OrderedFoodItem(
      json['name'] as String,
      json['food_type'] as String,
      (json['price'] as num).toDouble(),
      json['qty'] as int,
    );

Map<String, dynamic> _$OrderedFoodItemToJson(OrderedFoodItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'food_type': instance.foodType,
      'price': instance.price,
      'qty': instance.qty,
    };
