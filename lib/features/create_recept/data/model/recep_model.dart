// To parse this JSON data, do
//
//     final recepModel = recepModelFromJson(jsonString);

import 'dart:convert';


import '../../../create_template/data/model/upload_template_model.dart';

RecepModel recepModelFromJson(String str) => RecepModel.fromJson(json.decode(str));

String recepModelToJson(RecepModel data) => json.encode(data.toJson());

class RecepModel {
  final String doctorId;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final String phoneNumberPrefix;
  final DateTime dateCreation;
  final String diagnosis;
  final String comment;
  final int telegramId;
  final int districtId;
  final List<Preparation> preparations;

  RecepModel({
    required this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.phoneNumberPrefix,
    required this.dateCreation,
    required this.diagnosis,
    required this.comment,
    required this.telegramId,
    required this.districtId,
    required this.preparations,
  });

  RecepModel copyWith({
    String? doctorId,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? phoneNumberPrefix,
    DateTime? dateCreation,
    String? diagnosis,
    String? comment,
    int? telegramId,
    int? districtId,
    List<Preparation>? preparations,
  }) =>
      RecepModel(
        doctorId: doctorId ?? this.doctorId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        phoneNumberPrefix: phoneNumberPrefix ?? this.phoneNumberPrefix,
        dateCreation: dateCreation ?? this.dateCreation,
        diagnosis: diagnosis ?? this.diagnosis,
        comment: comment ?? this.comment,
        telegramId: telegramId ?? this.telegramId,
        districtId: districtId ?? this.districtId,
        preparations: preparations ?? this.preparations,
      );

  factory RecepModel.fromJson(Map<String, dynamic> json) => RecepModel(
    doctorId: json["doctorId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    phoneNumber: json["phoneNumber"],
    phoneNumberPrefix: json["phoneNumberPrefix"],
    dateCreation: DateTime.parse(json["dateCreation"]),
    diagnosis: json["diagnosis"],
    comment: json["comment"],
    telegramId: json["telegramId"],
    districtId: json["districtId"],
    preparations: List<Preparation>.from(json["preparations"].map((x) => PreparationRecep.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "doctorId": doctorId,
    "firstName": firstName,
    "lastName": lastName,
    "dateOfBirth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "phoneNumber": phoneNumber,
    "phoneNumberPrefix": phoneNumberPrefix,
    "diagnosis": diagnosis,
    "comment": comment,
    "districtId": districtId,
    "preparations": List<dynamic>.from(preparations.map((x) => x.toJson())),
  };


}

class PreparationRecep {
   String name;
   String amount;
   int quantity;
   int timesInDay;
   int days;
   String type;
   int medicineId;

  PreparationRecep({
    required this.name,
    required this.amount,
    required this.quantity,
    required this.timesInDay,
    required this.days,
    required this.type,
    required this.medicineId,
  });

  PreparationRecep copyWith({
    String? name,
    String? amount,
    int? quantity,
    int? timesInDay,
    int? days,
    String? type,
    int? medicineId,
  }) =>
      PreparationRecep(
        name: name ?? this.name,
        amount: amount ?? this.amount,
        quantity: quantity ?? this.quantity,
        timesInDay: timesInDay ?? this.timesInDay,
        days: days ?? this.days,
        type: type ?? this.type,
        medicineId: medicineId ?? this.medicineId,
      );

  factory PreparationRecep.fromJson(Map<String, dynamic> json) => PreparationRecep(
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
