import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/add_contract_model.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/data/model/edit_upload_model.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/domain/repository/edit_contract_reposiory.dart';

import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/dependencies_injection.dart';

class EditContractRepositoryImpl implements EditContractRepository {
  @override
  Future<Either<Failure, bool>> updateContract(
      {required EditUploadModel model}) async {
    final request = await sl<ApiClient>().putMethod(
        pathUrl: "/med-agent/doctor/update-contract/${model.id}",
        body: model.toJson(),
        isHeader: true);

    if (request.isSuccess) {
      return Right(true);
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
    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/med-agent/doctor/new-contract",
        body: model.toJson(),
        isHeader: true);

    if (request.isSuccess) {
      return Right(true);
    }

    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}
