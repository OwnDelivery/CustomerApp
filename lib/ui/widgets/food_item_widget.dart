import 'package:flutter/material.dart';
import 'package:own_delivery/configs/app_dimen.dart';
import 'package:own_delivery/models/food_type.dart';
import 'package:own_delivery/presentation/menu_page_presenter.dart';

class FoodItemWidget extends StatelessWidget {
  final FoodVo item;
  final Function(FoodVo, int) onQtyChange;

  const FoodItemWidget(this.item, this.onQtyChange, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = FoodType.veg.color;
    if (item.type == FoodType.nonVeg.name) {
      color = FoodType.nonVeg.color;
    } else if (item.type == FoodType.egg.name) {
      color = FoodType.egg.color;
    }
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.circle, color: color),
              Text(item.name, style: Theme.of(context).textTheme.bodyLarge),
              Text("₹ ${item.price.toString()}",
                  style: Theme.of(context).textTheme.bodyMedium)
            ],
          ),
          (item.qty > 0)
              ? Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(Icons.remove),
                      ),
                      onTap: () {
                        onQtyChange(item, item.qty - 1);
                      },
                    ),
                    Text(item.qty.toString(),
                        style: Theme.of(context).textTheme.bodyLarge),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(Icons.add),
                      ),
                      onTap: () {
                        onQtyChange(item, item.qty + 1);
                      },
                    ),
                  ],
                )
              : OutlinedButton(
                  onPressed: () {
                    onQtyChange(item, item.qty + 1);
                  },
                  child: const Text('Add'),
                )
        ],
      ),
      const Padding(
        padding: EdgeInsets.all(AppDimen.minPadding),
      )
    ]);
  }
}
