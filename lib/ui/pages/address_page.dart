import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:own_delivery/configs/app_dimen.dart';
import 'package:own_delivery/core/filled_button.dart';
import 'package:own_delivery/core/page_state.dart';
import 'package:own_delivery/presentation/address_page_presenter.dart';
import 'package:own_delivery/utils/utils.dart';

class AddressPage extends StatefulWidget {
  static String createRoute() {
    return 'address';
  }

  static bool isMatchingPath(String path) {
    var uri = Uri.parse(path);
    return uri.pathSegments.length == 1 && uri.pathSegments[0] == 'address';
  }

  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState
    extends PageState<AddressPageViewState, AddressPage, AddressPagePresenter> {
  MapboxMapController? controller;
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    addressController.addListener(() {
      presenter.onAddressChanged(addressController.value.text);
    });
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'address_page');
  }

  @override
  Widget buildWidget(BuildContext context, AddressPageViewState? viewState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewState?.addressFetched?.consume((value) {
        if (value) {
          addressController.text = viewState.address ?? '';
          if (viewState.lat != null && viewState.lon != null) {
            controller?.moveCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(viewState.lat!, viewState.lon!), zoom: 15)));
          }
        }
      });

      viewState?.currentLocation?.consume((location) {
        controller?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
            zoom: 15)));
      });

      viewState?.addAddressSuccess?.consume((value) {
        if (value) {
          Navigator.of(context).pop();
        }
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add Address"),
      ),
      body: Column(children: [
        Flexible(
            flex: 1,
            child: Stack(
              alignment: Alignment.center,
              children: _getAddressWidgets(viewState),
            )),
        Padding(
            padding: const EdgeInsets.all(AppDimen.minPadding),
            child: Column(children: [
              if (_isNotCurrentLocation(viewState))
                OutlinedButton(
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.focusedChild?.unfocus();
                      }
                      presenter.fetchCurrentLocation();
                    },
                    child: const Text('Move to My Location')),
              if (viewState?.isLocationFeasible() == false)
                Text(
                  "We currently do not serve to this location, Move the map to correct location",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).errorColor),
                ),
              const Padding(
                  padding: EdgeInsets.only(bottom: AppDimen.minPadding)),
              _getAddressField(context, viewState),
              FilledButton(
                text: "Add Address",
                onPressed: viewState?.isAddressValid() == true
                    ? () {
                        presenter.addAddress();
                      }
                    : null,
              ),
            ])),
      ]),
    );
  }

  @override
  AddressPagePresenter initializePresenter() {
    return AddressPagePresenter();
  }

  List<Widget> _getAddressWidgets(AddressPageViewState? viewState) {
    final List<Widget> widgets = List.empty(growable: true);

    widgets.add(_getMapBoxMap());
    widgets.add(
        const Icon(Icons.location_on_rounded, size: 50, color: Colors.red));
    if (viewState?.fetchingAddress == true) {
      widgets.add(const Center(child: CircularProgressIndicator()));
    }

    return widgets;
  }

  Widget _getAddressField(
      BuildContext context, AddressPageViewState? viewState) {
    return Column(
      children: [
        TextField(
            maxLength: 200,
            maxLines: 2,
            controller: addressController,
            autofocus: false,
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Enter Full Address',
                hintText:
                    'Door No, Street, Area, ${viewState?.locality ?? ""}'))
      ],
    );
  }

  Widget _getMapBoxMap() {
    return MapboxMap(
      key: const Key(""),
      myLocationEnabled: true,
      trackCameraPosition: true,
      onMapCreated: (controller) {
        this.controller = controller;
        presenter.fetchAddress();
      },
      accessToken: dotenv.env["MAPBOX_API_KEY"] ?? "",
      initialCameraPosition:
          const CameraPosition(target: LatLng(13.0827, 80.2707), zoom: 15),
      onCameraIdle: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
        presenter.onMapChange(
            controller?.cameraPosition?.target.latitude ?? 0.0,
            controller?.cameraPosition?.target.longitude ?? 0.0);
        presenter.fetchLocality();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  bool _isNotCurrentLocation(AddressPageViewState? viewState) {
    return Utils.findDistance(
            viewState?.currentLocation?.peekContent().latitude ?? 0.0,
            viewState?.currentLocation?.peekContent().longitude ?? 0.0,
            controller?.cameraPosition?.target.latitude ?? 0.0,
            controller?.cameraPosition?.target.longitude ?? 0.0) >
        0.1;
  }
}
