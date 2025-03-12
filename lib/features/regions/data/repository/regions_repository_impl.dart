import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/region_model.dart';
import 'package:wm_doctor/features/regions/domain/repository/region_repository.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/utils/dependencies_injection.dart';

class RegionsRepositoryImpl implements RegionsRepository {
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
    return Left(Failure(errorMsg: request.response.toString(), statusCode: request.code??500));
  }
}
