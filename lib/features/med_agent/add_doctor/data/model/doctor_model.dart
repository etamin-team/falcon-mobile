class DoctorModel {
  final String firstName;
  final String lastName;
  final String middleName;
  final String email;
  final String role;
  final String password;
  final String phoneNumber;
  final String phonePrefix;
  final String number;
  final int workPlaceId;
  final String birthDate;
  final String gender;
  final String fieldName;
  final String position;
  final int? districtId;

  DoctorModel({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.role,
    required this.password,
    required this.phoneNumber,
    required this.phonePrefix,
    required this.number,
    required this.workPlaceId,
    required this.birthDate,
    required this.gender,
    required this.fieldName,
    required this.position,
    required this.districtId,
  });

  /// JSON obyektni `UserModel` obyektiga o‘tkazish
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      email: json['email'],
      role: json['role'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      phonePrefix: json['phonePrefix'],
      number: json['number'],
      workPlaceId: json['workPlaceId'],
      birthDate: json['birthDate'],
      gender: json['gender'],
      fieldName: json['fieldName'],
      position: json['position'],
      districtId: json['districtId'],
    );
  }

  /// `UserModel` obyektini JSON formatga o‘tkazish
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'email': email,
      'role': role,
      'password': password,
      'phoneNumber': phoneNumber,
      'phonePrefix': phonePrefix,
      'number': number,
      'workPlaceId': workPlaceId,
      'birthDate': birthDate,
      'gender': gender,
      'fieldName': fieldName,
      'position': position,
      'districtId': districtId,
    };
  }
}
