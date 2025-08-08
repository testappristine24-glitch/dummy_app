// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

CityListModel storeModelFromJson(String str) =>
    CityListModel.fromJson(json.decode(str));

String storeModelToJson(CityListModel data) => json.encode(data.toJson());

class CityListModel {
  CityListModel({
    this.cityData,
  });

  List<CityData>? cityData;

  factory CityListModel.fromJson(Map<String, dynamic> json) => CityListModel(
    cityData: List<CityData>.from(json["d"].map((x) => CityData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(cityData!.map((x) => x.toJson())),
      };
}

class CityData {
  CityData({
    this.CityName,
    this.CityId,
    this.companyId,
  });

  String? CityName;
  String? CityId;
  String? companyId;

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
      CityName: json["CityName"],
      CityId: json["CityId"],
      companyId: json["companyId"]);

  Map<String, dynamic> toJson() => {
        "CityName": CityName,
        "CityId": CityId,
        "companyId": companyId,

      };
}