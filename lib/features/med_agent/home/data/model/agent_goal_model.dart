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
  final List<MedicineAgentGoalQuantityDTO>? medicineAgentGoalQuantityDTOS;
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
    this.medicineAgentGoalQuantityDTOS,
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
    medicineAgentGoalQuantityDTOS: json["medicineAgentGoalQuantityDTOS"] != null
        ? List<MedicineAgentGoalQuantityDTO>.from(
        json["medicineAgentGoalQuantityDTOS"].map((x) => MedicineAgentGoalQuantityDTO.fromJson(x)))
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
    "medicineAgentGoalQuantityDTOS": medicineAgentGoalQuantityDTOS?.map((x) => x.toJson()).toList(),
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

class ContractMedicineMedAgentAmount {
  final int? id;
  final int? amount;

  ContractMedicineMedAgentAmount({
    this.id,
    this.amount,
  });

  factory ContractMedicineMedAgentAmount.fromJson(Map<String, dynamic> json) => ContractMedicineMedAgentAmount(
    id: json["id"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
  };
}

class MedicineAgentGoalQuantityDTO {
  final int? medicineId;
  final int? quote;
  final int? agentContractId;
  final ContractMedicineMedAgentAmount? contractMedicineMedAgentAmount;
  final Medicine? medicine;

  MedicineAgentGoalQuantityDTO({
    this.medicineId,
    this.quote,
    this.agentContractId,
    this.contractMedicineMedAgentAmount,
    this.medicine,
  });

  factory MedicineAgentGoalQuantityDTO.fromJson(Map<String, dynamic> json) => MedicineAgentGoalQuantityDTO(
    medicineId: json["medicineId"],
    quote: json["quote"],
    agentContractId: json["agentContractId"],
    contractMedicineMedAgentAmount:
    json["contractMedicineMedAgentAmount"] != null ? ContractMedicineMedAgentAmount.fromJson(json["contractMedicineMedAgentAmount"]) : null,
    medicine: json["medicine"] != null ? Medicine.fromJson(json["medicine"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "medicineId": medicineId,
    "quote": quote,
    "agentContractId": agentContractId,
    "contractMedicineMedAgentAmount": contractMedicineMedAgentAmount?.toJson(),
    "medicine": medicine?.toJson(),
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

