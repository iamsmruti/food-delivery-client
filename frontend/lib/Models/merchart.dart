// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  Merchant({
    this.name,
    this.latitude,
    this.longitude,
    this.placeId,
    this.notificationToken,
    this.photoUrl,
    this.phoneNumber,
  });

  changeMerchant(Merchant merchant) {
    name = merchant.name;
    latitude = merchant.latitude;
    longitude = merchant.longitude;
    placeId = merchant.placeId;
    notificationToken = merchant.notificationToken;
    photoUrl = merchant.photoUrl;
    phoneNumber = merchant.phoneNumber;

    notifyListeners();
  }
}
