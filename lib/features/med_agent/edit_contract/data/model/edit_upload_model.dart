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
  final List<MedicinesWithQuantity> medicinesWithQuantities;


  EditUploadModel({
    required this.id,
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
        medicinesWithQuantities:
            medicinesWithQuantities ?? this.medicinesWithQuantities,

      );

  factory EditUploadModel.fromJson(Map<String, dynamic> json) =>
      EditUploadModel(
        id: json["id"],
        medicinesWithQuantities: List<MedicinesWithQuantity>.from(
            json["medicineWithQuantityDoctorDTOS"]
                .map((x) => MedicinesWithQuantity.fromJson(x))),

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medicineWithQuantityDoctorDTOS":
            List<dynamic>.from(medicinesWithQuantities.map((x) => x.toJson())),

      };
}

class MedicinesWithQuantity {
  final int medicineId;
  final int quote;
  final int agentContractId;
  final ContractMedicineAmountEdit contractMedicineDoctorAmount;


  MedicinesWithQuantity({
    required this.medicineId,
    required this.quote,
    required this.agentContractId,
    required this.contractMedicineDoctorAmount,

  });

  MedicinesWithQuantity copyWith({
    int? medicineId,
    int? quote,
    int? agentContractId,
    ContractMedicineAmountEdit? contractMedicineDoctorAmount,
    Medicine? medicine,
  }) =>
      MedicinesWithQuantity(
        medicineId: medicineId ?? this.medicineId,
        quote: quote ?? this.quote,
        agentContractId: agentContractId ?? this.agentContractId,
        contractMedicineDoctorAmount:
        contractMedicineDoctorAmount ?? this.contractMedicineDoctorAmount,

      );

  factory MedicinesWithQuantity.fromJson(Map<String, dynamic> json) =>
      MedicinesWithQuantity(
        medicineId: json["medicineId"],
        quote: json["quote"],
        agentContractId: json["agentContractId"],
        contractMedicineDoctorAmount:
            ContractMedicineAmountEdit.fromJson(json["contractMedicineDoctorAmount"]),

      );

  Map<String, dynamic> toJson() => {
        "medicineId": medicineId,
        "quote": quote,
        "agentContractId": agentContractId,
        "contractMedicineDoctorAmount": contractMedicineDoctorAmount.toJson(),

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

