// To parse this JSON data, do
//
//     final orderdetailModel = orderdetailModelFromJson(jsonString);

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

OrderdetailModel orderdetailModelFromJson(String str) =>
    OrderdetailModel.fromJson(json.decode(str));

String orderdetailModelToJson(OrderdetailModel data) =>
    json.encode(data.toJson());

class OrderdetailModel {
  OrderdetailModel({
    this.d,
  });

  List<D>? d;

  factory OrderdetailModel.fromJson(Map<String, dynamic> json) =>
      OrderdetailModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.itemId,
    this.itemsubId,
    this.imagename,
    this.qty,
    this.itemName,
    this.itemRate,
    this.totalamount,
  });

  Type? type;
  String? itemId;
  String? itemsubId;
  String? imagename;
  String? qty;
  String? itemName;
  String? itemRate;
  String? totalamount;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: typeValues.map[json["__type"]],
        itemId: json["ItemId"],
        itemsubId: json["ItemsubId"],
        imagename: json["Imagename"],
        qty: json["Qty"],
        itemName: json["ItemName"],
        itemRate: json["ItemRate"],
        totalamount: json["Totalamount"],
      );

  Map<String, dynamic> toJson() => {
        "__type": typeValues.reverse[type],
        "ItemId": itemId,
        "ItemsubId": itemsubId,
        "Imagename": imagename,
        "Qty": qty,
        "ItemName": itemName,
        "ItemRate": itemRate,
        "Totalamount": totalamount,
      };
}

enum Type { BO_ADMIN_BO_ORDERDETAILS }

final typeValues =
    EnumValues({"BOAdmin.BOOrderdetails": Type.BO_ADMIN_BO_ORDERDETAILS});

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
