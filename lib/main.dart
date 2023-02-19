import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'app_router.dart';
import 'configs/configure_web.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureApp();
  FirebaseAnalytics.instance.logAppOpen();
  runApp(const MayasApp());
}

class MayasApp extends StatelessWidget {
  const MayasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mayas Kitchen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
            useMaterial3: true,
            colorScheme: const ColorScheme.highContrastLight()
                .copyWith(primary: const Color(0XFFE26126))),
        onGenerateRoute: (settings) => MaterialPageRoute(
            settings: RouteSettings(
                name: settings.name, arguments: settings.arguments),
            maintainState: true,
            builder: (context) => AppRouter.route(settings.name!)));
  }
}
