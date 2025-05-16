import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/add_contract_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/doctor_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/domain/repository/add_doctor_repository.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/dependencies_injection.dart';

class AddDoctorRepositoryImpl implements AddDoctorRepository {
  @override
  Future<Either<Failure, String>> addDoctor(
      {required DoctorModel model}) async {
    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/user/register-doctor", body: model.toJson(), isHeader: true);
    if (request.isSuccess) {
      return Right(request.response["userId"]);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> checkEmail({required String email}) async {
    final request = await sl<ApiClient>().getMethod(
        pathUrl: "/auth/is-email-exist?email=$email", isHeader: false);
    if (request.isSuccess) {
      bool isExist = request.response;
      return Right(isExist);
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
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> addContract(
      {required AddContractModel model, required String doctorId}) async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    model.doctorId = doctorId;
    model.agentId = uuid;
    print(model.toJson());
    final request = await sl<ApiClient>()
        .postMethod(pathUrl: "/med-agent/doctor/new-contract", body: model.toJson(), isHeader: true);

    if(request.isSuccess){
      return Right(true);
    }

    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}
