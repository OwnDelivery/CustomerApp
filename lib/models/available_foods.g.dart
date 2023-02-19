// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_foods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableFoods _$AvailableFoodsFromJson(Map<String, dynamic> json) =>
    AvailableFoods(
      (json['foods'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AvailableFoodsToJson(AvailableFoods instance) =>
    <String, dynamic>{
      'foods': instance.foods,
    };
