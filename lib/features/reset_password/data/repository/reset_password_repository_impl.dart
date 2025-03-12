import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/reset_password/domain/repository/reset_password_repository.dart';

import '../../../../core/services/secure_storage.dart';
import '../../../../core/utils/dependencies_injection.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  @override
  Future<Either<Failure, bool>> checkPassword(
      {required String password}) async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request = await sl<ApiClient>().getMethod(
        pathUrl: "/user/password-compare?userId=$uuid&password=$password",
        isHeader: true);
    if (request.isSuccess) {
      return Right(request.response);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> updatePassword(
      {required String oldPassword, required String newPassword}) async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request = await sl<ApiClient>().putMethod(
        pathUrl: "/user/change-password",
        body: {
          "userId": uuid,
          "oldPassword": oldPassword,
          "newPassword": newPassword,
          "confirmPassword": newPassword
        },
        isHeader: true);
    if(request.isSuccess){
      return Right(true);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}
