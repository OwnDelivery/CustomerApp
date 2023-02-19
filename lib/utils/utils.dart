import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._();

  static T enumFromString<T>(Iterable<T> values, String value, T defaultValue) {
    return values.firstWhere(
        (type) => (type as dynamic).name.toString().split(".").last == value,
        orElse: () {
      return defaultValue;
    });
  }

  static void openCustomerSupport() async {
    openSupport(dotenv.env["CUSTOMER_SUPPORT_NO"] ?? "");
  }

  static void openSupport(String driverNo) async {
    Uri callUrl = Uri.parse('tel:$driverNo');
    await _openUrl(callUrl);
  }

  static Future<bool> _openUrl(Uri uri) async {
    await canLaunchUrl(uri);
    return (await launchUrl(uri,
        mode: LaunchMode.externalNonBrowserApplication));
  }

  static int getRandomRefNo() {
    return _randomBetween(1000, 9999);
  }

  static int _randomBetween(int min, int max) =>
      min + Random().nextInt((max + 1) - min);

  static int getCurrentTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static double findDistance(double lt1, double lon1, double lt2, double lon2) {
    var lat1 = _toRadian(lt1);
    var lng1 = _toRadian(lon1);
    var lat2 = _toRadian(lt2);
    var lng2 = _toRadian(lon2);

    // Haversine Formula
    var dlong = lng2 - lng1;
    var dlat = lat2 - lat1;

    var res = pow(sin((dlat / 2)), 2) +
        cos(lat1) * cos(lat2) * pow(sin(dlong / 2), 2);
    res = 2 * asin(sqrt(res));
    double R = 6371;
    res = res * R;
    return res;
  }

  static double _toRadian(double val) {
    double oneDeg = (pi) / 180;
    return (oneDeg * val);
  }
}
