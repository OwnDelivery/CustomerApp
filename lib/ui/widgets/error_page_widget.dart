import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:own_delivery/utils/utils.dart';

class ErrorPageWidget extends StatelessWidget {
  final dynamic error;
  final String? message;
  final VoidCallback? callback;

  const ErrorPageWidget(
      {super.key, required this.error, this.message, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (kDebugMode)
          Text(error?.toString() ?? "No error",
              style: Theme.of(context).textTheme.bodySmall),
        Text(message ?? "Something went wrong",
            style: Theme.of(context).textTheme.bodyMedium),
        if (callback != null)
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  callback!();
                },
                child: const Text('Retry'),
              ),
              const Text("or"),
              OutlinedButton(
                  onPressed: () {
                    Utils.openCustomerSupport();
                  },
                  child: Text(
                      "Contact support ${dotenv.env["customer_support_no"] ?? ""}"))
            ],
          )
      ],
    );
  }
}
