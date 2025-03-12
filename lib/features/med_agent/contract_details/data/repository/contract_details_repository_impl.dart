import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';
import 'package:wm_doctor/features/med_agent/contract_details/domain/repository/contract_details_repository.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/doctors_model.dart';
import 'package:wm_doctor/features/profile/data/model/out_contract_model.dart';
import 'package:wm_doctor/features/profile/data/model/profile_data_model.dart';
import 'package:wm_doctor/features/profile/data/model/statistics_model.dart';

import '../../../../../core/utils/dependencies_injection.dart';
import '../../../../regions/data/model/district_model.dart';

class ContractDetailsRepositoryImpl implements ContractDetailsRepository {
  @override
  Future<Either<Failure, DoctorsModel>> getDoctors({required String id}) async {
    final request =
        await sl<ApiClient>().getMethod(pathUrl: "/user/$id", isHeader: true);
    if (request.isSuccess) {
      return Right(DoctorsModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, OutContractModel>> getOutContract(
      {required String id}) async {
    final request = await sl<ApiClient>().getMethod(
        pathUrl: "/doctor/out-contract/doctor-id/$id", isHeader: true);
    if (request.isSuccess) {
      // return Right(OutContractModel.fromJson(request.response));
      return Right(OutContractModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, ProfileDataModel>> getProfileData(
      {required String id}) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/med-agent/doctor/contract/doctor-id/$id", isHeader: true);
    if (request.isSuccess) {
      return Right(ProfileDataModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, DoctorStatsModel>> getStatistics(
      {required String id}) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/doctor/statistics/$id", isHeader: true);
    if (request.isSuccess) {
      return Right(DoctorStatsModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, WorkplaceModel>> getWorkplace(
      {required int id}) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/auth/workplaces", isHeader: false);
    if (request.isSuccess) {
      for (var item in request.response) {
        WorkplaceModel model = WorkplaceModel.fromJson(item);
        if (model.id == id) {
          return Right(model);
          break;
        }
      }
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
  @override
  Future<Either<Failure, DistrictModel>> getDistrict({required int id}) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/auth/district?districtId=$id", isHeader: false);
    if (request.isSuccess) {
      return Right(DistrictModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

}
