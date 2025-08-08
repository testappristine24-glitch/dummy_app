// To parse this JSON data, do
//
//     final flashImg = flashImgFromJson(jsonString);

import 'dart:convert';

FlashImg flashImgFromJson(String str) => FlashImg.fromJson(json.decode(str));

String flashImgToJson(FlashImg data) => json.encode(data.toJson());

class FlashImg {
  FlashImg({
    this.d,
  });

  List<D>? d;

  factory FlashImg.fromJson(Map<String, dynamic> json) => FlashImg(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.bannreid,
    this.catName,
    this.bannerimg,
    this.bannerlink,
    this.bannersrno,
    this.bannerdatetime,
  });

  String? type;
  String? bannreid;
  dynamic catName;
  String? bannerimg;
  String? bannerlink;
  String? bannersrno;
  String? bannerdatetime;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        bannreid: json["Bannreid"],
        catName: json["CatName"],
        bannerimg: json["bannerimg"],
        bannerlink: json["bannerlink"],
        bannersrno: json["bannersrno"],
        bannerdatetime: json["bannerdatetime"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "Bannreid": bannreid,
        "CatName": catName,
        "bannerimg": bannerimg,
        "bannerlink": bannerlink,
        "bannersrno": bannersrno,
        "bannerdatetime": bannerdatetime,
      };
}
