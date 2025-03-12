import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';

import '../../../home/data/model/template_model.dart';
import '../../data/model/upload_template_model.dart';

abstract class CreateTemplateRepository {
  Future<Either<Failure, List<MedicineModel>>> getMedicine();
  Future<Either<Failure, bool>> uploadTemplate({required UploadTemplateModel model});
  Future<Either<Failure, bool>> updateTemplate({required TemplateModel model});
}
