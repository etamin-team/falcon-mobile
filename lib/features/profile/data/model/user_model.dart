class UserModel {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String number;
  final String? email;
  final String? position;
  final String? fieldName;
  final String? gender;
  final String status;
  final String? creatorId;
  final int? workplaceId;
  final int? districtId;
  final String role;

  UserModel({
    required this.userId,
    this.firstName,
    this.lastName,
    this.middleName,
    this.dateOfBirth,
    this.phoneNumber,
    required this.number,
    this.email,
    this.position,
    this.fieldName,
    this.gender,
    required this.status,
    this.creatorId,
    this.workplaceId,
    this.districtId,
    required this.role,
  });

  // fromJson metodi
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String?,
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      dateOfBirth: json['dateOfBirth'],
      phoneNumber: json['phoneNumber'],
      number: json['number'] as String,
      email: json['email'],
      position: json['position'],
      fieldName: json['fieldName'],
      gender: json['gender'],
      status: json['status'] as String,
      creatorId: json['creatorId'] == "null" ? null : json['creatorId'],
      workplaceId: json['workplaceId'] as int?,
      districtId: json['districtId'],
      role: json['role'] as String,
    );
  }

  // toJson metodi
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'number': number,
      'email': email,
      'position': position,
      'fieldName': fieldName,
      'gender': gender,
      'status': status,
      'creatorId': creatorId ?? "null",
      'workplaceId': workplaceId,
      'districtId': districtId,
      'role': role,
    };
  }
}
