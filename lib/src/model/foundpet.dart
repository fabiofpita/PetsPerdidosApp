import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_maps_webservice/places.dart';
import './pet.dart';

class FoundPet extends Pet {
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
  String user;

  FoundPet();

  FoundPet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        type = json['type'],
        breed = json['breed'],
        color = json['color'],
        lastAdress = json['lastAdress'],
        latitudeLastAdress = json['latitudeLastAdress'],
        longitudeLastAdress = json['longitudeLastAdress'],
        photoUrl = json['photoUrl'],
        user = json['user'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type,
        'breed': breed,
        'color': color,
        'lastAdress': lastAdress,
        'latitudeLastAdress': latitudeLastAdress,
        'longitudeLastAdress': longitudeLastAdress,
        'photoUrl': photoUrl,
        'user': user,
      };

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
