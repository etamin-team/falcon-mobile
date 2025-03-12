import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../create_template/data/model/medicine_model.dart';

abstract class MedicineRepository {
  Future<Either<Failure, List<MedicineModel>>> getMedicine();
}
