// To parse this JSON data, do
//
//     final districtModel = districtModelFromJson(jsonString);

import 'dart:convert';

DistrictModel districtModelFromJson(String str) => DistrictModel.fromJson(json.decode(str));

String districtModelToJson(DistrictModel data) => json.encode(data.toJson());

class DistrictModel {
  final int districtId;
  final String name;
  final String nameUzCyrillic;
  final String nameUzLatin;
  final String nameRussian;
  final int regionId;

  DistrictModel({
    required this.districtId,
    required this.name,
    required this.nameUzCyrillic,
    required this.nameUzLatin,
    required this.nameRussian,
    required this.regionId,
  });

  DistrictModel copyWith({
    int? districtId,
    String? name,
    String? nameUzCyrillic,
    String? nameUzLatin,
    String? nameRussian,
    int? regionId,
  }) =>
      DistrictModel(
        districtId: districtId ?? this.districtId,
        name: name ?? this.name,
        nameUzCyrillic: nameUzCyrillic ?? this.nameUzCyrillic,
        nameUzLatin: nameUzLatin ?? this.nameUzLatin,
        nameRussian: nameRussian ?? this.nameRussian,
        regionId: regionId ?? this.regionId,
      );

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
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
