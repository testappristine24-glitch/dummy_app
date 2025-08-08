// To parse this JSON data, do
//
//     final pincodeModel = pincodeModelFromJson(jsonString);

import 'dart:convert';

PincodeModel pincodeModelFromJson(String str) =>
    PincodeModel.fromJson(json.decode(str));

String pincodeModelToJson(PincodeModel data) => json.encode(data.toJson());

class PincodeModel {
  PincodeModel({
    this.d,
  });

  List<D>? d;

  factory PincodeModel.fromJson(Map<String, dynamic> json) => PincodeModel(
        d: List<D>.from(
            json["d"] != null ? json["d"].map((x) => D.fromJson(x)) : ""),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.locationId,
    this.locationName,
  });

  String? type;
  String? locationId;
  String? locationName;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"] != null ? json["__type"] : "",
        locationId: json["LocationId"] ?? "",
        locationName: json["LocationName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "LocationId": locationId,
        "LocationName": locationName,
      };
}
