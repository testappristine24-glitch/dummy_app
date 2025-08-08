/* class BannerModel {
  String? bannerId;
  String? bannerImage;

  BannerModel({
    this.bannerId,
    this.bannerImage,
  });
} */
// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

GetMapFlag mapFlagModelFromJson(String str) =>
    GetMapFlag.fromJson(json.decode(str));

String mapFlagModelToJson(GetMapFlag data) => json.encode(data.toJson());

class GetMapFlag {
  GetMapFlag({
    this.d,
  });

  D? d;

  factory GetMapFlag.fromJson(Map<String, dynamic> json) => GetMapFlag(
    d: D.fromJson(json["d"]),
  );

  Map<String, dynamic> toJson() => {
    "d": d!.toJson(),
  };
}

class D {
  D({
    this.type,
    this.MapName,
  });

  String? type;
  String? MapName;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
    MapName: json["MapName"],

      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "MapName": MapName,
      };
}
