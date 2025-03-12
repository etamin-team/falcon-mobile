import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/med_agent/profile/data/model/agent_profile_data_model.dart';
import 'package:wm_doctor/features/med_agent/profile/domain/repository/agent_profile_repository.dart';

import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/dependencies_injection.dart';

class AgentProfileRepositoryImpl implements AgentProfileRepository {
  @override
  Future<Either<Failure, AgentProfileDataModel>> getProfileData() async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/med-agent/statistics/$uuid", isHeader: true);
    if (request.isSuccess) {
      return Right(AgentProfileDataModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}
