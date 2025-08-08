// To parse this JSON data, do
//
//     final loadCouponsModel = loadCouponsModelFromJson(jsonString);

import 'dart:convert';

LoadCouponsModel loadCouponsModelFromJson(String str) =>
    LoadCouponsModel.fromJson(json.decode(str));

String loadCouponsModelToJson(LoadCouponsModel data) =>
    json.encode(data.toJson());

class LoadCouponsModel {
  List<D> d;

  LoadCouponsModel({
    required this.d,
  });

  factory LoadCouponsModel.fromJson(Map<String, dynamic> json) =>
      LoadCouponsModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  String rewardid;
  String coupons;
  String? mininvamt;
  String orderamt;
  String couponamt;
  String couponStatus;
  String expirydate;
  String imgpath;
  dynamic rewardtype;
  String? usedOrderid;
  String? mobileNo;

  D(
      {required this.type,
      required this.rewardid,
      required this.coupons,
      this.mininvamt,
      required this.orderamt,
      required this.couponamt,
      required this.couponStatus,
      required this.expirydate,
      required this.imgpath,
      required this.rewardtype,
      this.usedOrderid,
      this.mobileNo});

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        rewardid: json["rewardid"],
        coupons: json["coupons"],
        mininvamt: json["mininvamt"],
        orderamt: json["orderamt"],
        couponamt: json["couponamt"],
        couponStatus: json["CouponStatus"],
        expirydate: json["expirydate"],
        imgpath: json["imgpath"],
        rewardtype: json["Rewardtype"],
        usedOrderid: json["UsedOrderid"],
        mobileNo: json["MobileNo"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "rewardid": rewardid,
        "coupons": coupons,
        "mininvamt": mininvamt,
        "orderamt": orderamt,
        "couponamt": couponamt,
        "CouponStatus": couponStatus,
        "expirydate": expirydate,
        "imgpath": imgpath,
        "Rewardtype": rewardtype,
        "UsedOrderid": usedOrderid,
        "MobileNo": mobileNo,
      };
}
