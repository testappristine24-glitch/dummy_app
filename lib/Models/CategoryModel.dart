// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  List<D> d;

  CategoryModel({
    required this.d,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  String catid;
  String catName;
  String ?catimg;
  String catdatetime;
  String catStatus;
  String subcatid;
  String sectionid;

  D({
    required this.type,
    required this.catid,
    required this.catName,
     this.catimg,
    required this.catdatetime,
    required this.catStatus,
    required this.subcatid,
    required this.sectionid,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        catid: json["Catid"],
        catName: json["CatName"],
        catimg: json["Catimg"],
        catdatetime: json["Catdatetime"],
        catStatus: json["CatStatus"],
        subcatid: json["Subcatid"],
        sectionid: json["Sectionid"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "Catid": catid,
        "CatName": catName,
        "Catimg": catimg,
        "Catdatetime": catdatetime,
        "CatStatus": catStatus,
        "Subcatid": subcatid,
        "Sectionid": sectionid,
      };
}
