import 'package:flutter/material.dart';

enum FoodType {
  veg("VEG", Color(0xff4da477)),
  nonVeg("NON_VEG", Color(0xffff5c04)),
  egg("EGG", Color(0xffff5c04));

  const FoodType(this.name, this.color);

  final String name;
  final Color color;
}
