import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';

import '../models/place_search.dart';

class GoogleMapsHandler {
  String API_KEY = 'AIzaSyDzZIfF8tcz2poemY8_6DCEd19t2FhtlV4';
  Future getAutocomplete(searchQuery) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&language=en&types=geocode&key=$API_KEY&types=sublocality';

    var response = await http.get(Uri.parse(url));
    return placeSearchFromJson(response.body);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // Will Return the distance in meter
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  // getPositionFromStorage() async {
  //   LocalStorage storageInstance =
  //       LocalStorage();
  //   if (await storageInstance.ready) {
  //     return storageInstance.getItem('user-location')["location"];
  //   }
  // }

  dynamic getCoordinatesFromPlaceID(String placeID) async {
    const String apiKey = "AIzaSyBg-zP2SI88okiEVVRv7v9Awp76BCUKswA";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeID&key=$apiKey";
    http.Response? response;

    try {
      response = await http.get(Uri.parse(url));
      dynamic decodedResponse = convert.jsonDecode(response.body);
      return decodedResponse["results"][0]["geometry"]["location"];
    } catch (e) {
      return e.toString();
    }
  }

  //For Testing
  testFunction() {
    List<List<double>> cords = [
      [37.4419983, -121.184],
      [37.5019983, -122.124],
      [37.4119983, -122.184],
    ];
    for (List<double> a in cords) {
      print(calculateDistance(37.4019983, -122.184, a[0], a[1]));
    }
    cords.sort((a, b) => calculateDistance(37.4019983, -122.184, a[0], a[1])
        .compareTo(calculateDistance(37.4019983, -122.184, b[0], b[1])));
    print(cords);
  }
}
