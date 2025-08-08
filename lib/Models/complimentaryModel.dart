// To parse this JSON data, do
//
//     final complimentaryModel = complimentaryModelFromJson(jsonString);

import 'dart:convert';

ComplimentaryModel complimentaryModelFromJson(String str) =>
    ComplimentaryModel.fromJson(json.decode(str));

String complimentaryModelToJson(ComplimentaryModel data) =>
    json.encode(data.toJson());

class ComplimentaryModel {
  ComplimentaryModel({
    required this.d,
  });

  List<D> d;

  factory ComplimentaryModel.fromJson(Map<String, dynamic> json) =>
      ComplimentaryModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  D({
    required this.type,
    required this.skuRate,
    required this.skusid,
    required this.skuid,
    required this.skuMrpRate,
    required this.skuname,
    required this.skuimage,
    required this.skupacksize,
    this.cgst,
    this.sgst,
    required this.cgsttax,
    required this.sgsttax,
    required this.itemCount,
    this.totalItemwt,
    required this.amount,
    required this.orderid,
    this.offer,
    this.skutypeid,
    this.maxunit,
    this.orderLimit,
    required this.productstock,
    required this.maxcount,
    required this.msgreturn,
    this.isComplimentary,
  });

  String type;
  String skuRate;
  String skusid;
  String skuid;
  String skuMrpRate;
  String skuname;
  String skuimage;
  String skupacksize;
  dynamic cgst;
  dynamic sgst;
  String cgsttax;
  String sgsttax;
  String itemCount;
  dynamic totalItemwt;
  String amount;
  String orderid;
  dynamic offer;
  dynamic skutypeid;
  dynamic maxunit;
  dynamic orderLimit;
  String productstock;
  int maxcount;
  String msgreturn;
  dynamic isComplimentary;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        skuRate: json["SkuRate"],
        skusid: json["skusid"],
        skuid: json["Skuid"],
        skuMrpRate: json["skuMrpRate"],
        skuname: json["skuname"],
        skuimage: json["skuimage"],
        skupacksize: json["skupacksize"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        cgsttax: json["cgsttax"],
        sgsttax: json["sgsttax"],
        itemCount: json["ItemCount"],
        totalItemwt: json["TotalItemwt"],
        amount: json["amount"],
        orderid: json["orderid"],
        offer: json["offer"],
        skutypeid: json["skutypeid"],
        maxunit: json["maxunit"],
        orderLimit: json["OrderLimit"],
        productstock: json["productstock"],
        maxcount: json["maxcount"],
        msgreturn: json["msgreturn"],
        isComplimentary: json["IsComplimentary"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "SkuRate": skuRate,
        "skusid": skusid,
        "Skuid": skuid,
        "skuMrpRate": skuMrpRate,
        "skuname": skuname,
        "skuimage": skuimage,
        "skupacksize": skupacksize,
        "cgst": cgst,
        "sgst": sgst,
        "cgsttax": cgsttax,
        "sgsttax": sgsttax,
        "ItemCount": itemCount,
        "TotalItemwt": totalItemwt,
        "amount": amount,
        "orderid": orderid,
        "offer": offer,
        "skutypeid": skutypeid,
        "maxunit": maxunit,
        "OrderLimit": orderLimit,
        "productstock": productstock,
        "maxcount": maxcount,
        "msgreturn": msgreturn,
        "IsComplimentary": isComplimentary,
      };
}
