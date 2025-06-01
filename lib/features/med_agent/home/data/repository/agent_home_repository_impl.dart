import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/agent_goal_model.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/doctors_model.dart';
import 'package:wm_doctor/features/med_agent/home/domain/repository/agent_home_repository.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/dependencies_injection.dart';

class AgentHomeRepositoryImpl implements AgentHomeRepository {
  @override
  Future<Either<Failure, AgentGoalModel>> getAgentGoal() async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request = await sl<ApiClient>().getMethod(
        pathUrl: "/med-agent/goal/agent-id/$uuid", isHeader: true);
    if (request.isSuccess) {
      return Right(AgentGoalModel.fromJson(request.response));
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, List<DoctorsModel>>> getDoctors() async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/user/doctors?creatorId=$uuid", isHeader: true);
    if (request.isSuccess) {
      List<DoctorsModel> list = [];
      for (var item in request.response) {
        list.add(DoctorsModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  Future<Either<Failure, List<DoctorsModel>>> getDoctorsWithFilters(districtId, workplaceId, doctorType, withContracts)async {
    String url="/user/doctors?districtId=$districtId&workplaceId=$workplaceId&withContracts=$withContracts"+(doctorType==null||doctorType=='ALL'?'':'&field=$doctorType');
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: url, isHeader: true);
    if (request.isSuccess) {
      List<DoctorsModel> list = [];
      for (var item in request.response) {
        list.add(DoctorsModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}
