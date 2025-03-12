import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';

import '../../data/model/recep_model.dart';

abstract class CreateRecepRepository {
  Future<Either<Failure, bool>> saveRecep({required RecepModel model});

  // Future<Either<Failure, TelegramUserModel>> getUserFromTelegram(
  //     {required String id});

  Future<Either<Failure, bool>> sendMessage(
      {required String number, required String message});
}
