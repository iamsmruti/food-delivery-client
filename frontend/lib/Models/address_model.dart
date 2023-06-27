import 'package:localstorage/localstorage.dart';

class Address {
  String name;
  String address;
  String streetName;
  String? state;
  String? city;
  String phoneNumber;
  double latitude;
  double longitude;
  Address(
      {required this.name,
      required this.address,
      required this.streetName,
      required this.latitude,
      required this.longitude,
      required this.phoneNumber,
      required this.city,
      required this.state});

  static LocalStorage userLocalStorage = LocalStorage('address');

  static Address? getAddress() {
    return userLocalStorage.getItem("Address1");
  }

  static addAddress(Address address) {
    userLocalStorage
        .setItem('Address1', address)
        .onError((error, stackTrace) => false);
  }

  static Map<String, dynamic> toMap(Address add) {
  return {
    'name': add.name,
    'address': add.address,
    'streetName': add.streetName,
    'state': add.state,
    'city': add.city,
    'phoneNumber': add.phoneNumber,
    'latitude': add.latitude,
    'longitude': add.longitude
  };
}

}
