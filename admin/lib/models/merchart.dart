import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final merchatStateProvider = StateProvider<Merchant>((ref) {
  return Merchant();
});

class Merchant extends ChangeNotifier {
  String? name;
  String? latitude;
  String? longitude;
  String? placeId;
  String? notificationToken;
  String? photoUrl;
  String? phoneNumber;
  String? description;
  Merchant(
      {this.name,
      this.latitude,
      this.longitude,
      this.placeId,
      this.notificationToken,
      this.photoUrl,
      this.phoneNumber,
      this.description});

  changeMerchant(Merchant merchant) {
    name = merchant.name;
    latitude = merchant.latitude;
    longitude = merchant.longitude;
    placeId = merchant.placeId;
    notificationToken = merchant.notificationToken;
    photoUrl = merchant.photoUrl;
    phoneNumber = merchant.phoneNumber;
    description = merchant.description;
    notifyListeners();
  }
}
