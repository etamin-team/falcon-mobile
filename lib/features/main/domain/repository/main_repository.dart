import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';

abstract class MainRepository{
  Future<Either<Failure,String>>checkToken();
}