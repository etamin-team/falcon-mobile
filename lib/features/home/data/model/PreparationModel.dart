class PreparationModel {
  String name;
  String amount;
  int quantity;
  int timesInDay;
  int days;
  String type;
  int medicineId;
  List<dynamic>?inn;

  PreparationModel({
    required this.name,
    required this.amount,
    required this.quantity,
    required this.timesInDay,
    required this.days,
    required this.type,
    required this.medicineId,
    this.inn
  });

  PreparationModel copyWith({
    String? name,
    String? amount,
    int? quantity,
    int? timesInDay,
    int? days,
    String? type,
    int? medicineId,
    List<dynamic>?inn
  }) =>
      PreparationModel(
        name: name ?? this.name,
        amount: amount ?? this.amount,
        quantity: quantity ?? this.quantity,
        timesInDay: timesInDay ?? this.timesInDay,
        days: days ?? this.days,
        type: type ?? this.type,
        medicineId: medicineId ?? this.medicineId,
        inn: inn ?? this.inn,
      );

  factory PreparationModel.fromJson(Map<String, dynamic> json) => PreparationModel(
    name: json["name"],
    amount: json["amount"],
    quantity: json["quantity"],
    timesInDay: json["timesInDay"],
    days: json["days"],
    type: json["type"],
    medicineId: json["medicineId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
    "quantity": quantity,
    "timesInDay": timesInDay,
    "days": days,
    "type": type,
    "medicineId": medicineId,
  };
}