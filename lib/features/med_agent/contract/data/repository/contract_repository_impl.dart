import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/med_agent/contract/data/model/contract_model.dart';
import 'package:wm_doctor/features/med_agent/contract/domain/repository/contract_repository.dart';

import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/dependencies_injection.dart';

class ContractRepositoryImpl implements ContractRepository {
  @override
  Future<Either<Failure, List<ContractModel>>> getContract() async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/med-agent/$uuid/contracts", isHeader: true);
    if (request.isSuccess) {
      List<ContractModel> list = [];
      for (var item in request.response) {
        list.add(ContractModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}
