import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';
import 'package:wm_doctor/features/profile/data/model/out_contract_model.dart';
import 'package:wm_doctor/features/profile/data/model/profile_data_model.dart';
import 'package:wm_doctor/features/profile/data/model/statistics_model.dart';
import 'package:wm_doctor/features/profile/data/model/user_model.dart';
import 'package:wm_doctor/features/profile/domain/repository/profile_repository.dart';
import 'package:wm_doctor/features/regions/data/model/district_model.dart';

import '../../../../core/services/secure_storage.dart';
import '../../../../core/utils/dependencies_injection.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    print('00000-----------------------------------------1-------------------------------');

    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    print('00000-----------------------------------------1-------------------------------');
    final request =
        await sl<ApiClient>().getMethod(pathUrl: "/user/$uuid", isHeader: true);
    print('00000-----------------------------------------1-------------------------------');

    if (request.isSuccess) {
      return Right(UserModel.fromJson(request.response));
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
  Future<Either<Failure, ProfileDataModel>> getProfileData() async{
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    print('000000111111111111111110--------------------------------11100000');

    final request =
    await sl<ApiClient>().getMethod(pathUrl: "/doctor/contract/doctor-id/$uuid", isHeader: true);
    print('0000001111111111111111111100000');

    if (request.isSuccess) {
      return Right(ProfileDataModel.fromJson(request.response));
    }
    print('0000001111111111111111111100000');
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, DoctorStatsModel>> getStatistics() async{
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request =
    await sl<ApiClient>().getMethod(pathUrl: "/doctor/statistics/$uuid", isHeader: true);
    if (request.isSuccess) {
      return Right(DoctorStatsModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, OutContractModel>> getOutContract() async{
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request =
    await sl<ApiClient>().getMethod(pathUrl: "/doctor/out-contract/doctor-id/$uuid", isHeader: true);
    if (request.isSuccess) {
      // return Right(OutContractModel.fromJson(request.response));
      return Right(OutContractModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}
