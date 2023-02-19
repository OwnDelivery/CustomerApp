import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:own_delivery/configs/app_dimen.dart';
import 'package:own_delivery/core/page_state.dart';
import 'package:own_delivery/presentation/menu_page_presenter.dart';
import 'package:own_delivery/ui/pages/cart_page.dart';
import 'package:own_delivery/ui/pages/login_page.dart';
import 'package:own_delivery/utils/dialog_utils.dart';

import '../../core/filled_button.dart';
import '../../utils/utils.dart';
import '../widgets/food_item_widget.dart';

class MenuPage extends StatefulWidget {
  static String createRoute() {
    return 'menu';
  }

  static bool isMatchingPath(String path) {
    var uri = Uri.parse(path);
    return uri.pathSegments.length == 1 && uri.pathSegments[0] == 'menu';
  }

  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState
    extends PageState<MenuPageViewState, MenuPage, MenuPagePresenter> {
  @override
  void initState() {
    super.initState();
    presenter.fetch();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'menu_page');
  }

  @override
  MenuPagePresenter initializePresenter() {
    return MenuPagePresenter();
  }

  @override
  Widget buildWidget(BuildContext context, MenuPageViewState? viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewState?.isLoggedOut?.consume((value) {
        if (value) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.createRoute(), (r) => false);
        }
      });

      viewState?.error?.consume((error) {
        DialogUtils.showErrorDialog(
            context: context,
            errorMessage: error,
            onClose: () {
              presenter.clearError();
            });
      });
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Order Food"),
          actions: [
            IconButton(
                onPressed: () {
                  Utils.openCustomerSupport();
                },
                icon: const Icon(Icons.call)),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Logout') {
                  presenter.logout();
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: getCartMenuWidgets(viewState),
        ));
  }

  List<Widget> getCartMenuWidgets(MenuPageViewState? viewState) {
    final List<Widget> list = List.empty(growable: true);

    if (viewState?.getItems().isNotEmpty == true &&
        viewState?.isRestaurantOpen == true) {
      list.add(Expanded(
          child: Padding(
              padding: const EdgeInsets.only(
                  left: AppDimen.defaultPadding,
                  right: AppDimen.defaultPadding,
                  top: AppDimen.minPadding,
                  bottom: AppDimen.minPadding),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: viewState?.getItems().length,
                  itemBuilder: (context, index) {
                    final item = viewState?.getItems()[index];
                    if (item is SectionVo) {
                      return Column(children: [
                        const Padding(
                            padding: EdgeInsets.all(AppDimen.minPadding)),
                        Text(item.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        const Divider(thickness: 1.0, height: 1.0),
                        const Padding(
                            padding: EdgeInsets.all(AppDimen.minPadding))
                      ]);
                    } else if (item is FoodVo) {
                      return FoodItemWidget(
                        item,
                        (food, qty) {
                          presenter.toggleSelection(
                              food.sectionId, food.foodId, qty);
                        },
                      );
                    } else {
                      return const Text("");
                    }
                  }))));

      if ((viewState?.getQty() ?? 0) > 0) {
        list.add(_createCartView(
            viewState?.getQty() ?? 0, viewState?.getPrice() ?? 0.0, () {
          presenter.addToCart();
          Navigator.of(context).pushNamed(CartPage.createRoute());
        }));
      }
    } else if (viewState?.isFetching == false) {
      list.add(Padding(
          padding: const EdgeInsets.all(AppDimen.defaultPadding),
          child: Column(children: [
            Text("Restaurant is offline",
                style: Theme.of(context).textTheme.titleMedium),
            Text(viewState!.timing,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
          ])));
    } else {
      list.add(const Center(child: CircularProgressIndicator()));
    }

    return list;
  }

  Widget _createCartView(int qty, double price, VoidCallback callback) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(AppDimen.minPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$qty items | ₹$price",
              style: Theme.of(context).textTheme.bodyLarge),
          FilledButton(
            onPressed: () {
              callback();
            },
            text: 'Proceed',
          )
        ],
      ),
    ));
  }
}
