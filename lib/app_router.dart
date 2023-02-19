import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:own_delivery/ui/pages/address_page.dart';
import 'package:own_delivery/ui/pages/broken_page.dart';
import 'package:own_delivery/ui/pages/cart_page.dart';
import 'package:own_delivery/ui/pages/home_page.dart';
import 'package:own_delivery/ui/pages/login_check_page.dart';
import 'package:own_delivery/ui/pages/login_page.dart';
import 'package:own_delivery/ui/pages/menu_page.dart';
import 'package:own_delivery/ui/pages/order_status_page.dart';
import 'package:own_delivery/ui/pages/otp_page.dart';

class AppRouter {
  static Widget route(String path) {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        if (OTPPage.isMatchingPath(path)) {
          return OTPPage(
              name: OTPPage.parseName(path) ?? (throw Exception("")),
              verificationId: OTPPage.parseVerificationId(path) ??
                  (throw Exception("verification id missing")));
        } else if (LoginPage.isMatchingPath(path)) {
          return const LoginPage();
        } else {
          return const LoginCheckPage();
        }
      } else {
        if (HomePage.isMatchingPath(path)) {
          return const HomePage();
        } else if (MenuPage.isMatchingPath(path)) {
          return const MenuPage();
        } else if (CartPage.isMatchingPath(path)) {
          return const CartPage();
        } else if (AddressPage.isMatchingPath(path)) {
          return const AddressPage();
        } else if (OrderStatusPage.isMatchingPath(path)) {
          return const OrderStatusPage();
        } else if (LoginCheckPage.isMatchingPath(path)) {
          return const LoginCheckPage();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        Logger().log(Level.error, e);
      }
    }
    return const BrokenPage();
  }
}
