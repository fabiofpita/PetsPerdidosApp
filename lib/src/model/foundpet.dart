import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_maps_webservice/places.dart';

class FoundPet {
  String id;
  String title;
  String description;
  String type;
  String breed;
  String color;
  String lastAdress;
  double latitudeLastAdress;
  double longitudeLastAdress;
  String photoUrl;

  FoundPet();

  Future<void> setCoordinatesByPlaceId(String placeId) async {
    String content = await rootBundle.loadString("assets/credentials.json");

    var credentials = jsonDecode(content);

    String apiKey = credentials["googlePlacesApiKey"];
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);

    double lat = detail.result.geometry.location.lat;
    double lng = detail.result.geometry.location.lng;

    this.latitudeLastAdress = lat;
    this.longitudeLastAdress = lng;
  }
}
