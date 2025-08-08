// To parse this JSON data, do
//
//     final timeslotModel = timeslotModelFromJson(jsonString);

import 'dart:convert';

TimeslotModel timeslotModelFromJson(String str) =>
    TimeslotModel.fromJson(json.decode(str));

String timeslotModelToJson(TimeslotModel data) => json.encode(data.toJson());

class TimeslotModel {
  TimeslotModel({
    this.d,
  });

  List<D>? d;

  factory TimeslotModel.fromJson(Map<String, dynamic> json) => TimeslotModel(
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
    this.slotid,
    this.slotname,
    this.slotstatus,
    this.stotstarttime,
    this.slotendtime,
    this.opentime,
    this.closetime,
  });

  String? type;
  String? shopid;
  String? slotid;
  String? slotname;
  String? slotstatus;
  String? stotstarttime;
  String? slotendtime;
  String? opentime;
  String? closetime;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        shopid: json["shopid"],
        slotid: json["slotid"],
        slotname: json["slotname"],
        slotstatus: json["slotstatus"],
        stotstarttime: json["stotstarttime"],
        slotendtime: json["slotendtime"],
        opentime: json["Opentime"],
        closetime: json["Closetime"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "shopid": shopid,
        "slotid": slotid,
        "slotname": slotname,
        "slotstatus": slotstatus,
        "stotstarttime": stotstarttime,
        "slotendtime": slotendtime,
        "Opentime": opentime,
        "Closetime": closetime,
      };
}
