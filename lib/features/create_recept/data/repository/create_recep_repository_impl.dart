import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/core/network/api_telegram_client.dart';
import 'package:wm_doctor/features/create_recept/data/model/recep_model.dart';
import 'package:wm_doctor/features/create_recept/domain/repository/create_recep_repository.dart';

import '../../../../core/utils/dependencies_injection.dart';

class CreateRecepRepositoryImpl implements CreateRecepRepository {
  @override
  Future<Either<Failure, bool>> saveRecep({required RecepModel model}) async {
    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/doctor/save-recipe", body: model.toJson(), isHeader: true);
    if (request.isSuccess) {
      return Right(true);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> sendMessage(
      {required String number, required String message}) async {
    try {
      final result = await sl<ApiTelegramClient>().sendMessage(
        number: number,
        message: message,
      );
      print(number);

      if (result) {
        print("th------------------------truuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuueeee");

        return Right(true);
      } else {
        return Left(Failure(errorMsg: "Failed to send message", statusCode: 500));
      }
    } catch (e) {
      return Left(Failure(errorMsg: e.toString(), statusCode: 500));
    }
  }
}
