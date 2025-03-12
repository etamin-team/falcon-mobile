import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';

import '../../../add_doctor/data/model/add_contract_model.dart';
import '../../data/model/edit_upload_model.dart';

abstract class EditContractRepository {
  Future<Either<Failure, bool>> updateContract(
      {required EditUploadModel model});
  Future<Either<Failure, bool>> addContract({required AddContractModel model,required String doctorId});
}
