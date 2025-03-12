import 'dart:convert';

import '../../../../profile/data/model/out_contract_model.dart';

AgentGoalModel? agentGoalModelFromJson(String str) => str.isNotEmpty ? AgentGoalModel.fromJson(json.decode(str)) : null;

String agentGoalModelToJson(AgentGoalModel? data) => json.encode(data?.toJson());

class AgentGoalModel {
  final int? id;
  final DateTime? createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? medAgentId;
  final List<MedicineWithQuantityDto>? medicineWithQuantityDtos;
  final List<FieldWithQuantityDto>? fieldWithQuantityDtos;
  final int? managerGoalId;
  final String? managerId;
  final int? districtId;

  AgentGoalModel({
    this.id,
    this.createdAt,
    this.startDate,
    this.endDate,
    this.medAgentId,
    this.medicineWithQuantityDtos,
    this.fieldWithQuantityDtos,
    this.managerGoalId,
    this.managerId,
    this.districtId,
  });

  factory AgentGoalModel.fromJson(Map<String, dynamic> json) => AgentGoalModel(
    id: json["id"],
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    startDate: json["startDate"] != null ? DateTime.parse(json["startDate"]) : null,
    endDate: json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
    medAgentId: json["medAgentId"],
    medicineWithQuantityDtos: json["medicineWithQuantityDTOS"] != null
        ? List<MedicineWithQuantityDto>.from(
        json["medicineWithQuantityDTOS"].map((x) => MedicineWithQuantityDto.fromJson(x)))
        : null,
    fieldWithQuantityDtos: json["fieldWithQuantityDTOS"] != null
        ? List<FieldWithQuantityDto>.from(
        json["fieldWithQuantityDTOS"].map((x) => FieldWithQuantityDto.fromJson(x)))
        : null,
    managerGoalId: json["managerGoalId"],
    managerId: json["managerId"],
    districtId: json["districtId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt?.toIso8601String(),
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "medAgentId": medAgentId,
    "medicineWithQuantityDTOS": medicineWithQuantityDtos?.map((x) => x.toJson()).toList(),
    "fieldWithQuantityDTOS": fieldWithQuantityDtos?.map((x) => x.toJson()).toList(),
    "managerGoalId": managerGoalId,
    "managerId": managerId,
    "districtId": districtId,
  };
}

class FieldWithQuantityDto {
  final int? id;
  final String? fieldName;
  final int? quote;
  final ContractAmount? contractFieldAmount;

  FieldWithQuantityDto({
    this.id,
    this.fieldName,
    this.quote,
    this.contractFieldAmount,
  });

  factory FieldWithQuantityDto.fromJson(Map<String, dynamic> json) => FieldWithQuantityDto(
    id: json["id"],
    fieldName: json["fieldName"],
    quote: json["quote"],
    contractFieldAmount:
    json["contractFieldAmount"] != null ? ContractAmount.fromJson(json["contractFieldAmount"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fieldName": fieldName,
    "quote": quote,
    "contractFieldAmount": contractFieldAmount?.toJson(),
  };
}

class ContractAmount {
  final int? id;
  final int? amount;

  ContractAmount({
    this.id,
    this.amount,
  });

  factory ContractAmount.fromJson(Map<String, dynamic> json) => ContractAmount(
    id: json["id"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
  };
}

class MedicineWithQuantityDto {
  final int? medicineId;
  final int? quote;
  final int? agentContractId;
  final ContractAmount? contractMedicineAmount;
  final Medicine? medicine;

  MedicineWithQuantityDto({
    this.medicineId,
    this.quote,
    this.agentContractId,
    this.contractMedicineAmount,
    this.medicine,
  });

  factory MedicineWithQuantityDto.fromJson(Map<String, dynamic> json) => MedicineWithQuantityDto(
    medicineId: json["medicineId"],
    quote: json["quote"],
    agentContractId: json["agentContractId"],
    contractMedicineAmount:
    json["contractMedicineAmount"] != null ? ContractAmount.fromJson(json["contractMedicineAmount"]) : null,
    medicine: json["medicine"] != null ? Medicine.fromJson(json["medicine"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "medicineId": medicineId,
    "quote": quote,
    "agentContractId": agentContractId,
    "contractMedicineAmount": contractMedicineAmount?.toJson(),
    "medicine": medicine?.toJson(),
  };
}


