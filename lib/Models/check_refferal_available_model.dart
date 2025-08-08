// To parse this JSON data, do
//
//     final checkReferalavailableModel = checkReferalavailableModelFromJson(jsonString);

import 'dart:convert';

CheckReferalavailableModel checkReferalavailableModelFromJson(String str) =>
    CheckReferalavailableModel.fromJson(json.decode(str));

String checkReferalavailableModelToJson(CheckReferalavailableModel data) =>
    json.encode(data.toJson());

class CheckReferalavailableModel {
  D d;

  CheckReferalavailableModel({
    required this.d,
  });

  factory CheckReferalavailableModel.fromJson(Map<String, dynamic> json) =>
      CheckReferalavailableModel(
        d: D.fromJson(json["d"]),
      );

  Map<String, dynamic> toJson() => {
        "d": d.toJson(),
      };
}

class D {
  String? type;
  String? rewardId;
  String? rewardAmount;
  String? couponcode;
  String? invoiceamount;
  String? catid;
  String? cityid;
  String? locationId;
  String? imgpath;
  String? msgtext;
  String? referalcode;

  D({
    this.type,
    this.rewardId,
    this.rewardAmount,
    this.couponcode,
    this.invoiceamount,
    this.catid,
    this.cityid,
    this.locationId,
    this.imgpath,
    this.msgtext,
    this.referalcode,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        rewardId: json["RewardId"],
        rewardAmount: json["RewardAmount"],
        couponcode: json["Couponcode"],
        invoiceamount: json["invoiceamount"],
        catid: json["catid"],
        cityid: json["cityid"],
        locationId: json["locationId"],
        imgpath: json["imgpath"],
        msgtext: json["msgtext"],
        referalcode: json["Referalcode"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "RewardId": rewardId,
        "RewardAmount": rewardAmount,
        "Couponcode": couponcode,
        "invoiceamount": invoiceamount,
        "catid": catid,
        "cityid": cityid,
        "locationId": locationId,
        "imgpath": imgpath,
        "msgtext": msgtext,
        "Referalcode": referalcode,
      };
}
