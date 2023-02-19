import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '../firebase_options.dart';

Future<void> configureApp() async {
  //Load environment values
  await dotenv.load(fileName: 'env');

  //Initialize url strategy
  setUrlStrategy(PathUrlStrategy());

  //Configure firebase
  //TODO Replace it with actual file. Refer firebase_options.template.dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
  //   fetchTimeout: const Duration(minutes: 1),
  //   minimumFetchInterval: const Duration(hours: 1),
  // ));
  // await FirebaseRemoteConfig.instance.setDefaults({
  //   "distance_factor": 1.5,
  //   "delivery_charge_per_km": 15,
  //   "customer_support_no": "7824012886",
  //   "upi_link": "paytmqr281005050101bjpzpjjch1ok@paytm",
  //   "paytm_qr": "281005050101bjpzpjjch1ok"
  // });
  // await FirebaseRemoteConfig.instance.fetchAndActivate();

  //Configure debug mode
  if (dotenv.env['DEBUG'] == 'true') {
    try {
      FirebaseDatabase.instance.useDatabaseEmulator("127.0.0.1", 4000);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
