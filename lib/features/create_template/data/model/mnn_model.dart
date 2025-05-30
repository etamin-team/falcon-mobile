class MnnModel {
  final int? id;
  final String? name;
  final String? latinName;
  final String? combination;
  final String? type;
  final String? dosage;
  final String? wm_ru;
  final String? pharmacothera;

  MnnModel({
  this.id,
  this.name,
  this.latinName,
  this.combination,
  this.type,
  this.dosage,
  this.wm_ru,
  this.pharmacothera
  });

  factory MnnModel.fromJson(Map<String, dynamic> json) {
    return MnnModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      latinName: json['latinName'] as String?, // Fix mapping
      combination: json['combination'] as String?,
      type: json['type'] as String?,
      dosage: json['dosage'] as String?,
      wm_ru: json['wm_ru'] as String?,
      pharmacothera: json['pharmacothera'] as String?,
    );
  }

  String? get prescription => dosage; // Example: Use dosage as prescription
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latinName': latinName,
      'combination': combination,
      'type': type,
      'dosage': dosage,
      'wm_ru': wm_ru,
    };
  }
}