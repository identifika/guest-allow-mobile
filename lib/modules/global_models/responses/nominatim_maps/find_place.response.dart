// To parse this JSON data, do
//
//     final nominatimFindPlaceResponse = nominatimFindPlaceResponseFromJson(jsonString);

import 'dart:convert';

NominatimFindPlaceResponse nominatimFindPlaceResponseFromJson(String str) =>
    NominatimFindPlaceResponse.fromJson(json.decode(str));

String nominatimFindPlaceResponseToJson(NominatimFindPlaceResponse data) =>
    json.encode(data.toJson());

class NominatimFindPlaceResponse {
  String? type;
  String? licence;
  List<PlaceFeature>? features;

  NominatimFindPlaceResponse({
    this.type,
    this.licence,
    this.features,
  });

  NominatimFindPlaceResponse copyWith({
    String? type,
    String? licence,
    List<PlaceFeature>? features,
  }) =>
      NominatimFindPlaceResponse(
        type: type ?? this.type,
        licence: licence ?? this.licence,
        features: features ?? this.features,
      );

  factory NominatimFindPlaceResponse.fromJson(Map<String, dynamic> json) =>
      NominatimFindPlaceResponse(
        type: json["type"],
        licence: json["licence"],
        features: json["features"] == null
            ? []
            : List<PlaceFeature>.from(
                json["features"]!.map((x) => PlaceFeature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "licence": licence,
        "features": features == null
            ? []
            : List<dynamic>.from(features!.map((x) => x.toJson())),
      };
}

class PlaceFeature {
  String? type;
  Properties? properties;
  List<double>? bbox;
  Geometry? geometry;

  PlaceFeature({
    this.type,
    this.properties,
    this.bbox,
    this.geometry,
  });

  PlaceFeature copyWith({
    String? type,
    Properties? properties,
    List<double>? bbox,
    Geometry? geometry,
  }) =>
      PlaceFeature(
        type: type ?? this.type,
        properties: properties ?? this.properties,
        bbox: bbox ?? this.bbox,
        geometry: geometry ?? this.geometry,
      );

  factory PlaceFeature.fromJson(Map<String, dynamic> json) => PlaceFeature(
        type: json["type"],
        properties: json["properties"] == null
            ? null
            : Properties.fromJson(json["properties"]),
        bbox: json["bbox"] == null
            ? []
            : List<double>.from(json["bbox"]!.map((x) => x?.toDouble())),
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "properties": properties?.toJson(),
        "bbox": bbox == null ? [] : List<dynamic>.from(bbox!.map((x) => x)),
        "geometry": geometry?.toJson(),
      };
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  Geometry copyWith({
    String? type,
    List<double>? coordinates,
  }) =>
      Geometry(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Properties {
  int? placeId;
  String? osmType;
  int? osmId;
  int? placeRank;
  String? category;
  String? type;
  double? importance;
  String? addresstype;
  String? name;
  String? displayName;

  Properties({
    this.placeId,
    this.osmType,
    this.osmId,
    this.placeRank,
    this.category,
    this.type,
    this.importance,
    this.addresstype,
    this.name,
    this.displayName,
  });

  Properties copyWith({
    int? placeId,
    String? osmType,
    int? osmId,
    int? placeRank,
    String? category,
    String? type,
    double? importance,
    String? addresstype,
    String? name,
    String? displayName,
  }) =>
      Properties(
        placeId: placeId ?? this.placeId,
        osmType: osmType ?? this.osmType,
        osmId: osmId ?? this.osmId,
        placeRank: placeRank ?? this.placeRank,
        category: category ?? this.category,
        type: type ?? this.type,
        importance: importance ?? this.importance,
        addresstype: addresstype ?? this.addresstype,
        name: name ?? this.name,
        displayName: displayName ?? this.displayName,
      );

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        placeId: json["place_id"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        placeRank: json["place_rank"],
        category: json["category"],
        type: json["type"],
        importance: json["importance"]?.toDouble(),
        addresstype: json["addresstype"],
        name: json["name"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "osm_type": osmType,
        "osm_id": osmId,
        "place_rank": placeRank,
        "category": category,
        "type": type,
        "importance": importance,
        "addresstype": addresstype,
        "name": name,
        "display_name": displayName,
      };
}
