// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.d,
  });

  List<D>? d;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.emailId,
    this.memberName,
    this.membershipNo,
    this.walletamt,
    this.memberMobileNo,
  });

  String? type;
  String? emailId;
  String? memberName;
  String? membershipNo;
  String? walletamt;
  String? memberMobileNo;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        emailId: json["EmailId"],
        memberName: json["MemberName"],
        membershipNo: json["membershipNo"],
        walletamt: json["Walletamt"],
        memberMobileNo: json["MemberMobileNo"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "EmailId": emailId,
        "MemberName": memberName,
        "membershipNo": membershipNo,
        "Walletamt": walletamt,
        "MemberMobileNo": memberMobileNo,
      };
}
