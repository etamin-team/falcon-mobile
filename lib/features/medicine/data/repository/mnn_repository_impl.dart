import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/dependencies_injection.dart';
import '../../domain/repository/mnn_repository.dart';

class MnnRepositoryImpl implements MnnRepository {
  @override
  Future<Either<Failure, List<MnnModel>>> getMnn({int page = 1, int size = 10}) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/db/mnn/list-page?page=$page&size=$size", isHeader: true);
    if (request.isSuccess) {
      final List<dynamic> content = request.response['content'] ?? [];
      List<MnnModel> list = content.map((item) => MnnModel.fromJson(item)).toList();
      return Right(list);
    } else {
      return Left(Failure(errorMsg: request.response.toString(), statusCode: request.code ?? 500));
    }
  }
  @override
  Future<Either<Failure, List<MnnModel>>> getMnnSearch(query,{int page = 1, int size = 10}) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/db/mnn/list-page-search?query=$query&$page=$page&size=$size", isHeader: true);
    if (request.isSuccess) {
      final List<dynamic> content = request.response['content'] ?? [];
      List<MnnModel> list = content.map((item) => MnnModel.fromJson(item)).toList();
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}