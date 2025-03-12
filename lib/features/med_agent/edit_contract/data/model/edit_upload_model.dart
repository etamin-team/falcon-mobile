// To parse this JSON data, do
//
//     final editUploadModel = editUploadModelFromJson(jsonString);

import 'dart:convert';

import '../../../../profile/data/model/out_contract_model.dart';

EditUploadModel editUploadModelFromJson(String str) =>
    EditUploadModel.fromJson(json.decode(str));

String editUploadModelToJson(EditUploadModel data) =>
    json.encode(data.toJson());

class EditUploadModel {
  final int id;
  final String doctorId;
  final String goalStatus;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final String agentId;
  final int agentContractId;
  final String managerId;
  final List<MedicinesWithQuantity> medicinesWithQuantities;


  EditUploadModel({
    required this.id,
    required this.doctorId,
    required this.goalStatus,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.agentId,
    required this.agentContractId,
    required this.managerId,
    required this.medicinesWithQuantities,

  });

  EditUploadModel copyWith({
    int? id,
    String? doctorId,
    String? goalStatus,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    String? agentId,
    int? agentContractId,
    String? managerId,
    List<MedicinesWithQuantity>? medicinesWithQuantities,

  }) =>
      EditUploadModel(
        id: id ?? this.id,
        doctorId: doctorId ?? this.doctorId,
        goalStatus: goalStatus ?? this.goalStatus,
        createdAt: createdAt ?? this.createdAt,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        agentId: agentId ?? this.agentId,
        agentContractId: agentContractId ?? this.agentContractId,
        managerId: managerId ?? this.managerId,
        medicinesWithQuantities:
            medicinesWithQuantities ?? this.medicinesWithQuantities,

      );

  factory EditUploadModel.fromJson(Map<String, dynamic> json) =>
      EditUploadModel(
        id: json["id"],
        doctorId: json["doctorId"],
        goalStatus: json["goalStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        agentId: json["agentId"],
        agentContractId: json["agentContractId"],
        managerId: json["managerId"],
        medicinesWithQuantities: List<MedicinesWithQuantity>.from(
            json["medicinesWithQuantities"]
                .map((x) => MedicinesWithQuantity.fromJson(x))),

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctorId": doctorId,
        "goalStatus": goalStatus,
        "createdAt":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "startDate":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "agentId": agentId,
        "agentContractId": agentContractId,
        "managerId": managerId,
        "medicinesWithQuantities":
            List<dynamic>.from(medicinesWithQuantities.map((x) => x.toJson())),

      };
}

class MedicinesWithQuantity {
  final int medicineId;
  final int quote;
  final int agentContractId;
  final ContractMedicineAmountEdit contractMedicineAmount;


  MedicinesWithQuantity({
    required this.medicineId,
    required this.quote,
    required this.agentContractId,
    required this.contractMedicineAmount,

  });

  MedicinesWithQuantity copyWith({
    int? medicineId,
    int? quote,
    int? agentContractId,
    ContractMedicineAmountEdit? contractMedicineAmount,
    Medicine? medicine,
  }) =>
      MedicinesWithQuantity(
        medicineId: medicineId ?? this.medicineId,
        quote: quote ?? this.quote,
        agentContractId: agentContractId ?? this.agentContractId,
        contractMedicineAmount:
            contractMedicineAmount ?? this.contractMedicineAmount,

      );

  factory MedicinesWithQuantity.fromJson(Map<String, dynamic> json) =>
      MedicinesWithQuantity(
        medicineId: json["medicineId"],
        quote: json["quote"],
        agentContractId: json["agentContractId"],
        contractMedicineAmount:
            ContractMedicineAmountEdit.fromJson(json["contractMedicineAmount"]),

      );

  Map<String, dynamic> toJson() => {
        "medicineId": medicineId,
        "quote": quote,
        "agentContractId": agentContractId,
        "contractMedicineAmount": contractMedicineAmount.toJson(),

      };
}

class ContractMedicineAmountEdit {
  final int id;
  final int amount;

  ContractMedicineAmountEdit({
    required this.id,
    required this.amount,
  });

  ContractMedicineAmountEdit copyWith({
    int? id,
    int? amount,
  }) =>
      ContractMedicineAmountEdit(
        id: id ?? this.id,
        amount: amount ?? this.amount,
      );

  factory ContractMedicineAmountEdit.fromJson(Map<String, dynamic> json) =>
      ContractMedicineAmountEdit(
        id: json["id"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
      };
}

