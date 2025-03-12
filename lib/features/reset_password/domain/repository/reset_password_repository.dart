import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, bool>> checkPassword({required String password});
  Future<Either<Failure, bool>> updatePassword({required String oldPassword,required String newPassword});
}
