
import 'out_contract_model.dart';

class ProfileDataModel {
  int id;
  String doctorId;
  String createdAt;
  String startDate;
  String endDate;
  int? fieldId;
  int agentId;
  String contractType;
  // List<OutOfContractMedicineAmount> outOfContractMedicineAmount;
  List<ContractedMedicineWithQuantity> medicineWithQuantityDoctorDTOS;

  ProfileDataModel({
    required this.id,
    required this.doctorId,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    this.fieldId,
    required this.agentId,
    required this.contractType,
    // required this.outOfContractMedicineAmount,
    required this.medicineWithQuantityDoctorDTOS,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    print('wwwwww111---------------------------------------11111');
    return ProfileDataModel(
      id: json['id'] ?? 0,
      doctorId: json['doctorId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      contractType: json['contractType'] ?? '',
      fieldId: json['fieldId'],
      agentId: json['agentId'] ?? 0,
      // outOfContractMedicineAmount: (json['outOfContractMedicineAmount'] as List?)
      //     ?.map((e) => OutOfContractMedicineAmount.fromJson(e as Map<String, dynamic>))
      //     .toList() ??
      //     [],
      medicineWithQuantityDoctorDTOS: (json['medicineWithQuantityDoctorDTOS'] as List?)
          ?.map((e) => ContractedMedicineWithQuantity.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'createdAt': createdAt,
      'startDate': startDate,
      'endDate': endDate,
      'fieldId': fieldId,
      'agentId': agentId,
      'contractType': contractType,
      // 'outOfContractMedicineAmount': outOfContractMedicineAmount.map((e) => e.toJson()).toList(),
      'medicineWithQuantityDoctorDTOS':
      medicineWithQuantityDoctorDTOS.map((e) => e.toJson()).toList(),
    };
  }
}

class OutOfContractMedicineAmount {
  int id;
  double amount;
  Medicine medicine;

  OutOfContractMedicineAmount({
    required this.id,
    required this.amount,
    required this.medicine,
  });

  factory OutOfContractMedicineAmount.fromJson(Map<String, dynamic> json) {
    return OutOfContractMedicineAmount(
      id: json['id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      medicine: Medicine.fromJson(json['medicine'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'medicine': medicine.toJson(),
    };
  }
}

class ContractedMedicineWithQuantity {
  int quantityId;
  int medicineId;
  int quote;
  int correction;
  int agentContractId;
  ContractMedicineDoctorAmount contractMedicineDoctorAmount;
  Medicine medicine;

  ContractedMedicineWithQuantity({
    required this.quantityId,
    required this.medicineId,
    required this.quote,
    required this.correction,
    required this.agentContractId,
    required this.contractMedicineDoctorAmount,
    required this.medicine,
  });

  factory ContractedMedicineWithQuantity.fromJson(Map<String, dynamic> json) {
    return ContractedMedicineWithQuantity(
      quantityId: json['quantityId'] ?? 0,
      medicineId: json['medicineId'] ?? 0,
      quote: json['quote'] ?? 0,
      correction: json['correction'] ?? 0,
      agentContractId: json['agentContractId'] ?? 0,
      contractMedicineDoctorAmount: json['contractMedicineDoctorAmount'] != null
          ? ContractMedicineDoctorAmount.fromJson(json['contractMedicineDoctorAmount'])
          : ContractMedicineDoctorAmount(id: 0, amount: 0),
      medicine: Medicine.fromJson(json['medicine'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantityId': quantityId,
      'medicineId': medicineId,
      'quote': quote,
      'correction': correction,
      'agentContractId': agentContractId,
      'contractMedicineDoctorAmount': contractMedicineDoctorAmount.toJson(),
      'medicine': medicine.toJson(),
    };
  }
}

class ContractMedicineDoctorAmount {
  int id;
  int amount;

  ContractMedicineDoctorAmount({
    required this.id,
    required this.amount,
  });

  factory ContractMedicineDoctorAmount.fromJson(Map<String, dynamic> json) {
    return ContractMedicineDoctorAmount(
      id: json['id'] ?? 0,
      amount: (json['amount'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
    };
  }
}