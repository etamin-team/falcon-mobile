// To parse this JSON data, do
//
//     final outContractModel = outContractModelFromJson(jsonString);

import 'dart:convert';

OutContractModel outContractModelFromJson(String str) => OutContractModel.fromJson(json.decode(str));

String outContractModelToJson(OutContractModel data) => json.encode(data.toJson());

class OutContractModel {
  final String doctorId;
  final List<OutOfContractMedicineAmount> outOfContractMedicineAmount;

  OutContractModel({
    required this.doctorId,
    required this.outOfContractMedicineAmount,
  });

  OutContractModel copyWith({
    String? doctorId,
    List<OutOfContractMedicineAmount>? outOfContractMedicineAmount,
  }) =>
      OutContractModel(
        doctorId: doctorId ?? this.doctorId,
        outOfContractMedicineAmount: outOfContractMedicineAmount ?? this.outOfContractMedicineAmount,
      );

  factory OutContractModel.fromJson(Map<String, dynamic> json) => OutContractModel(
    doctorId: json["doctorId"],
    outOfContractMedicineAmount: List<OutOfContractMedicineAmount>.from(json["outOfContractMedicineAmount"].map((x) => OutOfContractMedicineAmount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "doctorId": doctorId,
    "outOfContractMedicineAmount": List<dynamic>.from(outOfContractMedicineAmount.map((x) => x.toJson())),
  };
}

class OutOfContractMedicineAmount {
  final int id;
  final int amount;
  final Medicine medicine;

  OutOfContractMedicineAmount({
    required this.id,
    required this.amount,
    required this.medicine,
  });

  OutOfContractMedicineAmount copyWith({
    int? id,
    int? amount,
    Medicine? medicine,
  }) =>
      OutOfContractMedicineAmount(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        medicine: medicine ?? this.medicine,
      );

  factory OutOfContractMedicineAmount.fromJson(Map<String, dynamic> json) => OutOfContractMedicineAmount(
    id: json["id"],
    amount: json["amount"],
    medicine: Medicine.fromJson(json["medicine"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "medicine": medicine.toJson(),
  };
}

class Medicine {
  int? id;
  String? name;
  String? nameUzCyrillic;
  String? nameUzLatin;
  String? nameRussian;
  String? imageUrl;
  List<String>? inn;


   int? cip;
   int? quantity;
   double? prescription;
   String? volume;
   String? type;
   double? suPercentage;
   double? suLimit;
   int? suBall;
   double? sbPercentage;
   double? sbLimit;
   int? sbBall;
   double? gzPercentage;
   double? gzLimit;
   int? gzBall;
   double? kbPercentage;
   double? kbLimit;
   int? kbBall;

  Medicine({
    this.id,
    this.name,
    this.nameUzCyrillic,
    this.nameUzLatin,
    this.nameRussian,
    this.imageUrl,
    this.inn,
    this.cip,
    this.quantity,
    this.prescription,
    this.volume,
    this.type,
    this.suPercentage,
    this.suLimit,
    this.suBall,
    this.sbPercentage,
    this.sbLimit,
    this.sbBall,
    this.gzPercentage,
    this.gzLimit,
    this.gzBall,
    this.kbPercentage,
    this.kbLimit,
    this.kbBall,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      nameUzCyrillic: json['nameUzCyrillic'],
      nameUzLatin: json['nameUzLatin'],
      nameRussian: json['nameRussian'],
      imageUrl: json['imageUrl'],
      inn: json['inn'] != null ? List<String>.from(json['inn']) : null,
      cip: json['cip'],
      quantity: json['quantity'],
      prescription: json['prescription'],
      volume: json['volume'],
      type: json['type'],
      suPercentage: json['suPercentage'],
      suLimit: json['suLimit'],
      suBall: json['suBall'],
      sbPercentage: json['sbPercentage'],
      sbLimit: json['sbLimit'],
      sbBall: json['sbBall'],
      gzPercentage: json['gzPercentage'],
      gzLimit: json['gzLimit'],
      gzBall: json['gzBall'],
      kbPercentage: json['kbPercentage'],
      kbLimit: json['kbLimit'],
      kbBall: json['kbBall'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameUzCyrillic': nameUzCyrillic,
      'nameUzLatin': nameUzLatin,
      'nameRussian': nameRussian,
      'imageUrl': imageUrl,
      'inn': inn,
      'cip': cip,
      'quantity': quantity,
      'prescription': prescription,
      'volume': volume,
      'type': type,
      'suPercentage': suPercentage,
      'suLimit': suLimit,
      'suBall': suBall,
      'sbPercentage': sbPercentage,
      'sbLimit': sbLimit,
      'sbBall': sbBall,
      'gzPercentage': gzPercentage,
      'gzLimit': gzLimit,
      'gzBall': gzBall,
      'kbPercentage': kbPercentage,
      'kbLimit': kbLimit,
      'kbBall': kbBall,
    };
  }
}
