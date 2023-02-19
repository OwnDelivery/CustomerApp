import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:own_delivery/core/page_state.dart';
import 'package:own_delivery/models/order.dart';
import 'package:own_delivery/models/ordered_food_item.dart';
import 'package:own_delivery/presentation/order_status_page_presenter.dart';
import 'package:own_delivery/ui/pages/menu_page.dart';
import 'package:own_delivery/ui/widgets/error_page_widget.dart';
import 'package:own_delivery/ui/widgets/order_status_widget.dart';
import 'package:own_delivery/utils/utils.dart';

import '../../configs/app_dimen.dart';
import 'login_page.dart';

class OrderStatusPage extends StatefulWidget {
  static String createRoute() {
    return 'my-orders';
  }

  static bool isMatchingPath(String path) {
    var uri = Uri.parse(path);
    return uri.pathSegments.length == 1 && uri.pathSegments[0] == 'my-orders';
  }

  const OrderStatusPage({Key? key}) : super(key: key);

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends PageState<OrderStatusPageViewState,
    OrderStatusPage, OrderStatusPagePresenter> {
  @override
  void initState() {
    super.initState();
    presenter.getOrders();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'order_status_page');
  }

  @override
  Widget buildWidget(
      BuildContext context, OrderStatusPageViewState? viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewState?.isLoggedOut?.consume((value) {
        if (value) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.createRoute(), (r) => false);
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Order"),
        actions: [
          IconButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamed(MenuPage.createRoute());
                });
              },
              icon: const Icon(Icons.close)),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(AppDimen.defaultPadding),
          child: viewState?.error?.consumeGet() != null
              ? ErrorPageWidget(
                  error: viewState?.error?.peekContent(),
                  callback: () => {presenter.getOrders()})
              : viewState == null || viewState.isFetching == true
                  ? const Center(child: CircularProgressIndicator())
                  : _getOrderWidget(context, viewState.order!)),
    );
  }

  Widget _getOrderWidget(BuildContext context, Order order) {
    return Column(
      children: [
        Text('#${order.refId.substring(0, 4)}',
            style: Theme.of(context).textTheme.titleMedium),
        const Divider(),
        OrderStatusWidget(order: order),
        const Divider(),
        Expanded(
            child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: order.foods.length,
          itemBuilder: (context, index) {
            return _menuItemWidget(context, order.foods[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        )),
        const Divider(thickness: 1.0, height: 1.0),
        const Padding(padding: EdgeInsets.only(top: AppDimen.minPadding)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Delivery Charge(${order.address.getDeliveryDistance().toStringAsFixed(1)} km)",
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(
                    "₹ ${order.address.getDeliveryCharge().toStringAsFixed(0)}",
                    style: Theme.of(context).textTheme.bodyMedium)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Amount",
                    style: Theme.of(context).textTheme.bodyLarge),
                Text("₹ ${order.getTotalAmount()}",
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            )
          ],
        ),
        if (!order.paymentDone)
          Text("Pay on Delivery",
              style: Theme.of(context).textTheme.bodyMedium),
        // FilledButton(
        //     onPressed: () {
        //       presenter.requestPayment(order);
        //     },
        //     text: "Make Payment"),
        const Padding(padding: EdgeInsets.only(top: AppDimen.minPadding)),
        const Divider(thickness: 1.0, height: 1.0),
        if (order.pickedUp)
          TextButton(
              onPressed: () {
                Utils.openSupport(order.assignedDeliveryPartner?.phone ?? "");
              },
              child: const Text("Contact Driver")),
        if (!order.pickedUp)
          TextButton(
              onPressed: () {
                Utils.openCustomerSupport();
              },
              child: const Text("Contact Shop")),
        OutlinedButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamed(MenuPage.createRoute());
              });
            },
            child: const Text("Order again"))
      ],
    );
  }

  Widget _menuItemWidget(BuildContext context, OrderedFoodItem food) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food.name, style: Theme.of(context).textTheme.bodyLarge),
            Text("₹ ${food.price}",
                style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
        Text("x ${food.qty}", style: Theme.of(context).textTheme.bodyLarge)
      ],
    );
  }

  @override
  OrderStatusPagePresenter initializePresenter() {
    return OrderStatusPagePresenter();
  }
}
