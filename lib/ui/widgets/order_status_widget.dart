import 'package:flutter/material.dart';
import 'package:own_delivery/models/order.dart';

class OrderStatusWidget extends StatelessWidget {
  final Order order;

  const OrderStatusWidget({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _orderStatusItem(context, Icons.create, "Created", true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: 10.0,
            color: Colors.black,
          ),
        ),
        _orderStatusItem(
            context, Icons.pedal_bike, "In Transit", order.pickedUp),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: 10.0,
            color: Colors.black,
          ),
        ),
        _orderStatusItem(context, Icons.done, "Delivered", order.delivered),
      ],
    );
  }

  Widget _orderStatusItem(BuildContext context, IconData iconData,
      String statusName, bool completed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData,
            color: completed
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor),
        Text(statusName)
      ],
    );
  }
}
