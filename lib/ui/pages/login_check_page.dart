import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:own_delivery/configs/app_dimen.dart';
import 'package:own_delivery/core/page_state.dart';
import 'package:own_delivery/presentation/login_check_presenter.dart';
import 'package:own_delivery/ui/pages/home_page.dart';
import 'package:own_delivery/ui/pages/login_page.dart';
import 'package:own_delivery/ui/widgets/error_page_widget.dart';

class LoginCheckPage extends StatefulWidget {
  static String createRoute() {
    return '';
  }

  static bool isMatchingPath(String path) {
    var uri = Uri.parse(path);
    return uri.pathSegments.isEmpty;
  }

  const LoginCheckPage({Key? key}) : super(key: key);

  @override
  State<LoginCheckPage> createState() => _LoginCheckPageState();
}

class _LoginCheckPageState extends PageState<LoginCheckPageViewState,
    LoginCheckPage, LoginCheckPresenter> {
  @override
  void initState() {
    super.initState();
    presenter.checkStatus();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'login_check_page');
  }

  @override
  LoginCheckPresenter initializePresenter() {
    return LoginCheckPresenter();
  }

  @override
  Widget buildWidget(BuildContext context, LoginCheckPageViewState? viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewState?.isLoggedIn?.consume((isLoggedIn) {
        if (isLoggedIn) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomePage.createRoute(), (r) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.createRoute(), (r) => false);
        }
      });
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("Mayas Kitchen",
              style: Theme.of(context).textTheme.titleMedium),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppDimen.defaultPadding),
          child: Center(
              child: viewState?.error?.consumeGet() != null
                  ? ErrorPageWidget(
                      error: viewState?.error?.peekContent(),
                      callback: () {
                        presenter.checkStatus();
                      })
                  : const CircularProgressIndicator()),
        ));
  }
}
