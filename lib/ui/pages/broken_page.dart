import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:own_delivery/core/filled_button.dart';
import 'package:own_delivery/ui/pages/login_check_page.dart';

class BrokenPage extends StatefulWidget {
  final dynamic exception;

  const BrokenPage({Key? key, this.exception}) : super(key: key);

  @override
  State<BrokenPage> createState() => _BrokenPageState();
}

class _BrokenPageState extends State<BrokenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Oops!. something went wrong"),
          FilledButton(
              text: "Go to Home page",
              onPressed: () {
                Navigator.of(context).pushNamed(LoginCheckPage.createRoute());
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'broken_page');
  }
}
