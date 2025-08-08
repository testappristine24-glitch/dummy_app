// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

//import 'dart:convert';

// List<SearchModel> searchModelFromJson(String str) => List<SearchModel>.from(
//     json.decode(str).map((x) => SearchModel.fromJson(x)));

// String searchModelToJson(List<SearchModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchModel {
  SearchModel({
    this.id,
    this.name,
    this.type,
  });

  int? id;
  Name? name;
  String? type;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        id: json["id"],
        name: Name.fromJson(json["name"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name!.toJson(),
        "type": type,
      };
}

class Name {
  Name({
    this.en,
  });

  String? en;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        en: json["en"],
        //  ar: json["ar"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        //  "ar": ar,
      };
}
