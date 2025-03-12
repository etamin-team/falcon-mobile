import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/region_model.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';

abstract class SignUpRepository {
  Future<Either<Failure, List<RegionModel>>> getRegions();
  Future<Either<Failure, List<WorkplaceModel>>> getWorkplace();
  Future<Either<Failure, bool>> signUp({required Map<String,dynamic> data});
  Future<Either<Failure, bool>> login();

  Future<Either<Failure, bool>> checkNumber({required String number});
}
