import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:own_delivery/core/page_state.dart';

import '../../configs/app_dimen.dart';
import '../../core/filled_button.dart';
import '../../models/address.dart';
import '../../models/restaurant.dart';
import '../../presentation/cart_page_presenter.dart';
import '../../utils/dialog_utils.dart';
import 'address_page.dart';
import 'order_status_page.dart';

class CartPage extends StatefulWidget {
  static String createRoute() {
    return 'cart';
  }

  static bool isMatchingPath(String path) {
    var uri = Uri.parse(path);
    return uri.pathSegments.length == 1 && uri.pathSegments[0] == 'cart';
  }

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState
    extends PageState<CartPageViewState, CartPage, CartPagePresenter> {
  @override
  void initState() {
    super.initState();
    presenter.getItems();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'cart_page');
  }

  @override
  Widget buildWidget(BuildContext context, CartPageViewState? viewState) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Order"),
        ),
        body: _showContent(viewState));
  }

  Widget _showContent(CartPageViewState? viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewState?.creatingOrderSuccess?.consume((value) {
        if (value) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              OrderStatusPage.createRoute(), (r) => false);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(
              left: AppDimen.defaultPadding,
              right: AppDimen.defaultPadding,
              top: AppDimen.minPadding,
              bottom: AppDimen.minPadding),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: viewState?.selectedFoods.length,
            itemBuilder: (context, index) {
              MapEntry<FoodItem, int>? element =
                  viewState?.selectedFoods.entries.elementAt(index);
              if (element != null) {
                return _menuItemWidget(context, element.key, element.value);
              }
              return const Text('Error fetching data from cart');
            },
          ),
        )),
        Column(
          children: [
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(AppDimen.minPadding),
                  child: _getAddressView(context, viewState?.address)),
            ),
            if (viewState != null)
              Card(
                child: Padding(
                    padding: const EdgeInsets.all(AppDimen.minPadding),
                    child: _getPaymentView(context, viewState.getQty(),
                        viewState.getPrice(), viewState.address)),
              )
          ],
        )
      ],
    );
  }

  Widget _menuItemWidget(BuildContext context, FoodItem foodItem, int qty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(foodItem.name, style: Theme.of(context).textTheme.bodyLarge),
            Text("₹ ${foodItem.price}",
                style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
        Text("x $qty", style: Theme.of(context).textTheme.bodyLarge)
      ],
    );
  }

  Widget _getAddressView(BuildContext context, Address? address) {
    if (address == null) {
      return Center(
        child: FilledButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamed(AddressPage.createRoute());
            });
          },
          text: 'Add Delivery Location',
        ),
      );
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(address.fullAddress,
                maxLines: 2,
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamed(AddressPage.createRoute());
                });
              },
              child: const Text('Change'),
            )
          ],
        ),
      );
    }
  }

  Widget _getPaymentView(
      BuildContext context, int qty, double price, Address? address) {
    final widgets = List<Widget>.empty(growable: true);
    if (address != null) {
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              "Delivery charge(${address.getDeliveryDistance().toStringAsFixed(1)} km):",
              style: Theme.of(context).textTheme.bodyMedium),
          Padding(
              padding: const EdgeInsets.only(right: AppDimen.minPadding),
              child: Text("₹${address.getDeliveryCharge()}",
                  style: Theme.of(context).textTheme.bodyMedium))
        ],
      ));
    }
    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total Amount | ₹$price",
            style: Theme.of(context).textTheme.bodyLarge),
        FilledButton(
          onPressed: address != null
              ? () {
                  presenter.createOrder();
                }
              : null,
          text: 'Place Order',
        )
      ],
    ));
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets);
  }

  @override
  CartPagePresenter initializePresenter() {
    return CartPagePresenter();
  }
}
