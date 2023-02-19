import 'package:own_delivery/api/address_api.dart';
import 'package:own_delivery/api/user_api.dart';
import 'package:own_delivery/models/address.dart';

class UpdateAddressUseCase {
  final UserApi _userApi;
  final AddressApi _addressApi;

  UpdateAddressUseCase({UserApi? userApi, AddressApi? addressApi})
      : _userApi = userApi ?? UserApi(),
        _addressApi = addressApi ?? AddressApi();

  Future<void> updateAddress(Address address) {
    return _userApi.getUser().then((user) => _addressApi
        .updateAddress(user?.uid ?? "", address)
        .then((value) => value));
  }
}
