import 'dart:convert';

import '../../../../profile/data/model/out_contract_model.dart';

List<ContractModel> contractModelFromJson(String str) => List<ContractModel>.from(json.decode(str).map((x) => ContractModel.fromJson(x)));

String contractModelToJson(List<ContractModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ContractModel {
  final int? id;
  final String? doctorId;
  final String? goalStatus;
  final DateTime? createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? agentId;
  final int? agentContractId;
  final String? managerId;
  final List<MedicineWithQuantityDoctorDTOS>? medicineWithQuantityDoctorDTOS;
  final RegionDistrictDto? regionDistrictDto;
  final User? user;

  ContractModel({
    this.id,
    this.doctorId,
    this.goalStatus,
    this.createdAt,
    this.startDate,
    this.endDate,
    this.agentId,
    this.agentContractId,
    this.managerId,
    this.medicineWithQuantityDoctorDTOS,
    this.regionDistrictDto,
    this.user,
  });

  ContractModel copyWith({
    int? id,
    String? doctorId,
    String? goalStatus,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    String? agentId,
    int? agentContractId,
    String? managerId,
    List<MedicineWithQuantityDoctorDTOS>? medicineWithQuantityDoctorDTOS,
    RegionDistrictDto? regionDistrictDto,
    User? user,
  }) =>
      ContractModel(
        id: id ?? this.id,
        doctorId: doctorId ?? this.doctorId,
        goalStatus: goalStatus ?? this.goalStatus,
        createdAt: createdAt ?? this.createdAt,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        agentId: agentId ?? this.agentId,
        agentContractId: agentContractId ?? this.agentContractId,
        managerId: managerId ?? this.managerId,
        medicineWithQuantityDoctorDTOS: medicineWithQuantityDoctorDTOS ?? this.medicineWithQuantityDoctorDTOS,
        regionDistrictDto: regionDistrictDto ?? this.regionDistrictDto,
        user: user ?? this.user,
      );

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
    id: json["id"],
    doctorId: json["doctorId"],
    goalStatus: json["goalStatus"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    agentId: json["agentId"],
    agentContractId: json["agentContractId"],
    managerId: json["managerId"],
    medicineWithQuantityDoctorDTOS: json["medicineWithQuantityDoctorDTOS"] == null ? null : List<MedicineWithQuantityDoctorDTOS>.from(json["medicineWithQuantityDoctorDTOS"].map((x) => MedicineWithQuantityDoctorDTOS.fromJson(x))),
    regionDistrictDto: json["regionDistrictDTO"] == null ? null : RegionDistrictDto.fromJson(json["regionDistrictDTO"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "doctorId": doctorId,
    "goalStatus": goalStatus,
    "createdAt": createdAt?.toIso8601String(),
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "agentId": agentId,
    "agentContractId": agentContractId,
    "managerId": managerId,
    "medicineWithQuantityDoctorDTOS": medicineWithQuantityDoctorDTOS == null ? null : List<dynamic>.from(medicineWithQuantityDoctorDTOS!.map((x) => x.toJson())),
    "regionDistrictDTO": regionDistrictDto?.toJson(),
    "user": user?.toJson(),
  };
}

class MedicineWithQuantityDoctorDTOS {
  final int? quantityId;
  final int? medicineId;
  final int? quote;
  final int? correction;
  final int? agentContractId;
  final ContractMedicineDoctorAmount? contractMedicineDoctorAmount;
  final Medicine? medicine;

  MedicineWithQuantityDoctorDTOS({
    this.quantityId,
    this.medicineId,
    this.quote,
    this.correction,
    this.agentContractId,
    this.contractMedicineDoctorAmount,
    this.medicine,
  });

  MedicineWithQuantityDoctorDTOS copyWith({
    int? quantityId,
    int? medicineId,
    int? quote,
    int? correction,
    int? agentContractId,
    ContractMedicineDoctorAmount? contractMedicineDoctorAmount,
    Medicine? medicine,
  }) =>
      MedicineWithQuantityDoctorDTOS(
        quantityId: quantityId ?? this.quantityId,
        medicineId: medicineId ?? this.medicineId,
        quote: quote ?? this.quote,
        correction: correction ?? this.correction,
        agentContractId: agentContractId ?? this.agentContractId,
        contractMedicineDoctorAmount: contractMedicineDoctorAmount ?? this.contractMedicineDoctorAmount,
        medicine: medicine ?? this.medicine,
      );

  factory MedicineWithQuantityDoctorDTOS.fromJson(Map<String, dynamic> json) => MedicineWithQuantityDoctorDTOS(
    quantityId: json["quantityId"],
    medicineId: json["medicineId"],
    quote: json["quote"],
    correction: json["correction"],
    agentContractId: json["agentContractId"],
    contractMedicineDoctorAmount: json["contractMedicineDoctorAmount"] == null ? null : ContractMedicineDoctorAmount.fromJson(json["contractMedicineDoctorAmount"]),
    medicine: json["medicine"] == null ? null : Medicine.fromJson(json["medicine"]),
  );

  Map<String, dynamic> toJson() => {
    "quantityId": quantityId,
    "medicineId": medicineId,
    "quote": quote,
    "correction": correction,
    "agentContractId": agentContractId,
    "contractMedicineDoctorAmount": contractMedicineDoctorAmount?.toJson(),
    "medicine": medicine?.toJson(),
  };
}

class ContractMedicineDoctorAmount {
  final int? id;
  final int? amount;

  ContractMedicineDoctorAmount({
    this.id,
    this.amount,
  });

  ContractMedicineDoctorAmount copyWith({
    int? id,
    int? amount,
  }) =>
      ContractMedicineDoctorAmount(
        id: id ?? this.id,
        amount: amount ?? this.amount,
      );

  factory ContractMedicineDoctorAmount.fromJson(Map<String, dynamic> json) => ContractMedicineDoctorAmount(
    id: json["id"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
  };
}

class RegionDistrictDto {
  final int? regionId;
  final String? regionName;
  final String? regionNameUzCyrillic;
  final String? regionNameUzLatin;
  final String? regionNameRussian;
  final int? districtId;
  final String? districtName;
  final String? districtNameUzCyrillic;
  final String? districtNameUzLatin;
  final String? districtNameRussian;

  RegionDistrictDto({
    this.regionId,
    this.regionName,
    this.regionNameUzCyrillic,
    this.regionNameUzLatin,
    this.regionNameRussian,
    this.districtId,
    this.districtName,
    this.districtNameUzCyrillic,
    this.districtNameUzLatin,
    this.districtNameRussian,
  });

  RegionDistrictDto copyWith({
    int? regionId,
    String? regionName,
    String? regionNameUzCyrillic,
    String? regionNameUzLatin,
    String? regionNameRussian,
    int? districtId,
    String? districtName,
    String? districtNameUzCyrillic,
    String? districtNameUzLatin,
    String? districtNameRussian,
  }) =>
      RegionDistrictDto(
        regionId: regionId ?? this.regionId,
        regionName: regionName ?? this.regionName,
        regionNameUzCyrillic: regionNameUzCyrillic ?? this.regionNameUzCyrillic,
        regionNameUzLatin: regionNameUzLatin ?? this.regionNameUzLatin,
        regionNameRussian: regionNameRussian ?? this.regionNameRussian,
        districtId: districtId ?? this.districtId,
        districtName: districtName ?? this.districtName,
        districtNameUzCyrillic: districtNameUzCyrillic ?? this.districtNameUzCyrillic,
        districtNameUzLatin: districtNameUzLatin ?? this.districtNameUzLatin,
        districtNameRussian: districtNameRussian ?? this.districtNameRussian,
      );

  factory RegionDistrictDto.fromJson(Map<String, dynamic> json) => RegionDistrictDto(
    regionId: json["regionId"],
    regionName: json["regionName"],
    regionNameUzCyrillic: json["regionNameUzCyrillic"],
    regionNameUzLatin: json["regionNameUzLatin"],
    regionNameRussian: json["regionNameRussian"],
    districtId: json["districtId"],
    districtName: json["districtName"],
    districtNameUzCyrillic: json["districtNameUzCyrillic"],
    districtNameUzLatin: json["districtNameUzLatin"],
    districtNameRussian: json["districtNameRussian"],
  );

  Map<String, dynamic> toJson() => {
    "regionId": regionId,
    "regionName": regionName,
    "regionNameUzCyrillic": regionNameUzCyrillic,
    "regionNameUzLatin": regionNameUzLatin,
    "regionNameRussian": regionNameRussian,
    "districtId": districtId,
    "districtName": districtName,
    "districtNameUzCyrillic": districtNameUzCyrillic,
    "districtNameUzLatin": districtNameUzLatin,
    "districtNameRussian": districtNameRussian,
  };
}

class User {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final DateTime? dateOfBirth;
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
  final RegionDistrictDto? regionDistrictDto;
  final WorkPlaceDto? workPlaceDto;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.middleName,
    this.dateOfBirth,
    this.phoneNumber,
    this.number,
    this.email,
    this.position,
    this.fieldName,
    this.gender,
    this.status,
    this.creatorId,
    this.workplaceId,
    this.districtId,
    this.role,
    this.regionDistrictDto,
    this.workPlaceDto,
  });

  User copyWith({
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
    int? workplaceId,
    int? districtId,
    String? role,
    RegionDistrictDto? regionDistrictDto,
    WorkPlaceDto? workPlaceDto,
  }) =>
      User(
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
        regionDistrictDto: regionDistrictDto ?? this.regionDistrictDto,
        workPlaceDto: workPlaceDto ?? this.workPlaceDto,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["userId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    middleName: json["middleName"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
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
    regionDistrictDto: json["regionDistrictDTO"] == null ? null : RegionDistrictDto.fromJson(json["regionDistrictDTO"]),
    workPlaceDto: json["workPlaceDTO"] == null ? null : WorkPlaceDto.fromJson(json["workPlaceDTO"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "middleName": middleName,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
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
    "regionDistrictDTO": regionDistrictDto?.toJson(),
    "workPlaceDTO": workPlaceDto?.toJson(),
  };
}

class WorkPlaceDto {
  final int? id;
  final String? name;
  final String? address;
  final dynamic description;
  final String? phone;
  final String? email;
  final String? medicalInstitutionType;
  final String? chiefDoctorId;
  final int? districtId;

  WorkPlaceDto({
    this.id,
    this.name,
    this.address,
    this.description,
    this.phone,
    this.email,
    this.medicalInstitutionType,
    this.chiefDoctorId,
    this.districtId,
  });

  WorkPlaceDto copyWith({
    int? id,
    String? name,
    String? address,
    dynamic description,
    String? phone,
    String? email,
    String? medicalInstitutionType,
    String? chiefDoctorId,
    int? districtId,
  }) =>
      WorkPlaceDto(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        description: description ?? this.description,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        medicalInstitutionType: medicalInstitutionType ?? this.medicalInstitutionType,
        chiefDoctorId: chiefDoctorId ?? this.chiefDoctorId,
        districtId: districtId ?? this.districtId,
      );

  factory WorkPlaceDto.fromJson(Map<String, dynamic> json) => WorkPlaceDto(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    description: json["description"],
    phone: json["phone"],
    email: json["email"],
    medicalInstitutionType: json["medicalInstitutionType"],
    chiefDoctorId: json["chiefDoctorId"],
    districtId: json["districtId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "description": description,
    "phone": phone,
    "email": email,
    "medicalInstitutionType": medicalInstitutionType,
    "chiefDoctorId": chiefDoctorId,
    "districtId": districtId,
  };
}