
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/main/domain/repository/main_repository.dart';

import '../../../../core/services/secure_storage.dart';
import '../../../../core/utils/dependencies_injection.dart';

class MainRepositoryImpl implements MainRepository {
  @override
  Future<Either<Failure, String>> checkToken() async {
    final refreshToken = await SecureStorage().read(key: 'refreshToken') ?? "";
    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/auth/refresh-token",
        body: {},
        isHeader: true,
        header: {'Authorization': 'Bearer $refreshToken', 'Accept': '*/*'});
    if (request.isSuccess) {
      debugPrint("main token ============> ${request.response["access_token"]}");
      debugPrint("main token ============> ${request.response["refresh_token"]}");
      await SecureStorage().write(
          key: "accessToken",
          value: request.response["access_token"].toString());
      await SecureStorage().write(
          key: "refreshToken",
          value: request.response["refresh_token"].toString());
      return Right(request.response["access_token"].toString());
    }
    return Left(Failure(errorMsg: request.response.toString(), statusCode: request.code??500));
  }
}
