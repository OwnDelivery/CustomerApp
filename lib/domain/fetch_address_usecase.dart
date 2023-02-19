import 'package:own_delivery/api/address_api.dart';
import 'package:own_delivery/api/user_api.dart';
import 'package:own_delivery/models/address.dart';

class FetchAddressUseCase {
  final UserApi _userApi;
  final AddressApi _addressApi;

  FetchAddressUseCase({UserApi? userApi, AddressApi? addressApi})
      : _userApi = userApi ?? UserApi(),
        _addressApi = addressApi ?? AddressApi();

  Stream<Address?> fetchAddress() async* {
    final userId = (await _userApi.getUser())?.uid ?? (throw Exception(""));
    yield* _addressApi.getAddress(userId);
  }
}
