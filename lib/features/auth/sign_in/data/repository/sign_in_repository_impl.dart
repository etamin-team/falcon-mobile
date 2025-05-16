
import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/auth/sign_in/domain/repository/sign_in_repository.dart';

import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/dependencies_injection.dart';

class SignInRepositoryImpl implements SignInRepository {
  @override
  Future<Either<Failure, bool>> login(
      {required String number, required String password}) async {
    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/auth/login",
        body: {
          "number": number,
          "email": "",
          "isNumber": true,
          "password": password
        },
        isHeader: false);

    if (request.isSuccess && null != request.response) {
      debugPrint("token ==========>>>> ${request.response["access_token"]}");
      debugPrint("refresh token ==========>>>> ${request.response["refresh_token"]}");
      await SecureStorage().write(key: "number", value: number);
      await SecureStorage().write(key: "password", value: password);
      await SecureStorage().write(
          key: "accessToken",
          value: request.response["access_token"].toString());
      await SecureStorage().write(
          key: "refreshToken",
          value: request.response["refresh_token"].toString());
      return Right(true);
    }
    return Left(Failure(errorMsg: request.response.toString(), statusCode: request.code??500));
  }


}
