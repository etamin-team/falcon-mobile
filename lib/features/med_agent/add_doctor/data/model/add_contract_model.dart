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
  List<MedicineWithQuantityDoctorDTOS> medicineWithQuantityDoctorDTOS;

  AddContractModel({
    required this.doctorId,
    required this.startDate,
    required this.endDate,
    required this.agentId,
    required this.agentContractId,
    required this.medicineWithQuantityDoctorDTOS,
    required this.contractType,
  });

  AddContractModel copyWith({
    String? doctorId,
    String? startDate,
    String? endDate,
    String? agentId,
    String? contractType,
    int? agentContractId,
    List<MedicineWithQuantityDoctorDTOS>? medicineWithQuantityDoctorDTOS,
  }) =>
      AddContractModel(
        doctorId: doctorId ?? this.doctorId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        agentId: agentId ?? this.agentId,
        contractType: contractType ?? this.contractType,
        agentContractId: agentContractId ?? this.agentContractId,
        medicineWithQuantityDoctorDTOS:
        medicineWithQuantityDoctorDTOS ?? this.medicineWithQuantityDoctorDTOS,
      );

  factory AddContractModel.fromJson(Map<String, dynamic> json) =>
      AddContractModel(
        doctorId: json["doctorId"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        agentId: json["agentId"],
        contractType: json["contractType"],
        agentContractId: json["agentContractId"],
        medicineWithQuantityDoctorDTOS: List<MedicineWithQuantityDoctorDTOS>.from(
            json["medicineWithQuantityDoctorDTOS"]
                .map((x) => MedicineWithQuantityDoctorDTOS.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "doctorId": doctorId,
        "startDate": startDate,
        "endDate": endDate,
        "agentId": agentId,
        "contractType": contractType,
        "agentContractId": agentContractId,
        "medicineWithQuantityDoctorDTOS":
            List<dynamic>.from(medicineWithQuantityDoctorDTOS.map((x) => x.toJson())),
      };
}

class MedicineWithQuantityDoctorDTOS {
  final int medicineId;
  final int quote;

  MedicineWithQuantityDoctorDTOS({
    required this.medicineId,
    required this.quote,
  });

  MedicineWithQuantityDoctorDTOS copyWith({
    int? medicineId,
    int? quote,
  }) =>
      MedicineWithQuantityDoctorDTOS(
        medicineId: medicineId ?? this.medicineId,
        quote: quote ?? this.quote,
      );

  factory MedicineWithQuantityDoctorDTOS.fromJson(Map<String, dynamic> json) =>
      MedicineWithQuantityDoctorDTOS(
        medicineId: json["medicineId"],
        quote: json["quote"],
      );

  Map<String, dynamic> toJson() => {
        "medicineId": medicineId,
        "quote": quote,
      };
}
