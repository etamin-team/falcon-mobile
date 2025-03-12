// To parse this JSON data, do
//
//     final uploadTemplateModel = uploadTemplateModelFromJson(jsonString);

import 'dart:convert';

UploadTemplateModel uploadTemplateModelFromJson(String str) =>
    UploadTemplateModel.fromJson(json.decode(str));

String uploadTemplateModelToJson(UploadTemplateModel data) =>
    json.encode(data.toJson());

class UploadTemplateModel {
  final String name;
  final String diagnosis;
  final List<Preparation> preparations;
  final String note;
  final String doctorId;
  final bool saved;

  UploadTemplateModel({
    required this.name,
    required this.diagnosis,
    required this.preparations,
    required this.note,
    required this.doctorId,
    required this.saved,
  });

  UploadTemplateModel copyWith({
    String? name,
    String? diagnosis,
    List<Preparation>? preparations,
    String? note,
    String? doctorId,
    bool? saved,
  }) =>
      UploadTemplateModel(
        name: name ?? this.name,
        diagnosis: diagnosis ?? this.diagnosis,
        preparations: preparations ?? this.preparations,
        note: note ?? this.note,
        doctorId: doctorId ?? this.doctorId,
        saved: saved ?? this.saved,
      );

  factory UploadTemplateModel.fromJson(Map<String, dynamic> json) =>
      UploadTemplateModel(
        name: json["name"],
        diagnosis: json["diagnosis"],
        preparations: List<Preparation>.from(
            json["preparations"].map((x) => Preparation.fromJson(x))),
        note: json["note"],
        doctorId: json["doctorId"],
        saved: json["saved"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "diagnosis": diagnosis,
        "preparations": List<dynamic>.from(preparations.map((x) => x.toJson())),
        "note": note,
        "doctorId": doctorId,
        "saved": saved,
      };
}

class Preparation {
  String name;
  String amount;
  int quantity;
  int timesInDay;
  int days;
  String type;
  int medicineId;
  List<dynamic>? inn;

  Preparation({
    required this.name,
    required this.amount,
    required this.quantity,
    required this.timesInDay,
    required this.days,
    required this.type,
    required this.medicineId,
    this.inn,
  });

  Preparation copyWith(
          {String? name,
          String? amount,
          int? quantity,
          int? timesInDay,
          int? days,
          String? type,
          int? medicineId,
          List<dynamic>? inn}) =>
      Preparation(
        name: name ?? this.name,
        amount: amount ?? this.amount,
        quantity: quantity ?? this.quantity,
        timesInDay: timesInDay ?? this.timesInDay,
        days: days ?? this.days,
        type: type ?? this.type,
        medicineId: medicineId ?? this.medicineId,
        inn: inn ?? this.inn,
      );

  factory Preparation.fromJson(Map<String, dynamic> json) => Preparation(
        name: json["name"],
        amount: json["amount"],
        quantity: json["quantity"],
        timesInDay: json["timesInDay"],
        days: json["days"],
        type: json["type"],
        medicineId: json["medicineId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
        "quantity": quantity,
        "timesInDay": timesInDay,
        "days": days,
        "type": type,
        "medicineId": medicineId,
      };
}
