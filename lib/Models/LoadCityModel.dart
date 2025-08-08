// To parse this JSON data, do
//
//     final loadCity = loadCityFromJson(jsonString);

import 'dart:convert';

LoadCity loadCityFromJson(String str) => LoadCity.fromJson(json.decode(str));

String loadCityToJson(LoadCity data) => json.encode(data.toJson());

class LoadCity {
  LoadCity({
    this.d,
  });

  List<D>? d;

  factory LoadCity.fromJson(Map<String, dynamic> json) => LoadCity(
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
    this.cityName,
    this.stateId,
    this.userName,
  });

  String? type;
  String? cityId;
  String? cityName;
  dynamic stateId;
  dynamic userName;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        cityId: json["City_id"],
        cityName: json["City_name"],
        stateId: json["State_Id"],
        userName: json["UserName"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "City_id": cityId,
        "City_name": cityName,
        "State_Id": stateId,
        "UserName": userName,
      };
}
