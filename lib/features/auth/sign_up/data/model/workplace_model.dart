class WorkplaceModel {
  final int id;
  final String name;

  WorkplaceModel({required this.id, required this.name});

  // fromJson: JSON ma'lumotlarini modelga aylantirish
  factory WorkplaceModel.fromJson(Map<String, dynamic> json) {
    return WorkplaceModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  // toJson: Modelni JSON formatiga aylantirish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
