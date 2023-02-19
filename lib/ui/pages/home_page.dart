import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:own_delivery/core/page_state.dart';
import 'package:own_delivery/presentation/home_page_presenter.dart';
import 'package:own_delivery/ui/pages/menu_page.dart';
import 'package:own_delivery/ui/pages/order_status_page.dart';
import 'package:own_delivery/utils/dialog_utils.dart';

class HomePage extends StatefulWidget {
  static String createRoute() {
    return 'home';
  }

  static bool isMatchingPath(String path) {
    var uri = Uri.parse(path);
    return uri.pathSegments.length == 1 && uri.pathSegments[0] == 'home';
  }

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState
    extends PageState<HomePageViewState, HomePage, HomePagePresenter> {
  @override
  void initState() {
    super.initState();
    presenter.checkStatus();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'home_page');
  }

  @override
  Widget buildWidget(BuildContext context, HomePageViewState? viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewState?.isOrderAvailable?.consume((value) {
        if (value) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              OrderStatusPage.createRoute(), (r) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(MenuPage.createRoute(), (r) => false);
        }
      });

      viewState?.error?.consume((error) {
        DialogUtils.showErrorDialog(
            context: context,
            errorMessage: error,
            onClose: () {
              presenter.checkStatus();
            });
      });
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Mayas Kitchen"),
        ),
        body: const Center(child: CircularProgressIndicator()));
  }

  @override
  HomePagePresenter initializePresenter() {
    return HomePagePresenter();
  }
}
