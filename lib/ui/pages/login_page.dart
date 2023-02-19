import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:own_delivery/configs/app_dimen.dart';
import 'package:own_delivery/core/page_state.dart';
import 'package:own_delivery/presentation/login_page_presenter.dart';
import 'package:own_delivery/ui/pages/otp_page.dart';
import 'package:own_delivery/utils/dialog_utils.dart';

import '../../core/filled_button.dart';

class LoginPage extends StatefulWidget {
  static String createRoute() {
    return 'login';
  }

  static bool isMatchingPath(String path) {
    var uri = Uri.parse(path);
    return uri.pathSegments.length == 1 && uri.pathSegments[0] == 'login';
  }

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState
    extends PageState<LoginPageViewState, LoginPage, LoginPagePresenter> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      presenter.onNameChanged(nameController.value.text);
    });
    phoneController.addListener(() {
      presenter.onPhoneChanged(phoneController.value.text);
    });
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'login_page');
  }

  @override
  LoginPagePresenter initializePresenter() {
    return LoginPagePresenter();
  }

  @override
  Widget buildWidget(BuildContext context, LoginPageViewState? viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewState?.requestOTPSuccess?.consume((value) {
        if (value) {
          Navigator.of(context).pushNamed(
              OTPPage.createRoute(viewState.name, viewState.verificationId));
        }
      });

      viewState?.error?.consume((error) {
        DialogUtils.showErrorDialog(
          context: context,
          errorMessage: error.toString(),
          onClose: () {
            presenter.clearError();
          },
        );
      });
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimen.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child:
                        Image.asset('assets/Icon.png', width: 80, height: 80)),
                const Padding(padding: EdgeInsets.all(AppDimen.minPadding)),
                TextField(
                  maxLength: 20,
                  controller: nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter your Name'),
                ),
                const Padding(padding: EdgeInsets.all(AppDimen.minPadding)),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone number',
                      hintText: 'Enter 10 digit mobile number'),
                ),
                const Padding(padding: EdgeInsets.all(AppDimen.minPadding)),
                viewState?.requestingOTP == true
                    ? const CircularProgressIndicator()
                    : FilledButton(
                        onPressed: viewState?.isValid() == true
                            ? () {
                                presenter.login();
                              }
                            : null,
                        text: 'Login',
                      ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
  }
}
