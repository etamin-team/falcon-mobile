// To parse this JSON data, do
//
//     final doctorsModel = doctorsModelFromJson(jsonString);

import 'dart:convert';

DoctorsModel doctorsModelFromJson(String str) => DoctorsModel.fromJson(json.decode(str));

String doctorsModelToJson(DoctorsModel data) => json.encode(data.toJson());

class DoctorsModel {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final DateTime dateOfBirth;
  final String? phoneNumber;
  final String? number;
  final String? email;
  final String? position;
  final String? fieldName;
  final String? gender;
  final String? status;
  final String? creatorId;
  final int? workplaceId;
  final int? districtId;
  final String? role;

  DoctorsModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.number,
    required this.email,
    required this.position,
    required this.fieldName,
    required this.gender,
    required this.status,
    required this.creatorId,
    required this.workplaceId,
    required this.districtId,
    required this.role,
  });

  DoctorsModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? number,
    String? email,
    String? position,
    String? fieldName,
    String? gender,
    String? status,
    String? creatorId,
    dynamic workplaceId,
    int? districtId,
    String? role,
  }) =>
      DoctorsModel(
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        number: number ?? this.number,
        email: email ?? this.email,
        position: position ?? this.position,
        fieldName: fieldName ?? this.fieldName,
        gender: gender ?? this.gender,
        status: status ?? this.status,
        creatorId: creatorId ?? this.creatorId,
        workplaceId: workplaceId ?? this.workplaceId,
        districtId: districtId ?? this.districtId,
        role: role ?? this.role,
      );

  factory DoctorsModel.fromJson(Map<String, dynamic> json) => DoctorsModel(
    userId: json["userId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    middleName: json["middleName"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    phoneNumber: json["phoneNumber"],
    number: json["number"],
    email: json["email"],
    position: json["position"],
    fieldName: json["fieldName"],
    gender: json["gender"],
    status: json["status"],
    creatorId: json["creatorId"],
    workplaceId: json["workplaceId"],
    districtId: json["districtId"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "middleName": middleName,
    "dateOfBirth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "phoneNumber": phoneNumber,
    "number": number,
    "email": email,
    "position": position,
    "fieldName": fieldName,
    "gender": gender,
    "status": status,
    "creatorId": creatorId,
    "workplaceId": workplaceId,
    "districtId": districtId,
    "role": role,
  };
}
