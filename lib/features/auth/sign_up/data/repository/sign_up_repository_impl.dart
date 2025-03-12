import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/core/services/secure_storage.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/region_model.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/repository/sign_up_repository.dart';

import '../../../../../core/utils/dependencies_injection.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  @override
  Future<Either<Failure, List<RegionModel>>> getRegions() async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/auth/regions", isHeader: false);

    if (request.isSuccess) {
      List<RegionModel> list = [];

      for (var item in request.response) {
        list.add(RegionModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, List<WorkplaceModel>>> getWorkplace() async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/auth/workplaces", isHeader: false);

    if (request.isSuccess) {
      List<WorkplaceModel> list = [];

      for (var item in request.response) {
        list.add(WorkplaceModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> signUp(
      {required Map<String, dynamic> data}) async {
    debugPrint(data.toString());
    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/auth/signup-doctor", isHeader: false, body: data);

    if (request.isSuccess) {

      return Right(true);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> login() async {
    String number = await SecureStorage().read(key: 'number') ?? "";
    String password = await SecureStorage().read(key: 'password') ?? "";

    debugPrint("this for login  $number   $password");
    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/auth/login",
        body: {
          "number": number,
          "email": "",
          "isNumber": true,
          "password": password
        },
        isHeader: false);

    if (request.isSuccess) {
      await SecureStorage()
          .write(key: "accessToken", value: request.response["access_token"]);
      await SecureStorage()
          .write(key: "refreshToken", value: request.response["refresh_token"]);
      return Right(true);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> checkNumber({required String number}) async {
    final request = await sl<ApiClient>().getMethod(
        pathUrl: "/auth/is-number-exist?number=$number", isHeader: false);
    if (request.isSuccess) {
      bool isExist = request.response;
      return Right(isExist);
    } else {
      return Left(Failure(
          errorMsg: request.response.toString(),
          statusCode: request.code ?? 500));
    }
  }
}
