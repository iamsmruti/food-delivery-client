// To parse this JSON data, do
//
//  final placeSearch = placeSearchFromJson(jsonString);

import 'dart:convert';

PlaceSearch placeSearchFromJson(String str) => PlaceSearch.fromJson(json.decode(str));

class PlaceSearch {
    List<Prediction> predictions;
    String status;

    PlaceSearch({
        required this.predictions,
        required this.status,
    });

    factory PlaceSearch.fromJson(Map<String, dynamic> json) => PlaceSearch(
        predictions: List<Prediction>.from(json["predictions"].map((x) => Prediction.fromJson(x))),
        status: json["status"],
    );
}

class Prediction {
    String description;
    String placeId;

    Prediction({
        required this.description,
        required this.placeId,
    });

    factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        placeId: json["place_id"],
    );
}