
import 'out_contract_model.dart';

class ProfileDataModel {
  int id;
  String doctorId;
  String createdAt;
  String startDate;
  String endDate;
  int? fieldId;
  int agentId;
  List<OutOfContractMedicineAmount> outOfContractMedicineAmount;
  List<ContractedMedicineWithQuantity> contractedMedicineWithQuantity;

  ProfileDataModel({
    required this.id,
    required this.doctorId,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    this.fieldId,
    required this.agentId,
    required this.outOfContractMedicineAmount,
    required this.contractedMedicineWithQuantity,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    print('wwwwww111---------------------------------------11111');
    return ProfileDataModel(
      id: json['id'] ?? 0,
      doctorId: json['doctorId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      fieldId: json['fieldId'],
      agentId: json['agentId'] ?? 0,
      outOfContractMedicineAmount: (json['outOfContractMedicineAmount'] as List?)
          ?.map((e) => OutOfContractMedicineAmount.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      contractedMedicineWithQuantity: (json['contractedMedicineWithQuantity'] as List?)
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
      'outOfContractMedicineAmount': outOfContractMedicineAmount.map((e) => e.toJson()).toList(),
      'contractedMedicineWithQuantity':
      contractedMedicineWithQuantity.map((e) => e.toJson()).toList(),
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
  int medicineId;
  int quote;
  int correction;
  int agentContractId;
  ContractMedicineAmount contractMedicineAmount;
  Medicine medicine;

  ContractedMedicineWithQuantity({
    required this.medicineId,
    required this.quote,
    required this.correction,
    required this.agentContractId,
    required this.contractMedicineAmount,
    required this.medicine,
  });

  factory ContractedMedicineWithQuantity.fromJson(Map<String, dynamic> json) {
    return ContractedMedicineWithQuantity(
      medicineId: json['medicineId'] ?? 0,
      quote: json['quote'] ?? 0,
      correction: json['correction'] ?? 0,
      agentContractId: json['agentContractId'] ?? 0,
      contractMedicineAmount: json['contractMedicineAmount'] != null
          ? ContractMedicineAmount.fromJson(json['contractMedicineAmount'])
          : ContractMedicineAmount(id: 0, amount: 0),
      medicine: Medicine.fromJson(json['medicine'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'quote': quote,
      'correction': correction,
      'agentContractId': agentContractId,
      'contractMedicineAmount': contractMedicineAmount.toJson(),
      'medicine': medicine.toJson(),
    };
  }
}

class ContractMedicineAmount {
  int id;
  int amount;

  ContractMedicineAmount({
    required this.id,
    required this.amount,
  });

  factory ContractMedicineAmount.fromJson(Map<String, dynamic> json) {
    return ContractMedicineAmount(
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
