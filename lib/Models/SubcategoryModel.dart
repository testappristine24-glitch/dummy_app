/* class SubcategoryModel {
  String? subcatId;
  String? subcatImage;
  String? subcatTitle;
  String? catId;

  SubcategoryModel({
    this.subcatId,
    this.subcatImage,
    this.subcatTitle,
    this.catId,
  });
} */
// To parse this JSON data, do
//
//     final subcategoryModel = subcategoryModelFromJson(jsonString);

import 'dart:convert';

SubcategoryModel subcategoryModelFromJson(String str) =>
    SubcategoryModel.fromJson(json.decode(str));

String subcategoryModelToJson(SubcategoryModel data) =>
    json.encode(data.toJson());

class SubcategoryModel {
  SubcategoryModel({
    this.d,
  });

  List<D>? d;

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) =>
      SubcategoryModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.sectionid,
    this.sectionName,
    this.sectionimg,
    this.sdatetime,
  });

  String? type;
  String? sectionid;
  String? sectionName;
  String? sectionimg;
  String? sdatetime;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        sectionid: json["Sectionid"],
        sectionName: json["SectionName"],
        sectionimg: json["Sectionimg"],
        sdatetime: json["Sdatetime"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "Sectionid": sectionid,
        "SectionName": sectionName,
        "Sectionimg": sectionimg,
        "Sdatetime": sdatetime,
      };
}
