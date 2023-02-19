import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:own_delivery/core/presenter.dart';
import 'package:own_delivery/core/single_event.dart';
import 'package:own_delivery/domain/fetch_address_usecase.dart';
import 'package:own_delivery/domain/fetch_locality_usecase.dart';
import 'package:own_delivery/domain/update_address_usecase.dart';

import '../models/address.dart';
import '../utils/utils.dart';

class AddressPagePresenter extends Presenter<AddressPageViewState> {
  final FetchAddressUseCase _fetchAddressUseCase;
  final FetchLocalityUseCase _fetchLocalityUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final AddressPageViewState _viewState = AddressPageViewState();

  AddressPagePresenter(
      {FetchAddressUseCase? fetchAddressUseCase,
      FetchLocalityUseCase? fetchLocalityUseCase,
      UpdateAddressUseCase? updateAddressUseCase})
      : _fetchAddressUseCase = fetchAddressUseCase ?? FetchAddressUseCase(),
        _fetchLocalityUseCase = fetchLocalityUseCase ?? FetchLocalityUseCase(),
        _updateAddressUseCase = updateAddressUseCase ?? UpdateAddressUseCase();

  void onMapChange(double lat, double lon) {
    _viewState.lat = lat;
    _viewState.lon = lon;
  }

  void fetchAddress() {
    _viewState.fetchingAddress = true;
    _viewState.addressFetched = SingleEvent(false);
    getSink().add(_viewState);

    _fetchAddressUseCase.fetchAddress().first.then((value) {
      if (value != null) {
        _viewState.lat = value.lat;
        _viewState.lon = value.lon;
        _viewState.address = value.fullAddress ?? "";
        _viewState.locality = value.locality ?? "";
        _viewState.fetchingAddress = false;
        _viewState.addressFetched = SingleEvent(true);
        getSink().add(_viewState);
      } else {
        _viewState.fetchingAddress = false;
        _viewState.addressFetched = SingleEvent(true);
        _viewState.address = "";
        _viewState.locality = "";
        getSink().add(_viewState);
        fetchCurrentLocation();
      }
    }).catchError((error) {
      _viewState.fetchingAddress = false;
      _viewState.addressFetched = SingleEvent(true);
      _viewState.error = SingleEvent('Error fetching address');
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logEvent(name: 'address_fetch_failed');
    });
  }

  void fetchLocality() {
    _fetchLocalityUseCase
        .fetchLocality(_viewState.lat!, _viewState.lon!)
        .then((value) {
      if (value != null) {
        _viewState.locality = value;
      } else {
        _viewState.locality = "";
      }
      getSink().add(_viewState);
    }).catchError((error) {});
  }

  void addAddress() {
    _viewState.addingAddress = true;
    getSink().add(_viewState);
    _updateAddressUseCase
        .updateAddress(Address(_viewState.lat!, _viewState.lon!,
            _viewState.address, _viewState.locality))
        .then((value) {
      _viewState.addingAddress = false;
      _viewState.addAddressSuccess = SingleEvent(true);
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logEvent(name: 'address_create_success');
    }).catchError((e) {
      _viewState.error = SingleEvent('Error adding address');
      getSink().add(_viewState);
      FirebaseAnalytics.instance.logEvent(name: 'address_create_failed');
    });
  }

  void onAddressChanged(String address) {
    _viewState.address = address;
    getSink().add(_viewState);
  }

  Future<LocationData?> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        FirebaseAnalytics.instance.logEvent(name: 'location_permission_denied');
        return Future.value(null);
      }
    }

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        FirebaseAnalytics.instance.logEvent(name: 'location_enable_failed');
        return Future.value(null);
      }
    }

    locationData = await location.getLocation();

    return Future.value(locationData);
  }

  void fetchCurrentLocation() {
    _getCurrentLocation().then((value) {
      if (value != null) {
        _viewState.currentLocation = SingleEvent(value);
        getSink().add(_viewState);
        FirebaseAnalytics.instance
            .logEvent(name: 'fetch_current_location_success');
      } else {
        FirebaseAnalytics.instance
            .logEvent(name: 'fetch_current_location_failed');
      }
    });
  }
}

class AddressPageViewState {
  double? lat;
  double? lon;
  String address = "";
  String locality = "";
  SingleEvent<LocationData>? currentLocation;
  SingleEvent<bool>? addressFetched;
  bool fetchingAddress = false;
  bool addingAddress = false;
  SingleEvent<bool>? addAddressSuccess;
  SingleEvent<String>? error;

  bool isAddressValid() {
    return isLocationFeasible() &&
        address.isNotEmpty &&
        address.length >
            5; //Arbitrary check to prevent lazy inputs. Need to improve
  }

  bool isLocationFeasible() {
    return lat != null &&
        lon != null &&
        Utils.findDistance(
                lat!,
                lon!,
                double.parse(dotenv.env["SHOP_LAT"] ?? '0.0'),
                double.parse(dotenv.env["SHOP_LON"] ?? '0.0')) <=
            double.parse(dotenv.env["MAX_DISTANCE_ALLOWED"] ?? '0.0');
  }
}
