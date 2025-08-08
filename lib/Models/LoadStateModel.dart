// To parse this JSON data, do
//
//     final loadState = loadStateFromJson(jsonString);

import 'dart:convert';

LoadState loadStateFromJson(String str) => LoadState.fromJson(json.decode(str));

String loadStateToJson(LoadState data) => json.encode(data.toJson());

class LoadState {
  LoadState({
    this.d,
  });

  List<D>? d;

  factory LoadState.fromJson(Map<String, dynamic> json) => LoadState(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.stateId,
    this.stateName,
    this.userName,
    this.countryId,
    this.country,
  });

  String? type;
  String? stateId;
  String? stateName;
  dynamic userName;
  String? countryId;
  String? country;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        stateId: json["State_ID"],
        stateName: json["State_Name"],
        userName: json["UserName"],
        countryId: json["Country_Id"],
        country: json["Country"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "State_ID": stateId,
        "State_Name": stateName,
        "UserName": userName,
        "Country_Id": countryId,
        "Country": country,
      };
}
