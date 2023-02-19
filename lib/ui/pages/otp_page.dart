import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:own_delivery/configs/app_dimen.dart';
import 'package:own_delivery/core/page_state.dart';
import 'package:own_delivery/ui/pages/home_page.dart';
import 'package:own_delivery/utils/dialog_utils.dart';

import '../../core/filled_button.dart';
import '../../presentation/otp_page_presenter.dart';

class OTPPage extends StatefulWidget {
  static String createRoute(String name, String verificationId) {
    return 'otp?name=$name&verificationId=$verificationId';
  }

  static bool isMatchingPath(String path) {
    var uri = Uri.parse(path);
    return uri.pathSegments.length == 1 && uri.pathSegments[0] == 'otp';
  }

  static String? parseName(String path) {
    var uri = Uri.parse(path);
    return uri.queryParameters['name'];
  }

  static String? parseVerificationId(String path) {
    var uri = Uri.parse(path);
    return uri.queryParameters['verificationId'];
  }

  final String name;
  final String verificationId;

  const OTPPage({Key? key, required this.name, required this.verificationId})
      : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState
    extends PageState<OTPPageViewState, OTPPage, OTPPagePresenter> {
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      presenter.onOTPChanged(otpController.text);
    });
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'otp_page');
  }

  @override
  OTPPagePresenter initializePresenter() {
    return OTPPagePresenter();
  }

  @override
  Widget buildWidget(BuildContext context, OTPPageViewState? viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewState?.loginSuccess?.consume((value) {
        if (value) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomePage.createRoute(), (r) => false);
        }
      });

      viewState?.error?.consume((value) {
        DialogUtils.showErrorDialog(
          context: context,
          errorMessage: value,
          onClose: () {
            presenter.clearError();
          },
        );
      });
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Enter OTP"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimen.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/Icon.png', width: 80, height: 80),
                const Padding(padding: EdgeInsets.all(AppDimen.minPadding)),
                const Text("Please enter the OTP received in SMS"),
                const Padding(padding: EdgeInsets.all(AppDimen.minPadding)),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter OTP',
                      hintText: 'OTP from SMS'),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                viewState?.verifyingOTP == true
                    ? const CircularProgressIndicator()
                    : FilledButton(
                        onPressed: viewState?.isValid() == true
                            ? () {
                                presenter.verifyOTP(
                                    widget.name, widget.verificationId);
                              }
                            : null,
                        text: 'Verify OTP',
                      ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
