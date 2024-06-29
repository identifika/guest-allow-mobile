// To parse this JSON data, do
//
//     final findPlaceResponses = findPlaceResponsesFromJson(jsonString);

import 'dart:convert';

FindPlaceResponses findPlaceResponsesFromJson(String str) =>
    FindPlaceResponses.fromJson(json.decode(str));

String findPlaceResponsesToJson(FindPlaceResponses data) =>
    json.encode(data.toJson());

class FindPlaceResponses {
  List<Candidate>? candidates;
  String? status;

  FindPlaceResponses({
    this.candidates,
    this.status,
  });

  FindPlaceResponses copyWith({
    List<Candidate>? candidates,
    String? status,
  }) =>
      FindPlaceResponses(
        candidates: candidates ?? this.candidates,
        status: status ?? this.status,
      );

  factory FindPlaceResponses.fromJson(Map<String, dynamic> json) =>
      FindPlaceResponses(
        candidates: json["candidates"] == null
            ? []
            : List<Candidate>.from(
                json["candidates"]!.map((x) => Candidate.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "candidates": candidates == null
            ? []
            : List<dynamic>.from(candidates!.map((x) => x.toJson())),
        "status": status,
      };
}

class Candidate {
  String? formattedAddress;
  Geometry? geometry;
  String? name;
  OpeningHours? openingHours;
  double? rating;

  Candidate({
    this.formattedAddress,
    this.geometry,
    this.name,
    this.openingHours,
    this.rating,
  });

  Candidate copyWith({
    String? formattedAddress,
    Geometry? geometry,
    String? name,
    OpeningHours? openingHours,
    double? rating,
  }) =>
      Candidate(
        formattedAddress: formattedAddress ?? this.formattedAddress,
        geometry: geometry ?? this.geometry,
        name: name ?? this.name,
        openingHours: openingHours ?? this.openingHours,
        rating: rating ?? this.rating,
      );

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        name: json["name"],
        openingHours: json["opening_hours"] == null
            ? null
            : OpeningHours.fromJson(json["opening_hours"]),
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "name": name,
        "opening_hours": openingHours?.toJson(),
        "rating": rating,
      };
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  Geometry copyWith({
    Location? location,
    Viewport? viewport,
  }) =>
      Geometry(
        location: location ?? this.location,
        viewport: viewport ?? this.viewport,
      );

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        viewport: json["viewport"] == null
            ? null
            : Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "viewport": viewport?.toJson(),
      };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  Location copyWith({
    double? lat,
    double? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  Viewport copyWith({
    Location? northeast,
    Location? southwest,
  }) =>
      Viewport(
        northeast: northeast ?? this.northeast,
        southwest: southwest ?? this.southwest,
      );

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: json["northeast"] == null
            ? null
            : Location.fromJson(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}

class OpeningHours {
  bool? openNow;

  OpeningHours({
    this.openNow,
  });

  OpeningHours copyWith({
    bool? openNow,
  }) =>
      OpeningHours(
        openNow: openNow ?? this.openNow,
      );

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
        openNow: json["open_now"],
      );

  Map<String, dynamic> toJson() => {
        "open_now": openNow,
      };
}
