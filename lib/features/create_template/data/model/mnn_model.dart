class MnnModel {
  final int? id;
  final String? name;

  MnnModel({
  this.id,
  this.name});

  factory MnnModel.fromJson(Map<String, dynamic> json) {
    return MnnModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

    }

  get prescription => null;
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }
}