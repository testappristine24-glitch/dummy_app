// To parse this JSON data, do
//
//     final payUHashModel = payUHashModelFromJson(jsonString);

import 'dart:convert';

PayUHashModel payUHashModelFromJson(String str) =>
    PayUHashModel.fromJson(json.decode(str));

String payUHashModelToJson(PayUHashModel data) => json.encode(data.toJson());

class PayUHashModel {
  PayUHashModel({
    required this.d,
  });

  D d;

  factory PayUHashModel.fromJson(Map<String, dynamic> json) => PayUHashModel(
        d: D.fromJson(json["d"]),
      );

  Map<String, dynamic> toJson() => {
        "d": d.toJson(),
      };
}

class D {
  D({
    required this.type,
    required this.paymentforwordtraid,
    required this.amount,
    required this.memname,
    required this.mememail,
    required this.hasstring,
    required this.udf1,
    required this.udf2,
    required this.udf3,
    required this.udf4,
    required this.udf5,
    required this.productinfo,
    required this.surl,
    required this.curl,
    required this.furl,
  });

  String type;
  String paymentforwordtraid;
  String amount;
  String memname;
  String mememail;
  String hasstring;
  String udf1;
  String udf2;
  String udf3;
  String udf4;
  String udf5;
  String productinfo;
  String surl;
  String curl;
  String furl;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        paymentforwordtraid: json["paymentforwordtraid"],
        amount: json["amount"],
        memname: json["memname"],
        mememail: json["mememail"],
        hasstring: json["Hasstring"],
        udf1: json["udf1"],
        udf2: json["udf2"],
        udf3: json["udf3"],
        udf4: json["udf4"],
        udf5: json["udf5"],
        productinfo: json["productinfo"],
        surl: json["surl"],
        curl: json["curl"],
        furl: json["furl"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "paymentforwordtraid": paymentforwordtraid,
        "amount": amount,
        "memname": memname,
        "mememail": mememail,
        "Hasstring": hasstring,
        "udf1": udf1,
        "udf2": udf2,
        "udf3": udf3,
        "udf4": udf4,
        "udf5": udf5,
        "productinfo": productinfo,
        "surl": surl,
        "curl": curl,
        "furl": furl,
      };
}
