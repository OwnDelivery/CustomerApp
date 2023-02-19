// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      refId: json['ref_id'] as String,
      foods: (json['foods'] as List<dynamic>)
          .map((e) => OrderedFoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      orderedBy: json['ordered_by'] as String,
      contactNumber: json['contact_number'] as String,
      contactUid: json['contact_uid'] as String,
      confirmed: json['confirmed'] as bool? ?? false,
      paymentDone: json['payment_done'] as bool? ?? false,
      foodReady: json['food_ready'] as bool? ?? false,
      assignedDeliveryPartner: json['assigned_delivery_partner'] == null
          ? null
          : DeliveryPartner.fromJson(
              json['assigned_delivery_partner'] as Map<String, dynamic>),
      pickedUp: json['picked_up'] as bool? ?? false,
      delivered: json['delivered'] as bool? ?? false,
      createdAt: json['created_at'] as int,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'ref_id': instance.refId,
      'foods': instance.foods.map((e) => e.toJson()).toList(),
      'address': instance.address.toJson(),
      'ordered_by': instance.orderedBy,
      'contact_number': instance.contactNumber,
      'contact_uid': instance.contactUid,
      'confirmed': instance.confirmed,
      'payment_done': instance.paymentDone,
      'food_ready': instance.foodReady,
      'assigned_delivery_partner': instance.assignedDeliveryPartner?.toJson(),
      'picked_up': instance.pickedUp,
      'delivered': instance.delivered,
      'created_at': instance.createdAt,
    };
