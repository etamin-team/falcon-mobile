import '../../../create_template/data/model/medicine_model.dart';
import '../../../profile/data/model/out_contract_model.dart';

class TemplateModel {
  int? id;
  String? name;
  String? diagnosis;
  List<TemplatePreparation>? preparations;
  String? note;
  String? doctorId;
  bool saved;

  TemplateModel({
    this.id,
    this.name,
    this.diagnosis,
    this.preparations,
    this.note,
    this.doctorId,
    required this.saved,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'],
      name: json['name'],
      diagnosis: json['diagnosis'],
      preparations: json['preparations'] != null
          ? List<TemplatePreparation>.from(json['preparations'].map((x) => TemplatePreparation.fromJson(x)))
          : null,
      note: json['note'],
      doctorId: json['doctorId'],
      saved: json['saved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'diagnosis': diagnosis,
      'preparations': preparations != null
          ? List<dynamic>.from(preparations!.map((x) => x.toJson()))
          : null,
      'note': note,
      'doctorId': doctorId,
      'saved': saved,
    };
  }
}

class TemplatePreparation {
  String? name;
  String? amount;
  int? quantity;
  int? timesInDay;
  int? days;
  String? type;
  int? medicineId;
  MedicineModel? medicine; // Changed from Medicine to MedicineModel

  TemplatePreparation({
    this.name,
    this.amount,
    this.quantity,
    this.timesInDay,
    this.days,
    this.type,
    this.medicineId,
    this.medicine,
  });

  factory TemplatePreparation.fromJson(Map<String, dynamic> json) {
    return TemplatePreparation(
      name: json['name'] ?? "",
      amount: json['amount'] ?? "",
      quantity: json['quantity'] ?? 0,
      timesInDay: json['timesInDay'] ?? 0,
      days: json['days'] ?? 0,
      type: json['type'] ?? "",
      medicineId: json['medicineId'] ?? 0,
      medicine: json['medicine'] != null
          ? MedicineModel.fromJson(json['medicine'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'quantity': quantity,
      'timesInDay': timesInDay,
      'days': days,
      'type': type,
      'medicineId': medicineId,
      'medicine': medicine?.toJson(),
    };
  }
}
