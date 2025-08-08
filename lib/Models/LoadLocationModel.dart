// To parse this JSON data, do
//
//     final loadlocation = loadlocationFromJson(jsonString);

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

Loadlocation loadlocationFromJson(String str) =>
    Loadlocation.fromJson(json.decode(str));

String loadlocationToJson(Loadlocation data) => json.encode(data.toJson());

class Loadlocation {
  Loadlocation({
    this.d,
  });

  List<D>? d;

  factory Loadlocation.fromJson(Map<String, dynamic> json) => Loadlocation(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.cityId,
    this.locationName,
    this.locationId,
    this.zoneId,
    this.userName,
  });

  Type? type;
  dynamic cityId;
  String? locationName;
  String? locationId;
  dynamic zoneId;
  dynamic userName;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: typeValues.map[json["__type"]],
        cityId: json["City_id"],
        locationName: json["Location_Name"],
        locationId: json["Location_Id"],
        zoneId: json["Zone_id"],
        userName: json["UserName"],
      );

  Map<String, dynamic> toJson() => {
        "__type": typeValues.reverse[type],
        "City_id": cityId,
        "Location_Name": locationName,
        "Location_Id": locationId,
        "Zone_id": zoneId,
        "UserName": userName,
      };
}

enum Type { BO_ADMIN_BO_LOCATION }

final typeValues =
    EnumValues({"BOAdmin.BOLocation": Type.BO_ADMIN_BO_LOCATION});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
