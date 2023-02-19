// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      (json['lat'] as num).toDouble(),
      (json['lon'] as num).toDouble(),
      json['full_address'] as String,
      json['locality'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'full_address': instance.fullAddress,
      'locality': instance.locality,
    };
