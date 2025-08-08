// To parse this JSON data, do
//
//     final walletDetailsModel = walletDetailsModelFromJson(jsonString);

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

WalletDetailsModel walletDetailsModelFromJson(String str) =>
    WalletDetailsModel.fromJson(json.decode(str));

String walletDetailsModelToJson(WalletDetailsModel data) =>
    json.encode(data.toJson());

class WalletDetailsModel {
  WalletDetailsModel({
    this.d,
  });

  List<D>? d;

  factory WalletDetailsModel.fromJson(Map<String, dynamic> json) =>
      WalletDetailsModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.membershipno,
    this.creditamount,
    this.debitamount,
    this.transactiondate,
    this.transactiondetails,
  });

  Type? type;
  dynamic membershipno;
  String? creditamount;
  String? debitamount;
  String? transactiondate;
  String? transactiondetails;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: typeValues.map[json["__type"]],
        membershipno: json["membershipno"],
        creditamount: json["creditamount"],
        debitamount: json["debitamount"],
        transactiondate: json["transactiondate"],
        transactiondetails: json["transactiondetails"],
      );

  Map<String, dynamic> toJson() => {
        "__type": typeValues.reverse[type],
        "membershipno": membershipno,
        "creditamount": creditamount,
        "debitamount": debitamount,
        "transactiondate": transactiondate,
        "transactiondetails": transactiondetails,
      };
}

enum Itamount { EMPTY, THE_5000 }

final itamountValues =
    EnumValues({"": Itamount.EMPTY, "50.00": Itamount.THE_5000});

enum Type { BO_ADMIN_BO_WALLET_EXPRESS }

final typeValues =
    EnumValues({"BOAdmin.BOWalletExpress": Type.BO_ADMIN_BO_WALLET_EXPRESS});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
