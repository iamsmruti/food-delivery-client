import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final merchatStateProvider = StateProvider<Merchant>((ref) {
  return Merchant();
});

class Merchant extends ChangeNotifier {
  String? id;
  String? name;
  double? latitude;
  double? longitude;
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
      this.id,
      this.description});
}


