import 'package:own_delivery/api/address_api.dart';

class FetchLocalityUseCase {
  final AddressApi _addressApi;

  FetchLocalityUseCase({AddressApi? addressApi})
      : _addressApi = addressApi ?? AddressApi();

  Future<String?> fetchLocality(double lat, double lon) {
    return _addressApi.getLocality(lat, lon);
  }
}
