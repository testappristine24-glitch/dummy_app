// To parse this JSON data, do
//
//     final checkBoxsModel = checkBoxsModelFromJson(jsonString);

import 'dart:convert';

CheckBoxsModel checkBoxsModelFromJson(String str) => CheckBoxsModel.fromJson(json.decode(str));

String checkBoxsModelToJson(CheckBoxsModel data) => json.encode(data.toJson());

class CheckBoxsModel {
    List<E> d;

    CheckBoxsModel({
        required this.d,
    });

    factory CheckBoxsModel.fromJson(Map<String, dynamic> json) => CheckBoxsModel(
        d: List<E>.from(json["d"].map((x) => E.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
    };
}

class E {
    Type type;
    String qid;
    String question;
    String questiontype;

    E({
        required this.type,
        required this.qid,
        required this.question,
        required this.questiontype,
    });
    

    factory E.fromJson(Map<String, dynamic> json) => E(
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

final typeValues = EnumValues({
    "BOAdmin.BOfeedbackQuestion": Type.BO_ADMIN_B_OFEEDBACK_QUESTION
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
