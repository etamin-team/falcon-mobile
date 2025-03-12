// To parse this JSON data, do
//
//     final addContractModel = addContractModelFromJson(jsonString);

import 'dart:convert';

AddContractModel addContractModelFromJson(String str) =>
    AddContractModel.fromJson(json.decode(str));

String addContractModelToJson(AddContractModel data) =>
    json.encode(data.toJson());

class AddContractModel {
  String doctorId;
  String startDate;
  String endDate;
  String agentId;
  String contractType;
  int agentContractId;
  List<MedicinesWithQuantity> medicinesWithQuantities;

  AddContractModel({
    required this.doctorId,
    required this.startDate,
    required this.endDate,
    required this.agentId,
    required this.agentContractId,
    required this.medicinesWithQuantities,
    required this.contractType,
  });

  AddContractModel copyWith({
    String? doctorId,
    String? startDate,
    String? endDate,
    String? agentId,
    String? contractType,
    int? agentContractId,
    List<MedicinesWithQuantity>? medicinesWithQuantities,
  }) =>
      AddContractModel(
        doctorId: doctorId ?? this.doctorId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        agentId: agentId ?? this.agentId,
        contractType: contractType ?? this.contractType,
        agentContractId: agentContractId ?? this.agentContractId,
        medicinesWithQuantities:
            medicinesWithQuantities ?? this.medicinesWithQuantities,
      );

  factory AddContractModel.fromJson(Map<String, dynamic> json) =>
      AddContractModel(
        doctorId: json["doctorId"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        agentId: json["agentId"],
        contractType: json["contractType"],
        agentContractId: json["agentContractId"],
        medicinesWithQuantities: List<MedicinesWithQuantity>.from(
            json["medicinesWithQuantities"]
                .map((x) => MedicinesWithQuantity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "doctorId": doctorId,
        "startDate": startDate,
        "endDate": endDate,
        "agentId": agentId,
        "contractType": contractType,
        "agentContractId": agentContractId,
        "medicinesWithQuantities":
            List<dynamic>.from(medicinesWithQuantities.map((x) => x.toJson())),
      };
}

class MedicinesWithQuantity {
  final int medicineId;
  final int quote;

  MedicinesWithQuantity({
    required this.medicineId,
    required this.quote,
  });

  MedicinesWithQuantity copyWith({
    int? medicineId,
    int? quote,
  }) =>
      MedicinesWithQuantity(
        medicineId: medicineId ?? this.medicineId,
        quote: quote ?? this.quote,
      );

  factory MedicinesWithQuantity.fromJson(Map<String, dynamic> json) =>
      MedicinesWithQuantity(
        medicineId: json["medicineId"],
        quote: json["quote"],
      );

  Map<String, dynamic> toJson() => {
        "medicineId": medicineId,
        "quote": quote,
      };
}
