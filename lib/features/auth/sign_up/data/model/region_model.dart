// To parse this JSON data, do
//
//     final regionModel = regionModelFromJson(jsonString);

import 'dart:convert';

List<RegionModel> regionModelFromJson(String str) => List<RegionModel>.from(json.decode(str).map((x) => RegionModel.fromJson(x)));

String regionModelToJson(List<RegionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  RegionModel copyWith({
    int? id,
    String? name,
    String? nameUzCyrillic,
    String? nameUzLatin,
    String? nameRussian,
    List<District>? districts,
  }) =>
      RegionModel(
        id: id ?? this.id,
        name: name ?? this.name,
        nameUzCyrillic: nameUzCyrillic ?? this.nameUzCyrillic,
        nameUzLatin: nameUzLatin ?? this.nameUzLatin,
        nameRussian: nameRussian ?? this.nameRussian,
        districts: districts ?? this.districts,
      );

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    id: json["id"],
    name: json["name"],
    nameUzCyrillic: json["nameUzCyrillic"],
    nameUzLatin: json["nameUzLatin"],
    nameRussian: json["nameRussian"],
    districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "nameUzCyrillic": nameUzCyrillic,
    "nameUzLatin": nameUzLatin,
    "nameRussian": nameRussian,
    "districts": List<dynamic>.from(districts.map((x) => x.toJson())),
  };
}

class District {
  final int districtId;
  final String name;
  final String nameUzCyrillic;
  final String nameUzLatin;
  final String nameRussian;
  final int regionId;

  District({
    required this.districtId,
    required this.name,
    required this.nameUzCyrillic,
    required this.nameUzLatin,
    required this.nameRussian,
    required this.regionId,
  });

  District copyWith({
    int? districtId,
    String? name,
    String? nameUzCyrillic,
    String? nameUzLatin,
    String? nameRussian,
    int? regionId,
  }) =>
      District(
        districtId: districtId ?? this.districtId,
        name: name ?? this.name,
        nameUzCyrillic: nameUzCyrillic ?? this.nameUzCyrillic,
        nameUzLatin: nameUzLatin ?? this.nameUzLatin,
        nameRussian: nameRussian ?? this.nameRussian,
        regionId: regionId ?? this.regionId,
      );

  factory District.fromJson(Map<String, dynamic> json) => District(
    districtId: json["districtId"],
    name: json["name"],
    nameUzCyrillic: json["nameUzCyrillic"],
    nameUzLatin: json["nameUzLatin"],
    nameRussian: json["nameRussian"],
    regionId: json["regionId"],
  );

  Map<String, dynamic> toJson() => {
    "districtId": districtId,
    "name": name,
    "nameUzCyrillic": nameUzCyrillic,
    "nameUzLatin": nameUzLatin,
    "nameRussian": nameRussian,
    "regionId": regionId,
  };
}
