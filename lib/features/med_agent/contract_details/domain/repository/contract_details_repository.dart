import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/doctors_model.dart';

import '../../../../auth/sign_up/data/model/workplace_model.dart';
import '../../../../profile/data/model/out_contract_model.dart';
import '../../../../profile/data/model/profile_data_model.dart';
import '../../../../profile/data/model/statistics_model.dart';
import '../../../../regions/data/model/district_model.dart';

abstract class ContractDetailsRepository {
  Future<Either<Failure, DoctorsModel>> getDoctors({required String id});

  Future<Either<Failure, ProfileDataModel>> getProfileData(
      {required String id});

  Future<Either<Failure, WorkplaceModel>> getWorkplace({required int id});

  Future<Either<Failure, DoctorStatsModel>> getStatistics({required String id});

  Future<Either<Failure, OutContractModel>> getOutContract(
      {required String id});
  Future<Either<Failure, DistrictModel>> getDistrict({required int id});
}
