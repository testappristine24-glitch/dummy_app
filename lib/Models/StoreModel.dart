// ignore_for_file: unnecessary_null_comparison

/* class StoreModel {
  String? storeId;
  String? name;
  String? address;
  String? contactNo;
  String? timing;
  String? image;

  StoreModel(
      {this.storeId,
      this.name,
      this.address,
      this.contactNo,
      this.timing,
      this.image});
} */
// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

StoreModel storeModelFromJson(String str) =>
    StoreModel.fromJson(json.decode(str));

String storeModelToJson(StoreModel data) => json.encode(data.toJson());

class StoreModel {
  StoreModel({
    this.d,
  });

  List<D>? d;

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.shopid,
    this.saddress,
    this.skm,
    this.slatitude,
    this.slongitude,
    this.pincode,
    this.mobileno,
    this.shopimg,
    this.opentime,
    this.closetime,
    this.shopName,
    this.delTime,
    this.isOpen,
    this.IsHoliday,
    this.Holidaymsg,
    this.wareHouseId,
    this.storeLocationId,
    this.deltype,
    this.Instorepickup,
  });

  Type? type;
  String? shopid;
  String? saddress;
  String? skm;
  String? slatitude;
  String? slongitude;
  String? pincode;
  String? mobileno;
  String? shopimg;
  String? opentime;
  String? closetime;
  String? shopName;
  String? delTime;
  String? isOpen;
  String? IsHoliday;
  String? Holidaymsg;
  String? wareHouseId;
  String? storeLocationId;
  String? deltype;
  String? Instorepickup;

  factory D.fromJson(Map<String, dynamic> json) => D(
      type: typeValues.map[json["__type"]],
      shopid: json["shopid"],
      saddress: json["saddress"],
      skm: json["skm"],
      slatitude: json["slatitude"],
      slongitude: json["slongitude"],
      pincode: json["pincode"],
      mobileno: json["mobileno"],
      shopimg: json["shopimg"],
      opentime: json["Opentime"],
      closetime: json["Closetime"],
      shopName: json["ShopName"],
      delTime: json["delTime"],
      isOpen: json["IsOpen"],
      IsHoliday: json["IsHoliday"],
      Holidaymsg: json["Holidaymsg"],
      wareHouseId: json["WareHouseId"],
      storeLocationId: json["StoreLocationId"],
      deltype: json["Deltype"],
      Instorepickup: json["Instorepickup"]);

  Map<String, dynamic> toJson() => {
        "__type": typeValues.reverse[type],
        "shopid": shopid,
        "saddress": saddress,
        "skm": skm,
        "slatitude": slatitude,
        "slongitude": slongitude,
        "pincode": pincode,
        "mobileno": mobileno,
        "shopimg": shopimgValues.reverse[shopimg],
        "Opentime": opentime,
        "Closetime": closetime,
        "ShopName": shopName,
        "delTime": delTime,
        "IsOpen": isOpen,
    "IsHoliday": IsHoliday,
    "Holidaymsg": Holidaymsg,
    "WareHouseId": wareHouseId,
        "StoreLocationId": storeLocationId,
        "Deltype": deltype,
        "Instorepickup": Instorepickup,
      };
}

enum Shopimg { THE_1_JPG, EMPTY, THE_1163_JPG }

final shopimgValues = EnumValues({
  "": Shopimg.EMPTY,
  "1163.jpg": Shopimg.THE_1163_JPG,
  "1.jpg": Shopimg.THE_1_JPG
});

enum Type { BO_ADMIN_BO_SHOPDETAILS }

final typeValues =
    EnumValues({"BOAdmin.BOShopdetails": Type.BO_ADMIN_BO_SHOPDETAILS});

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
