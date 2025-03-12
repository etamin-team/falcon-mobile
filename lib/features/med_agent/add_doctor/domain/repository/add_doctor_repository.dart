import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/add_contract_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/doctor_model.dart';

abstract class AddDoctorRepository {
  Future<Either<Failure, String>> addDoctor({required DoctorModel model});

  Future<Either<Failure, bool>> checkNumber({required String number});

  Future<Either<Failure, bool>> checkEmail({required String email});

  Future<Either<Failure, bool>> addContract({required AddContractModel model,required String doctorId});
}
