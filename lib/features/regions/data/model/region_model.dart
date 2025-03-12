class District {
  final int? id;
  final String? name;
  final String? nameUzCyrillic;
  final String? nameUzLatin;
  final String? nameRussian;

  District({
    required this.id,
    required this.name,
    required this.nameUzCyrillic,
    required this.nameUzLatin,
    required this.nameRussian,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
      nameUzCyrillic: json['nameUzCyrillic'],
      nameUzLatin: json['nameUzLatin'],
      nameRussian: json['nameRussian'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameUzCyrillic': nameUzCyrillic,
      'nameUzLatin': nameUzLatin,
      'nameRussian': nameRussian,
    };
  }
}

class RegionModel {
  final int id;
  final String name;
  final String nameUzCyrillic;
  final String nameUzLatin;
  final String nameRussian;
  final List<District> districts;

  RegionModel({
    required this.id,
    required this.name,
    required this.nameUzCyrillic,
    required this.nameUzLatin,
    required this.nameRussian,
    required this.districts,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'],
      name: json['name'],
      nameUzCyrillic: json['nameUzCyrillic'],
      nameUzLatin: json['nameUzLatin'],
      nameRussian: json['nameRussian'],
      districts: (json['districts'] as List)
          .map((district) => District.fromJson(district))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameUzCyrillic': nameUzCyrillic,
      'nameUzLatin': nameUzLatin,
      'nameRussian': nameRussian,
      'districts': districts.map((district) => district.toJson()).toList(),
    };
  }
}
