import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/utils/dependencies_injection.dart';
import '../../domain/repository/mnn_repository.dart';

class MnnRepositoryImpl implements MnnRepository{
  @override
  Future<Either<Failure, List<MnnModel>>> getMnn() async{
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/db/mnn/list", isHeader: true);
    print("-----------------------------------------------------");
    print("-----------------------------------------------------");
    print("-----------------------------------------------------");
    print("-----------------------------------------------------");

    if (request.isSuccess) {
      print(request.response.toString());
      List<MnnModel> list = [];
      for (var item in request.response) {
        list.add(MnnModel.fromJson(item));
      }
      print(list);
      return Right(list);
    }else print("No MNN found");
    return Left(Failure(errorMsg: request.response.toString(), statusCode: request.code??500));
  }

}