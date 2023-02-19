import 'package:json_annotation/json_annotation.dart';

part 'delivery_partner.g.dart';

@JsonSerializable(explicitToJson: true)
class DeliveryPartner {
  @JsonKey(name: "phone")
  String phone;
  @JsonKey(name: "name")
  String name;

  DeliveryPartner(this.phone, this.name);

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPartnerFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryPartnerToJson(this);
}
