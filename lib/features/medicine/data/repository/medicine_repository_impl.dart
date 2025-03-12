import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/medicine/domain/repository/medicine_repository.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/utils/dependencies_injection.dart';

class MedicineRepositoryImpl implements MedicineRepository{
  @override
  Future<Either<Failure, List<MedicineModel>>> getMedicine() async{
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/db/medicines", isHeader: true);
    print("-----------------------------------------------------");
    print("-----------------------------------------------------");
    print("-----------------------------------------------------");
    print("-----------------------------------------------------");

    if (request.isSuccess) {
      print(request.response.toString());
      List<MedicineModel> list = [];
      for (var item in request.response) {
        list.add(MedicineModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(errorMsg: request.response.toString(), statusCode: request.code??500));
  }

}