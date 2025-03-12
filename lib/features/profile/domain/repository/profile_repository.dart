import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';
import 'package:wm_doctor/features/profile/data/model/profile_data_model.dart';
import 'package:wm_doctor/features/profile/data/model/statistics_model.dart';
import 'package:wm_doctor/features/profile/data/model/user_model.dart';
import 'package:wm_doctor/features/regions/data/model/district_model.dart';

import '../../data/model/out_contract_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> getUserData();

  Future<Either<Failure, ProfileDataModel>> getProfileData();

  Future<Either<Failure, DistrictModel>> getDistrict({required int id});

  Future<Either<Failure, WorkplaceModel>> getWorkplace({required int id});

  Future<Either<Failure, DoctorStatsModel>> getStatistics();

  Future<Either<Failure, OutContractModel>> getOutContract();
}
