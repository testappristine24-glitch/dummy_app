// To parse this JSON data, do
//
//     final checkBoxModel = checkBoxModelFromJson(jsonString);

import 'dart:convert';

CheckBoxModel checkBoxModelFromJson(String str) =>
    CheckBoxModel.fromJson(json.decode(str));

String checkBoxModelToJson(CheckBoxModel data) => json.encode(data.toJson());

class CheckBoxModel {
  List<C> d;

  CheckBoxModel({
    required this.d,
  });

  factory CheckBoxModel.fromJson(Map<String, dynamic> json) => CheckBoxModel(
        d: List<C>.from(json["d"].map((x) => C.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class C {
  Type type;
  String qid;
  String question;
  String questiontype;

  C({
    required this.type,
    required this.qid,
    required this.question,
    required this.questiontype,
  });

  factory C.fromJson(Map<String, dynamic> json) => C(
        type: typeValues.map[json["__type"]]!,
        qid: json["Qid"],
        question: json["Question"],
        questiontype: json["Questiontype"],
      );

  Map<String, dynamic> toJson() => {
        "__type": typeValues.reverse[type],
        "Qid": qid,
        "Question": question,
        "Questiontype": questiontype,
      };
}

enum Type { BO_ADMIN_B_OFEEDBACK_QUESTION }

final typeValues = EnumValues(
    {"BOAdmin.BOfeedbackQuestion": Type.BO_ADMIN_B_OFEEDBACK_QUESTION});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
