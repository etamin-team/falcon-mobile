import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';
import 'package:wm_doctor/features/workplace/domain/repository/workplace_repositort.dart';

import '../../../../core/utils/dependencies_injection.dart';

class WorkplaceRepositoryImpl implements WorkplaceRepository {
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
}
