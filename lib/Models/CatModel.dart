// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    this.d,
  });

  List<D>? d;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.skutypeId,
    this.skutypeName,
    this.imgpath,
    this.updatedatetime,
  });

  String? type;
  String? skutypeId;
  String? skutypeName;
  String? imgpath;
  String? updatedatetime;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        skutypeId: json["SkutypeId"],
        skutypeName: json["SkutypeName"],
        imgpath: json["imgpath"],
        updatedatetime: json["Updatedatetime"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "SkutypeId": skutypeId,
        "SkutypeName": skutypeName,
        "imgpath": imgpath,
        "Updatedatetime": updatedatetime,
      };
}
