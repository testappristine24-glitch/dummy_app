// To parse this JSON data, do
//
//     final cookie = cookieFromJson(jsonString);

import 'dart:convert';

Cookie cookieFromJson(String str) => Cookie.fromJson(json.decode(str));

String cookieToJson(Cookie data) => json.encode(data.toJson());

class Cookie {
  Cookie({
    this.d,
  });

  D? d;

  factory Cookie.fromJson(Map<String, dynamic> json) => Cookie(
        d: D.fromJson(json["d"]),
      );

  Map<String, dynamic> toJson() => {
        "d": d!.toJson(),
      };
}

class D {
  D({
    this.type,
    this.cookieslist,
  });

  String? type;
  String? cookieslist;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        cookieslist: json["Cookieslist"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "Cookieslist": cookieslist,
      };
}
